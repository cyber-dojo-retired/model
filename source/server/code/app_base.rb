# frozen_string_literal: true
require_relative 'silently'
require 'sinatra/base'
silently { require 'sinatra/contrib' } # N x "warning: method redefined"
require_relative 'http_json_hash/service_error'
require_relative 'lib/json_adapter'
require 'json'

class AppBase < Sinatra::Base

  silently { register Sinatra::Contrib }
  set :port, ENV['PORT']

  def initialize(externals)
    @externals = externals
    super(nil)
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  def self.get_json(name, klass)
    get "/#{name}", provides:[:json] do
      respond_to do |format|
        format.json {
          target = klass.new(@externals)
          result = target.public_send(name, **named_args)
          content_type(:json)
          "{\"#{name}\":#{result}}"
        }
      end
    end
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  def self.post_json(name, klass)
    post "/#{name}", provides:[:json] do
      respond_to do |format|
        format.json {
          target = klass.new(@externals)
          result = target.public_send(name, **named_args)
          content_type(:json)
          "{\"#{name}\":#{result}}"
        }
      end
    end
  end

  private

  include JsonAdapter

  def named_args
    if params.empty?
      args = json_hash_parse(request_body)
    else
      args = params
    end
    Hash[args.map{ |key,value| [key.to_sym, value] }]
  end

  def json_hash_parse(body)
    if body === ''
      body = '{}'
    end
    json = json_parse(body)
    unless json.instance_of?(Hash)
      fail 'body is not JSON Hash'
    end
    json
  rescue JSON::ParserError
    fail 'body is not JSON'
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  set :show_exceptions, false

  error do
    error = $!
    status(500)
    content_type('application/json')
    info = {
      exception: {
        request: {
          time: Time.now,
          path: utf8_clean(request.path),
          body: utf8_clean(request_body),
          params: request.params
        },
        backtrace: error.backtrace
      }
    }
    exception = info[:exception]
    if error.instance_of?(::HttpJsonHash::ServiceError)
      exception[:http_service] = {
        path: utf8_clean(error.path),
        args: error.args,
        name: utf8_clean(error.name),
        body: utf8_clean(error.body),
        message: utf8_clean(error.message)
      }
    else
      exception[:message] = error.message
    end
    diagnostic = json_pretty(info)
    puts(diagnostic)
    body(diagnostic)
  end

  def request_body
    body = request.body.read
    request.body.rewind # For idempotence
    body
  end

  def utf8_clean(s)
    # If encoding is already utf-8 then encoding to utf-8 is a
    # no-op and invalid byte sequences are not detected.
    # Forcing an encoding change detects invalid byte sequences.
    s = s.encode('UTF-16', 'UTF-8', :invalid => :replace, :replace => '')
    s = s.encode('UTF-8', 'UTF-16')
  end

end

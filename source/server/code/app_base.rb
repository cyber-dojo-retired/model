# frozen_string_literal: true
require_relative 'silently'
require 'sinatra/base'
silently { require 'sinatra/contrib' } # N x "warning: method redefined"
require_relative 'http_json_hash/service'
require_relative 'lib/json_adapter'
require 'json'
require 'sprockets'

class AppBase < Sinatra::Base

  def initialize(externals)
    @externals = externals
    super(nil)
  end

  silently { register Sinatra::Contrib }
  set :port, ENV['PORT']
  set :environment, Sprockets::Environment.new

  # - - - - - - - - - - - - - - - - - - - - - -

  def self.get_json(name, klass)
    get "/#{name}", provides:[:json] do
      respond_to do |format|
        format.json {
          target = klass.new(@externals)
          result = target.public_send(name, **named_args)
          content_type :json
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
          content_type :json
          "{\"#{name}\":#{result}}"
        }
      end
    end
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  def named_args
    if params.empty?
      args = json_hash_parse(request.body.read)
    else
      args = params
    end
    symbolized(args)
  end

  private

  include JsonAdapter # TODO: DROP

  def symbolized(h)
    # named-args require symbolization
    Hash[h.map{ |key,value| [key.to_sym, value] }]
  end

  def json_hash_parse(body)
    if body === ''
      body = '{}'
    end
    json = JSON.parse!(body)
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
          path:request.path,
          body:request.body.read,
          params:request.params
        },
        backtrace: error.backtrace
      }
    }
    exception = info[:exception]
    if error.instance_of?(::HttpJsonHash::ServiceError)
      exception[:http_service] = {
        path:error.path,
        args:error.args,
        name:error.name,
        body:error.body,
        message:error.message
      }
    else
      exception[:message] = error.message
    end
    diagnostic = json_pretty(info)
    puts diagnostic
    body diagnostic
  end

end

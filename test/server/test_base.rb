# frozen_string_literal: true
require_relative 'capture_stdout_stderr'
require_relative '../id58_test_base'
require_source 'app'
require_source 'externals'
require 'json'
require 'ostruct'

class TestBase < Id58TestBase

  include CaptureStdoutStderr
  include Rack::Test::Methods # [1]

  def app # [1]
    App.new(externals)
  end

  def externals
    @externals ||= Externals.new
  end

  # - - - - - - - - - - - - - - -

  def assert_get_200(path, &block)
    stdout,stderr = capture_stdout_stderr { get '/'+path }
    assert_status 200
    assert_json_content
    assert_equal '', stderr, :stderr
    assert_equal '', stdout, :sdout
    block.call(json_response)
  end

  def assert_get_500(path, &block)
    stdout,stderr = capture_stdout_stderr { get '/'+path }
    assert_status 500
    assert_json_content
    assert_equal '', stderr, :stderr
    assert_equal stdout, last_response.body+"\n", :stdout
    block.call(json_response)
  end

  # - - - - - - - - - - - - - - -

  def assert_status(expected)
    assert_equal expected, last_response.status, :last_response_status
  end

  def assert_json_content
    assert_equal 'application/json', last_response.headers['Content-Type']
  end

  def json_response
    JSON.parse(last_response.body)
  end

  # - - - - - - - - - - - - - - -

  class HttpAdapterStub
    def initialize(body)
      @body = body
    end
    def get(_uri)
      OpenStruct.new
    end
    def post(_uri)
      OpenStruct.new
    end
    def start(_hostname, _port, _req)
      self
    end
    attr_reader :body
  end

  def stub_saver_http(body)
    externals.instance_exec { @saver_http = HttpAdapterStub.new(body) }
  end

end

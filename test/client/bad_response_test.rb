# frozen_string_literal: true
require_relative 'test_base'
require 'ostruct'

class BadResponseTest < TestBase

  def self.id58_prefix
    'f28'
  end

  def id58_setup
    @display_name = custom_start_points.display_names.sample
    @custom_manifest = custom_start_points.manifest(display_name)
  end

  attr_reader :display_name, :custom_manifest

  # - - - - - - - - - - - - - - - - -

  test 'QN3', %w(
  |when an external http-proxy service
  |returns non-JSON in its response.body
  |an exception is raised
  ) do
    body = 'xxxx'
    message = 'body is not JSON'
    assert_raises_HttpJsonHash_ServiceError(body, message)
  end

  # - - - - - - - - - - - - - - - - -

  test 'QN4', %w(
  |when an external http-proxy service
  |returns JSON non-Hash in its response.body
  |an exception is raised
  ) do
    body = '[]'
    message = 'body is not JSON Hash'
    assert_raises_HttpJsonHash_ServiceError(body, message)
  end

  # - - - - - - - - - - - - - - - - -

  test 'QN5', %w(
  |when an external http-proxy service
  |returns JSON Hash with embedded exception in its response.body
  |an exception is raised
  ) do
    body = '{"exception":{}}'
    message = 'body has embedded exception'
    assert_raises_HttpJsonHash_ServiceError(body, message)
  end

  # - - - - - - - - - - - - - - - - -

  test 'QN6', %w(
  |when an external http-proxy service
  |returns JSON Hash with no key in its response.body matching the request path
  |an exception is raised
  ) do
    body = '{"not_request_path":42}'
    message = 'body is missing :path key'
    assert_raises_HttpJsonHash_ServiceError(body, message)
  end

  private

  def assert_raises_HttpJsonHash_ServiceError(body, message)
    stub_model_http(body)
    expected = HttpJsonHash::ServiceError.new(
      path='group_create',
      args={
        manifests:[custom_manifest],
        options:default_options
      },
      name='ExternalModel',
      body,
      message
    )
    error = nil
    capture_stdout_stderr {
      error = assert_raises(HttpJsonHash::ServiceError) {
        externals.model.group_create([custom_manifest], default_options)
      }
    }
    assert_equal expected, error
  end

  # - - - - - - - - - - - - - - - - -

  def stub_model_http(body)
    externals.instance_exec { @model_http = HttpAdapterStub.new(body) }
  end

  # - - - - - - - - - - - - - - - - -

  class HttpAdapterStub
    def initialize(body)
      @body = body
    end
    def post(_uri)
      OpenStruct.new
    end
    def start(_hostname, _port, _req)
      self
    end
    attr_reader :body
  end

end

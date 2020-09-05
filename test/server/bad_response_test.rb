# frozen_string_literal: true
require_relative 'test_base'
require 'ostruct'

class BadResponseTest < TestBase

  def self.id58_prefix
    'f28'
  end

  # - - - - - - - - - - - - - - - - -

  test 'QN8', %w(
  |when an external http-proxy service
  |returns JSON (but not Hash) in its response.body
  |is a 500 error
  ) do
    stub_saver_http(not_json='xxxx')

    display_name = custom_start_points.display_names.sample
    custom_manifest = custom_start_points.manifest(display_name)

    assert_json_post_500(
      path = 'group_create', {
        manifests:[custom_manifest],
        options:default_options
      }.to_json
    ) do |response|
      ex = response['exception']
      assert_equal '/group_create', ex['request']['path'], response
      assert_equal '', ex['request']['body'], response
      refute_nil ex['backtrace'], response
      http_service = ex['http_service']
      assert_equal 'body is not JSON', http_service['message'], response
      assert_equal not_json, http_service['body'], response
      assert_equal 'ExternalSaver', http_service['name'], response
      assert_equal 'run', http_service['path'], response
    end
  end

  private

  def stub_saver_http(body)
    externals.instance_exec { @saver_http = HttpAdapterStub.new(body) }
  end

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

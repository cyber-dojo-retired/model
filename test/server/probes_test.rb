# frozen_string_literal: true
require_relative 'test_base'
require 'ostruct'

class ProbesTest < TestBase

  def self.id58_prefix
    'a86'
  end

  # - - - - - - - - - - - - - - - - -
  # alive?

  test 'C15', %w(
  |GET/alive?
  |has status 200
  |returns true
  |and nothing else
  ) do
    assert_get_200(path='alive?') do |jr|
      assert_equal [path], jr.keys, "keys:#{last_response.body}:"
      assert true?(jr[path]), "true?:#{last_response.body}:"
    end
  end

  # - - - - - - - - - - - - - - - - -

  test 'F16', %w(
  |GET/alive?
  |is used by external k8s probes
  |so obeys Postel's Law
  |and ignores any passed arguments
  ) do
    assert_get_200('alive?arg=unused') do |jr|
      assert_equal ['alive?'], jr.keys, "keys:#{last_response.body}:"
      assert true?(jr['alive?']), "true?:#{last_response.body}:"
    end
  end

  # - - - - - - - - - - - - - - - - -
  # ready?

  test 'D15', %w(
  |when all http-services are ready
  |GET/ready?
  |has status 200
  |returns true
  |and nothing else
  ) do
    assert_get_200(path='ready?') do |jr|
      assert_equal [path], jr.keys, "keys:#{last_response.body}:"
      assert true?(jr[path]), "true?:#{last_response.body}:"
    end
  end

  # - - - - - - - - - - - - - - - - -

  test 'F15', %w(
  |when saver http-service is not ready
  |GET/ready?
  |has status 200
  |returns false
  |and nothing else
  ) do
    externals.instance_exec { @saver=STUB_READY_FALSE }
    assert_get_200(path='ready?') do |jr|
      assert_equal [path], jr.keys, "keys:#{last_response.body}:"
      assert false?(jr[path]), "false?:#{last_response.body}:"
    end
  end

  # - - - - - - - - - - - - - - - - -

  test 'F17', %w(
  |GET/ready?
  |is used by external k8s probes
  |so obeys Postel's Law
  |and ignores any passed arguments
  ) do
    assert_get_200('ready?arg=unused') do |jr|
      assert_equal ['ready?'], jr.keys, "keys:#{last_response.body}:"
      assert true?(jr['ready?']), "true?:#{last_response.body}:"
    end
  end

  # - - - - - - - - - - - - - - - - -
  # 500
  # - - - - - - - - - - - - - - - - -

  test 'QN4', %w(
  |when an external http-service
  |returns non-JSON in its response.body
  |GET/ready? is a 500 error
  ) do
    stub_saver_http('xxxx')
    assert_get_500('ready?') do |jr|
      assert_equal [ 'exception' ], jr.keys.sort, last_response.body
      #...
    end
  end

  # - - - - - - - - - - - - - - - - -

  test 'QN5', %w(
  |when an external http-service
  |returns JSON (but not a Hash) in its response.body
  |GET/ready? is a 500 error
  ) do
    stub_saver_http('[]')
    assert_get_500('ready?') do |jr|
      assert_equal [ 'exception' ], jr.keys.sort, last_response.body
      #...
    end
  end

  # - - - - - - - - - - - - - - - - -

  test 'QN6', %w(
  |when an external http-service
  |returns JSON-Hash in its response.body
  |which contains the key "exception"
  |GET/ready? is a 500 error
  ) do
    stub_saver_http(response='{"exception":42}')
    assert_get_500('ready?') do |jr|
      assert_equal [ 'exception' ], jr.keys.sort, last_response.body
      #...
    end
  end

  # - - - - - - - - - - - - - - - - -

  test 'QN7', %w(
  |when an external http-service
  |returns JSON-Hash in its response.body
  |which does not contain the "ready?" key
  |GET/ready? is a 500 error
  ) do
    stub_saver_http(response='{"wibble":42}')
    assert_get_500('ready?') do |jr|
      assert_equal [ 'exception' ], jr.keys.sort, last_response.body
      #...
    end
  end

  private

  STUB_READY_FALSE = OpenStruct.new(:ready? => false)

  def true?(b)
    b.instance_of?(TrueClass)
  end

  def false?(b)
    b.instance_of?(FalseClass)
  end

  # - - - - - - - - - - - - - - - - - - - -

  def stub_saver_http(body)
    externals.instance_exec {
      @saver_http = HttpAdapterStub.new(body)
    }
  end

  class HttpAdapterStub
    def initialize(body)
      @body = body
    end
    def get(_uri)
      OpenStruct.new
    end
    def start(_hostname, _port, _req)
      self
    end
    attr_reader :body
  end

end

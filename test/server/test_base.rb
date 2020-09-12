# frozen_string_literal: true
require_relative 'capture_stdout_stderr'
require_relative 'external_custom_start_points'
require_relative '../id58_test_base'
require_source 'app'
require_source 'externals'
require 'json'

class TestBase < Id58TestBase

  include CaptureStdoutStderr
  include Rack::Test::Methods # [1]

  def app # [1]
    App.new(externals)
  end

  def model
    Model.new(externals)
  end

  def custom_start_points
    ExternalCustomStartPoints.new
  end

  def saver
    externals.saver
  end

  def default_options
    { "line_numbers":true,
      "syntax_highlight":false,
      "predict_colour":false
    }
  end

  def externals
    @externals ||= Externals.new
  end

  # - - - - - - - - - - - - - - -

  def assert_get_200(path, &block)
    stdout,stderr = capture_stdout_stderr {
      get '/'+path
    }
    assert_status 200, stdout, stderr
    assert_equal '', stderr, :stderr
    assert_equal '', stdout, :sdout
    block.call(json_response_body)
  end

  def assert_get_500(path, &block)
    stdout,stderr = capture_stdout_stderr { get '/'+path }
    assert_status 500, stdout, stderr
    assert_equal '', stderr, :stderr
    assert_equal stdout, last_response.body+"\n", :stdout
    block.call(json_response_body)
  end

  def assert_json_post_200(path, body, &block)
    stdout,stderr = capture_stdout_stderr {
      json_post '/'+path, body
    }
    assert_status 200, stdout, stderr
    assert_equal '', stderr, :stderr
    assert_equal '', stdout, :stdout
    block.call(json_response_body)
  end

  def assert_json_post_500(path, body)
    stdout,stderr = capture_stdout_stderr { json_post '/'+path, body }
    assert_status 500, stdout, stderr
    assert_equal '', stderr, :stderr
    assert_equal stdout, last_response.body+"\n", :stdout
    if block_given?
      yield json_response_body
    end
  end

  # - - - - - - - - - - - - - - -

  def json_post(path, body)
    post path, body, JSON_REQUEST_HEADERS
  end

  JSON_REQUEST_HEADERS = {
    'CONTENT_TYPE' => 'application/json', # sending
    'HTTP_ACCEPT' => 'application/json'   # receive
  }

  def json_response_body
    assert_equal 'application/json', last_response.headers['Content-Type']
    JSON.parse(last_response.body)
  end

  # - - - - - - - - - - - - - - -

  def assert_status(expected, stdout, stderr)
    diagnostic = JSON.pretty_generate({
      stdout:stdout,
      stderr:stderr,
      'last_response.status': last_response.status
    })
    actual = last_response.status
    assert_equal expected, actual, diagnostic
  end

  # - - - - - - - - - - - - - - -

  def assert_group_exists(id, display_name, exercise_name=nil)
    refute_nil id, :id
    assert group_exists?(id), "!group_exists?(#{id})"
    manifest = group_manifest(id)
    assert_equal display_name, manifest['display_name'], manifest.keys.sort
    if exercise_name.nil?
      refute manifest.has_key?('exercise'), :exercise
    else
      assert_equal exercise_name, manifest['exercise'], :exercise
    end
  end

  def group_exists?(id)
    model.group_exists?(id:id)
  end

  def group_manifest(id)
    model.group_manifest(id:id)
  end

  # - - - - - - - - - - - - - - -

  def assert_kata_exists(id, display_name, exercise_name=nil)
    refute_nil id, :id
    assert kata_exists?(id), "!kata_exists?(#{id})"
    manifest = kata_manifest(id)
    assert_equal display_name, manifest['display_name'], manifest.keys.sort
    if exercise_name.nil?
      refute manifest.has_key?('exercise'), :exercise
    else
      assert_equal exercise_name, manifest['exercise'], :exercise
    end
  end

  def kata_exists?(id)
    model.kata_exists?(id:id)
  end

  def kata_manifest(id)
    model.kata_manifest(id:id)
  end

end

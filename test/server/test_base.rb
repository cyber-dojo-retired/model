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
    {}
  end

  def externals
    @externals ||= Externals.new
  end

  # - - - - - - - - - - - - - - -

  def group_create(manifest, options)
    id = model.group_create(manifests:[manifest], options:options)
    unquoted(id)
  end

  def group_exists?(id)
    model.group_exists?(id:id) # true|false
  end

  def group_manifest(id)
    JSON.parse(model.group_manifest(id:id))
  end

  AVATAR_INDEXES = (0..63).to_a

  def group_join(id, indexes=AVATAR_INDEXES.shuffle)
    id = model.group_join(id:id, indexes:indexes)
    id === 'null' ? nil : unquoted(id)
  end

  def group_joined(id)
    JSON.parse(model.group_joined(id:id))
  end

  def group_events(id)
    group_joined(id)
  end

  # - - - - - - - - - - - - - - -

  def kata_create(manifest, options)
    id = model.kata_create(manifest:manifest, options:options)
    unquoted(id)
  end

  def kata_exists?(id)
    model.kata_exists?(id:id) # true|false
  end

  def kata_manifest(id)
    JSON.parse(model.kata_manifest(id:id))
  end

  def katas_events(ids, indexes)
    JSON.parse(model.katas_events(ids:ids, indexes:indexes))
  end

  def kata_events(id)
    JSON.parse(model.kata_events(id:id))
  end

  def kata_event(id, index)
    JSON.parse(model.kata_event(id:id, index:index))
  end

  def kata_ran_tests(id, index, files, stdout, stderr, status, summary)
    model.kata_ran_tests(
      id:id, index:index,
      files:files, stdout:stdout, stderr:stderr, status:status,
      summary:summary
    )
  end

  def kata_predicted_right(id, index, files, stdout, stderr, status, summary)
    model.kata_predicted_right(
      id:id, index:index,
      files:files, stdout:stdout, stderr:stderr, status:status,
      summary:summary
    )
  end

  def kata_predicted_wrong(id, index, files, stdout, stderr, status, summary)
    model.kata_predicted_wrong(
      id:id, index:index,
      files:files, stdout:stdout, stderr:stderr, status:status,
      summary:summary
    )
  end

  def kata_reverted(id, index, files, stdout, stderr, status, summary)
    model.kata_reverted(
      id:id, index:index,
      files:files, stdout:stdout, stderr:stderr, status:status,
      summary:summary
    )
  end

  def kata_checked_out(id, index, files, stdout, stderr, status, summary)
    model.kata_checked_out(
      id:id, index:index,
      files:files, stdout:stdout, stderr:stderr, status:status,
      summary:summary
    )
  end

  def kata_option_get(id, name)
    model.kata_option_get(id:id, name:name)
  end

  def kata_option_set(id, name, value)
    model.kata_option_set(id:id, name:name, value:value)
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

  def assert_group_exists(id, display_name, exercise_name='')
    refute_nil id, :id
    assert group_exists?(id), "!group_exists?(#{id})"
    manifest = group_manifest(id)
    assert_equal display_name, manifest['display_name'], manifest.keys.sort
    assert_equal exercise_name, manifest['exercise'], :exercise
  end

  # - - - - - - - - - - - - - - -

  def assert_kata_exists(id, display_name, exercise_name='')
    refute_nil id, :id
    assert kata_exists?(id), "!kata_exists?(#{id})"
    manifest = kata_manifest(id)
    assert_equal display_name, manifest['display_name'], manifest.keys.sort
    assert_equal exercise_name, manifest['exercise'], :exercise
  end

  # - - - - - - - - - - - - - - -

  def self.v_tests(versions, id58_suffix, *lines, &test_block)
    versions.each do |version|
      v_lines = ["<version=#{version}>"] + lines
      test(id58_suffix + version.to_s, *v_lines, &test_block)
    end
  end

  def version
    if v_test?(0)
      return 0
    end
    if v_test?(1)
      return 1
    end
  end

  # - - - - - - - - - - - - - - - - - - -

  def v_test?(n)
    name58.start_with?("<version=#{n}>")
  end

  # - - - - - - - - - - - - - - - - - - -

  def unquoted(id)
    id[1..-2]
  end

end

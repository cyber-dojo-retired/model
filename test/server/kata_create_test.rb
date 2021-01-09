# frozen_string_literal: true
require_relative 'test_base'

class KataCreateTest < TestBase

  def self.id58_prefix
    'f26'
  end

  def id58_setup
    @display_name = custom_start_points.display_names.sample
    manifest = custom_start_points.manifest(display_name)
    manifest['version'] = version
    @custom_manifest = manifest
  end

  attr_reader :display_name, :custom_manifest

  v_tests [0,1], 'q32', %w(
  |POST /kata_create(manifest)
  |has status 200
  |returns the id: of a new kata
  |that exists in saver
  |with version 1
  |and a matching display_name
  ) do
    assert_json_post_200(
      path = 'kata_create', {
        manifest:custom_manifest,
        options:default_options
      }.to_json
    ) do |response|
      assert_equal [path], response.keys.sort, :keys
      id = response[path]
      assert_kata_exists(id, display_name)
      assert_equal version, kata_manifest(id)['version']
    end
  end

end

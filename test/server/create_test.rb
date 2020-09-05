# frozen_string_literal: true
require_relative 'test_base'
require_source 'id_generator'

class CreateTest < TestBase

  def self.id58_prefix
    'f26'
  end

  def id58_setup
    @display_name = custom_start_points.display_names.sample
    @custom_manifest = custom_start_points.manifest(display_name)
  end

  attr_reader :display_name, :custom_manifest

  # - - - - - - - - - - - - - - - - -

  test 'q31', %w(
  |POST /group_create(manifest)
  |has status 200
  |returns the id: of a new group
  |that exists in saver
  |whose manifest matches the display_name
  ) do
    assert_json_post_200(
      path = 'group_create', {
        manifests:[custom_manifest],
        options:default_options
      }.to_json
    ) do |response|
      assert_equal [path], response.keys.sort, :keys
      id = response[path]
      assert_group_exists(id, display_name)
    end
  end

  # - - - - - - - - - - - - - - - - -

  test 'q32', %w(
  |POST /kata_create(manifest)
  |has status 200
  |returns the id: of a new kata
  |that exists in saver
  |whose manifest matches the display_name
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
    end
  end

end

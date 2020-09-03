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
  |POST /create_group(manifest)
  |has status 200
  |returns the id: of a new group
  |that exists in saver
  |whose manifest matches the display_name
  ) do
    assert_json_post_200(
      path = 'create_group',
      args = {
        manifests:[custom_manifest],
        options:default_options
      }
    ) do |jrb|
      assert_equal [path], jrb.keys.sort, :keys
      id = jrb[path]
      assert_group_exists(id, display_name)
    end
  end

  # - - - - - - - - - - - - - - - - -

  test 'q32', %w(
  |POST /create_kata(manifest)
  |has status 200
  |returns the id: of a new kata
  |that exists in saver
  |whose manifest matches the display_name
  ) do
    assert_json_post_200(
      path = 'create_kata',
      args = {
        manifest:custom_manifest,
        options:default_options
      }
    ) do |jrb|
      assert_equal [path], jrb.keys.sort, :keys
      id = jrb[path]
      assert_kata_exists(id, display_name)
    end
  end

  private

  def default_options
    { "line_numbers":true,
      "syntax_highlight":false,
      "predict_colour":false
    }
  end

end

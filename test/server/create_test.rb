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

=begin
  # - - - - - - - - - - - - - - - - -
  # custom-exercise : Future use of display_names[] array
  # - - - - - - - - - - - - - - - - -

  qtest p44: %w(
  |POST /group_create_custom
  |display_names is an Array of Strings for planned feature
  |  where a group can be setup with a small number of display_names
  |  and you choose your individual display_names on joining.
  |options is a Hash of Symbol->Boolean|String
  |  {colour,theme,prediction}
  |  and is also for a planned feature
  |  where the options can be initialized at setup.
  ) do
    options = { colour:'on', theme:'dark', prediction:false }
    assert_json_post_200(
      path = 'group_create_custom',
      args = { display_names:[display_name,'unused'], options:options }
    ) do |jrb|
      assert_equal [path], jrb.keys.sort, :keys
      assert_group_exists(jrb[path], display_name)
    end
  end

  # - - - - - - - - - - - - - - - - -
  # new API - exercise + language
  # - - - - - - - - - - - - - - - - -

  qtest f31: %w(
  |POST /group_create
  |with exercise_name
  |that exists in exercises-start-points
  |with languages_names[] holding a single language_name
  |that exists in languages-start-points
  |has status 200
  |returns the id: of a new group
  |that exists in saver
  |whose manifest matches the exercise_name and language_name
  ) do
    assert_json_post_200(
      path = 'group_create',
      args = { exercise_name:exercise_name, languages_names:[language_name] }
    ) do |jrb|
      assert_equal [path], jrb.keys.sort, :keys
      assert_group_exists(jrb[path], language_name, exercise_name)
    end
  end

  # - - - - - - - - - - - - - - - - -

  qtest f32: %w(
  |POST /kata_create
  |with exercise_name
  |that exists in exercises-start-points
  |with languages_name
  |that exists in languages-start-points
  |has status 200
  |returns the id: of a new kata
  |that exists in saver
  |whose manifest matches the exercise_name and language_name
  ) do
    assert_json_post_200(
      path = 'kata_create',
      args = { exercise_name:exercise_name, language_name:language_name }
    ) do |jrb|
      assert_equal [path], jrb.keys.sort, :keys
      assert_kata_exists(jrb[path], language_name, exercise_name)
    end
  end

  # - - - - - - - - - - - - - - - - -
  # old API (deprecated)
  # - - - - - - - - - - - - - - - - -

  qtest De1: %w(
  |POST /deprecated_group_create_custom
  |with a single display_name
  |that exists in custom-start-points
  |has status 200
  |returns the id: of a new group
  |that exists in saver
  |whose manifest matches the display_name
  |and for backwards compatibility
  |it also returns the id against the :id key
  ) do
    assert_json_post_200(
      path = 'deprecated_group_create_custom',
      args = { display_name:display_name }
    ) do |jrb|
      assert_equal [path,'id'], jrb.keys.sort, :keys
      assert_group_exists(jrb['id'], display_name)
      assert_equal jrb[path], jrb['id'], :id
    end
  end

  # - - - - - - - - - - - - - - - - -

  qtest De2: %w(
  |POST /deprecated_kata_create_custom
  |with a single display_name
  |that exists in custom-start-points
  |has status 200
  |returns the id: of a new kata
  |that exists in saver
  |whose manifest matches the display_name
  |and for backwards compatibility
  |it also returns the id against the :id key
  ) do
    assert_json_post_200(
      path = 'deprecated_kata_create_custom',
      args = { display_name:display_name }
    ) do |jrb|
      assert_equal [path,'id'], jrb.keys.sort, :keys
      assert_kata_exists(jrb['id'], display_name)
      assert_equal jrb[path], jrb['id'], :id
    end
  end
=end

end

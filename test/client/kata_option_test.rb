# frozen_string_literal: true
require_relative 'test_base'

class KataOptionTest < TestBase

  def self.id58_prefix
    'f27'
  end

  def id58_setup
    display_name = custom_start_points.display_names.sample
    manifest = custom_start_points.manifest(display_name)
    @id = model.kata_create(manifest, default_options)
  end

  attr_reader :id

  # - - - - - - - - - - - - - - - - -

  test '460', %w(
  |kata_option_get('theme') defaults to 'light' as that is better on projectors
  ) do
    assert_equal 'light', kata_option_get('theme')
  end

  test '461', %w(
  |kata_option_set('theme', dark|light) sets the theme option
  |kata_option_get('theme') gets the theme option
  ) do
    kata_option_set('theme', 'dark')
    assert_equal 'dark', kata_option_get('theme')
    kata_option_set('theme', 'light')
    assert_equal 'light', kata_option_get('theme')
  end

  test '462', %w(
  kata_option_set('theme', not-dark-not-light) raises
  ) do
    capture_stdout_stderr {
      assert_raises { kata_option_set('theme', 'grey') }
    }
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '560', %w(
  |kata_option_get('colour') defaults to 'on'
  ) do
    assert_equal 'on', kata_option_get('colour')
  end

  test '561', %w(
  |kata_option_set('colour', on|off) sets the colour option
  |kata_option_get('colour') gets the colour option
  ) do
    kata_option_set('colour', 'on')
    assert_equal 'on', kata_option_get('colour')
    kata_option_set('colour', 'off')
    assert_equal 'off', kata_option_get('colour')
  end

  test '562', %w(
  kata_option_set('colour', not-on-not-off) raises
  ) do
    capture_stdout_stderr {
      assert_raises { kata_option_set('colour', 'blue') }
    }
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '660', %w(
  |kata_option_get('predict') defaults to 'off'
  ) do
    assert_equal 'off', kata_option_get('predict')
  end

  test '661', %w(
  |kata_option_set('predict', on|off) sets the predict option
  |kata_option_get('predict') gets the predict option
  ) do
    kata_option_set('predict', 'on')
    assert_equal 'on', kata_option_get('predict')
    kata_option_set('predict', 'off')
    assert_equal 'off', kata_option_get('predict')
  end

  test '662', %w(
  kata_option_set('predict', not-on-not-off) raises
  ) do
    capture_stdout_stderr {
      assert_raises { kata_option_set('predict', 'maybe') }
    }
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '760', %w(
  |kata_option_get('revert') defaults to 'off'
  ) do
    assert_equal 'off', kata_option_get('revert')
  end

  test '761', %w(
  |kata_option_set('revert', on|off) sets the revert option
  |kata_option_get('revert') gets the revert option
  ) do
    kata_option_set('revert', 'on')
    assert_equal 'on', kata_option_get('revert')
    kata_option_set('revert', 'off')
    assert_equal 'off', kata_option_get('revert')
  end

  test '762', %w(
  kata_option_set('revert', not-on-not-off) raises
  ) do
    capture_stdout_stderr {
      assert_raises { kata_option_set('revert', 'maybe') }
    }
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '860', %w(
  kata_option_get(unknown) raises
  ) do
    capture_stdout_stderr {
      assert_raises { kata_option_get('salmon') }
    }
  end

  test '861', %w(
  kata_option_set(unknown) raises
  ) do
    capture_stdout_stderr {
      assert_raises { kata_option_set('salmon', 'atlantic') }
    }
  end

  private

  def kata_option_get(name)
    model.kata_option_get(id, name)
  end

  def kata_option_set(name, value)
    model.kata_option_set(id, name, value)
  end

end

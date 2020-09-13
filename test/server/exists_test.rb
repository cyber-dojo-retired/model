# frozen_string_literal: true
require_relative 'test_base'

class ExistsTest < TestBase

  def self.id58_prefix
    'Ws5'
  end

  def id58_setup
    @display_name = custom_start_points.display_names.sample
    manifest = custom_start_points.manifest(display_name)
    manifest['version'] = version
    @custom_manifest = manifest
  end

  attr_reader :display_name, :custom_manifest

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '860', %w(
  |group_exists? is false,
  |for a well-formed id that does not exist
  ) do
    refute group_exists?('123AbZ')
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  v_tests [0,1], '861', %w(
  |group_exists? is true,
  |for a well-formed id that exists
  ) do
    id = model.group_create(manifests:[custom_manifest], options:default_options)
    assert group_exists?(id), :created_in_test
    assert group_exists?('chy6BJ'), :original_no_explicit_version
    assert group_exists?('FxWwrr'), :original_no_explicit_version
  end

  v_tests [0,1], '862', %w(
  |group_exists? is false,
  |for a malformed id
  ) do
    refute group_exists?(42), 'Integer'
    refute group_exists?(nil), 'nil'
    refute group_exists?([]), '[]'
    refute group_exists?({}), '{}'
    refute group_exists?(true), 'true'
    refute group_exists?(''), 'length == 0'
    refute group_exists?('12345'), 'length == 5'
    refute group_exists?('12345i'), '!id?()'
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  v_tests [0,1], '863', %w(
  |group_exists? raises,
  |when id is well-formed,
  |and saver is offline
  ) do
    externals.instance_exec {
      @saver = SaverExceptionRaiser.new
    }
    assert_raises {
      group_exists?('123AbZ')
    }
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '760', %w(
  |kata_exists? is false,
  |for a well-formed id that does not exist
  ) do
    refute kata_exists?('123AbZ')
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  v_tests [0,1], '761', %w(
  |kata_exists? is true,
  |for a well-formed id that exists
  ) do
    id = model.kata_create(manifest:custom_manifest, options:default_options)
    assert kata_exists?(id), :created_in_test
    assert kata_exists?('5rTJv5'), :original_no_explicit_version
    assert kata_exists?('k5ZTk0'), :original_no_explicit_version
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  v_tests [0,1], '762', %w(
  |kata_exists? is false,
  |for a malformed id
  ) do
    refute kata_exists?(42), 'Integer'
    refute kata_exists?(nil), 'nil'
    refute kata_exists?([]), '[]'
    refute kata_exists?({}), '{}'
    refute kata_exists?(true), 'true'
    refute kata_exists?(''), 'length == 0'
    refute kata_exists?('12345'), 'length == 5'
    refute kata_exists?('12345i'), '!id?()'
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  v_tests [0,1], '763', %w(
  |kata_exists? raises,
  |when id is well-formed,
  |and saver is offline
  ) do
    externals.instance_exec {
      @saver = SaverExceptionRaiser.new
    }
    assert_raises {
      kata_exists?('123AbZ')
    }
  end

  private

  def group_exists?(id)
    model.group_exists?(id:id)
  end

  def kata_exists?(id)
    model.kata_exists?(id:id)
  end

  class SaverExceptionRaiser
    def method_missing(_m, *_args, &_block)
      raise self.class.name
    end
  end

end

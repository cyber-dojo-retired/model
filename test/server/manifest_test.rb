# frozen_string_literal: true
require_relative 'test_base'

class ManifestTest < TestBase

  def self.id58_prefix
    '5Ks'
  end

  def id58_setup
    @display_name = custom_start_points.display_names.sample
    manifest = custom_start_points.manifest(display_name)
    manifest['version'] = version
    @custom_manifest = manifest
  end

  attr_reader :display_name, :custom_manifest

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  v_tests [0,1], '861', %w(
  retrieved group_manifest matches saved group_manifest
  ) do
    now = [2019,3,17, 7,13,36,3428]
    externals.instance_exec {
      @time = TimeStub.new(now)
    }
    manifest = custom_manifest
    id = model.group_create(manifests:[manifest], options:default_options)
    saved = model.group_manifest(id:id)
    manifest.keys.each do |key|
      assert_equal manifest[key], saved[key],  key
    end
    assert saved.keys.include?('created'), :created_key
    assert_equal now, saved['created'], :created
    assert saved.keys.include?('version'), :version_key
    assert_equal version, saved['version'], :version
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  v_tests [0,1], '862', %w(
  retrieved kata_manifest matches saved kata_manifest
  ) do
    now = [2018,11,30, 9,34,56,6453]
    externals.instance_exec {
      @time = TimeStub.new(now)
    }
    manifest = custom_manifest
    id = model.kata_create(manifest:manifest, options:default_options)
    saved = model.kata_manifest(id:id)
    manifest.keys.each do |key|
      assert_equal manifest[key], saved[key],  key
    end
    assert saved.keys.include?('created'), :created_key
    assert_equal now, saved['created'], :created
    assert saved.keys.include?('version'), :version_key
    assert_equal version, saved['version'], :version
  end

  private

  class TimeStub
    def initialize(now)
      @now = now
    end
    attr_reader :now
  end

end

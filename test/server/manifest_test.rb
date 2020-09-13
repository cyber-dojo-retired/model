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
    manifest = custom_manifest
    id = model.group_create(manifests:[manifest], options:default_options)
    saved = model.group_manifest(id:id)
    manifest.keys.each do |key|
      assert_equal manifest[key], saved[key],  key
    end
    assert saved.keys.include?('created'), :created
    assert saved.keys.include?('version'), :version
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  v_tests [0,1], '862', %w(
  retrieved kata_manifest matches saved kata_manifest
  ) do
    manifest = custom_manifest
    id = model.kata_create(manifest:manifest, options:default_options)
    saved = model.kata_manifest(id:id)
    manifest.keys.each do |key|
      assert_equal manifest[key], saved[key],  key
    end
    assert saved.keys.include?('created'), :created
    assert saved.keys.include?('version'), :version
  end

end

# frozen_string_literal: true
require_relative 'test_base'

class GroupManifestTest < TestBase

  def self.id58_prefix
    '6Ks'
  end

  def id58_setup
    display_name = custom_start_points.display_names.sample
    manifest = custom_start_points.manifest(display_name)
    manifest['version'] = version
    @custom_manifest = manifest
  end

  attr_reader :custom_manifest

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  v_tests [0], '472', %w(
  already existing group_manifest {test-data copied into saver}
  ) do
    manifest = group_manifest(id='chy6BJ')
    refute manifest.has_key?('version')
    assert_equal 'Ruby, MiniTest', manifest['display_name']
    assert_equal 'cyberdojofoundation/ruby_mini_test', manifest['image_name'], :pre_tagging
    assert_equal ['.rb'], manifest['filename_extension']
    assert_equal 2, manifest['tab_size']
    assert_equal [
      "test_hiker.rb",
      "hiker.rb",
      "cyber-dojo.sh",
      "coverage.rb",
      "readme.txt"
    ].sort, manifest['visible_files'].keys.sort, :keys
    assert_equal 'Count_Coins', manifest['exercise'], :exercise
    assert_equal 'chy6BJ', manifest['id'], :id
    refute_nil manifest['created'], :manifest
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  v_tests [0,1], 'Q61', %w(
  retrieved group_manifest matches saved group_manifest
  ) do
    manifest = custom_manifest
    id = group_create(manifest, default_options)
    saved = group_manifest(id)
    manifest.keys.each do |key|
      assert_equal manifest[key], saved[key],  key
    end
    assert saved.keys.include?('created'), :created_key
    assert saved.keys.include?('version'), :version_key
    assert_equal version, saved['version'], :version
  end

end

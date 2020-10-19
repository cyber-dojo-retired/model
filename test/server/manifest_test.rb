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

  v_tests [0], '472', %w(
  retrieve already existing group_manifest {test-data copied into saver}
  ) do
    manifest = model.group_manifest(id:'chy6BJ')
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
    ].sort, manifest['visible_files'].keys.sort
    assert_equal 'Count_Coins', manifest['exercise']
    assert_equal [2019,1,19,12,41,0,406370], manifest['created']
    assert_equal 'chy6BJ', manifest['id']
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  v_tests [0], '473', %w(
  retrieve already existing kata_manifest {test-data copied into saver}
  ) do
    manifest = model.kata_manifest(id:'5rTJv5')
    refute manifest.has_key?('version')
    assert_equal 'Ruby, MiniTest', manifest['display_name']
    assert_equal 'cyberdojofoundation/ruby_mini_test', manifest['image_name'], :pre_tagging
    assert_equal ['.rb'], manifest['filename_extension']
    assert_equal 2, manifest['tab_size']
    assert_equal 'ISBN', manifest['exercise']
    assert_equal [2019,1,16,12,44,55,800239], manifest['created']
    assert_equal 'FxWwrr', manifest['group_id']
    assert_equal 32, manifest['group_index']
    assert_equal '5rTJv5', manifest['id']
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
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

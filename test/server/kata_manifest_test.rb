# frozen_string_literal: true
require_relative 'test_base'

class KataManifestTest < TestBase

  def self.id58_prefix
    '5Ks'
  end

  def id58_setup
    display_name = custom_start_points.display_names.sample
    manifest = custom_start_points.manifest(display_name)
    manifest['version'] = version
    @custom_manifest = manifest
  end

  attr_reader :custom_manifest

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  v_tests [0], '473', %w(
  already existing kata_manifest {test-data copied into saver}
  is "polyfilled" to make it look like version=1
  ) do
    manifest = kata_manifest(id='5rTJv5')
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
    assert manifest.has_key?('visible_files'), :polyfilled_visible_files
    expected_filenames = [
      "test_hiker.rb",
      "hiker.rb",
      "cyber-dojo.sh",
      "coverage.rb",
      "readme.txt"
    ]
    assert_equal expected_filenames.sort, manifest['visible_files'].keys.sort
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  v_tests [0,1], '5s2', %w(
  optional entries are polyfilled ) do
    m = custom_manifest
    m.delete('tab_size')
    m.delete('highlight_filenames')
    assert_equal %w( display_name filename_extension image_name version visible_files ), m.keys.sort
    id = kata_create(m, default_options)
    manifest = kata_manifest(id)
    assert_equal '', manifest['exercise']
    assert_equal [], manifest['highlight_filenames']
    assert_equal  4, manifest['tab_size']
    assert_equal 10, manifest['max_seconds']
    assert_equal [], manifest['progress_regexs']
  end

end

# frozen_string_literal: true
require_relative 'test_base'

class JoinTest < TestBase

  def self.id58_prefix
    'Gw4'
  end

  def id58_setup
    @display_name = custom_start_points.display_names.sample
    manifest = custom_start_points.manifest(display_name)
    manifest['version'] = version
    @custom_manifest = manifest
  end

  attr_reader :display_name, :custom_manifest

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  v_tests [0,1], '1s9', %w(
  group is initially empty
  ) do
    manifest = custom_manifest
    id = group_create(manifest, default_options)
    avatars = group_avatars(id)
    assert_equal [], avatars
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  v_tests [0,1], '6A5', %w(
  when you join a group you increase its size by one,
  and are a member of the group
  ) do
    manifest = custom_manifest
    group_id = group_create(manifest, default_options)

    indexes = [15,4] + ((0..63).to_a - [15,4]).shuffle
    kata_1_id = group_join(group_id, indexes)
    assert kata_exists?(kata_1_id), kata_1_id
    kata_1_manifest = kata_manifest(kata_1_id)
    assert_equal kata_1_id, kata_1_manifest['id']
    assert_equal 15, kata_1_manifest['group_index']
    assert_equal group_id, kata_1_manifest['group_id']

    avatars_1 = group_avatars(group_id)
    assert_equal [[15,kata_1_id]], avatars_1

    kata_2_id = group_join(group_id, indexes)
    assert kata_exists?(kata_2_id), kata_2_id
    kata_2_manifest = kata_manifest(kata_2_id)
    assert_equal kata_2_id, kata_2_manifest['id']
    assert_equal 4, kata_2_manifest['group_index']
    assert_equal group_id, kata_2_manifest['group_id']

    avatars_2 = group_avatars(group_id)
    assert_equal [[4,kata_2_id],[15,kata_1_id]], avatars_2
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  v_tests [0,1], '6A6', %w(
  you can join 64 times and then the group is full
  ) do
    externals.instance_exec {
      @saver = SaverFake.new(self)
    }
    manifest = custom_manifest
    group_id = group_create(manifest, default_options)
    indexes = (0..63).to_a.shuffle
    expected_ids = []
    64.times do
      kata_id = group_join(group_id, indexes)
      refute_nil kata_id, :not_full
      expected_ids << kata_id
    end
    kata_id = group_join(group_id, indexes)
    assert_nil kata_id, :full

    expected_indexes = (0..63).to_a
    avatars = group_avatars(group_id)
    actual_indexes,actual_ids = *avatars.transpose
    assert_equal expected_indexes, actual_indexes.sort
    assert_equal expected_ids.sort, actual_ids.sort
  end

end

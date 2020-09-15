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
    id = model.group_create(manifests:[manifest], options:default_options)
    avatars = model.group_avatars(id:id)
    assert_equal [], avatars
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  v_tests [0,1], '6A5', %w(
  when you join a group you increase its size by one,
  and are a member of the group
  ) do
    manifest = custom_manifest
    group_id = model.group_create(manifests:[manifest], options:default_options)

    indexes = [15,4] + ((0..63).to_a - [15,4]).shuffle
    kata_1_id = model.group_join(id:group_id, indexes:indexes)

    assert model.kata_exists?(id:kata_1_id), kata_1_id
    kata_1_manifest = model.kata_manifest(id:kata_1_id)
    assert_equal kata_1_id, kata_1_manifest['id']
    assert_equal 15, kata_1_manifest['group_index']
    assert_equal group_id, kata_1_manifest['group_id']

    avatars_1 = model.group_avatars(id:group_id)
    assert_equal [[15,kata_1_id]], avatars_1

    kata_2_id = model.group_join(id:group_id, indexes:indexes)
    assert model.kata_exists?(id:kata_2_id), kata_2_id
    kata_2_manifest = model.kata_manifest(id:kata_2_id)
    assert_equal kata_2_id, kata_2_manifest['id']
    assert_equal 4, kata_2_manifest['group_index']
    assert_equal group_id, kata_2_manifest['group_id']

    avatars_2 = model.group_avatars(id:group_id)
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
    group_id = model.group_create(manifests:[manifest], options:default_options)
    indexes = (0..63).to_a.shuffle
    expected_ids = []
    64.times do
      kata_id = model.group_join(id:group_id, indexes:indexes)
      refute_nil kata_id
      expected_ids << kata_id
    end
    kata_id = model.group_join(id:group_id, indexes:indexes)
    assert_nil kata_id

    expected_indexes = (0..63).to_a
    avatars = model.group_avatars(id:group_id)
    actual_indexes,actual_ids = *avatars.transpose
    assert_equal expected_indexes, actual_indexes.sort
    assert_equal expected_ids.sort, actual_ids.sort
  end

end

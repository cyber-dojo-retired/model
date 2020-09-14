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
    gid = model.group_create(manifests:[manifest], options:default_options)

    indexes = [15,4] + ((0..63).to_a - [15,4]).shuffle
    avatar_index_1,kata_1 = *model.group_join(id:gid, indexes:indexes)
    assert_equal 15, avatar_index_1
    assert model.kata_exists?(id:kata_1), kata_1
    kata_1_manifest = model.kata_manifest(id:kata_1)
    assert_equal 15, kata_1_manifest['group_index']
    assert_equal gid, kata_1_manifest['group_id']

    avatars_1 = model.group_avatars(id:gid)
    assert_equal [[15,kata_1]], avatars_1

    avatar_index_2,kata_2 = *model.group_join(id:gid, indexes:indexes)
    assert_equal 4, avatar_index_2
    assert model.kata_exists?(id:kata_2), kata_2
    kata_2_manifest = model.kata_manifest(id:kata_2)
    assert_equal 4, kata_2_manifest['group_index']
    assert_equal gid, kata_2_manifest['group_id']

    avatars_2 = model.group_avatars(id:gid)
    assert_equal [[4,kata_2],[15,kata_1]], avatars_2
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  v_tests [0,1], '6A6', %w(
  you can join 64 times and then the group is full
  ) do
    externals.instance_exec {
      @saver = SaverFake.new(self)
    }
    manifest = custom_manifest
    gid = model.group_create(manifests:[manifest], options:default_options)
    indexes = (0..63).to_a.shuffle
    avatars = []
    64.times do
      result = model.group_join(id:gid, indexes:indexes)
      refute_nil result
      avatars << result[0]
    end
    assert_equal (0..63).to_a, avatars.sort
    result = model.group_join(id:gid, indexes:indexes)
    assert_nil result
  end

end

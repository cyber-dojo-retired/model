# frozen_string_literal: true
require_relative 'id_generator'
require_relative 'id_pather'
require_relative 'kata_v1'
require_relative 'oj_adapter'

# 1. Manifest now has explicit version (1)
# 2. joined() now does 1 read, not 64 reads.
# 3. No longer stores JSON in pretty format.
# 4. No longer stores file contents in lined format.
# 5. Uses Oj as its JSON gem.

class Group_v1

  def initialize(externals)
    @kata = Kata_v1.new(externals)
    @externals = externals
  end

  # - - - - - - - - - - - - - - - - - - -

  def exists?(id)
    dirname = group_id_path(id)
    command = saver.dir_exists_command(dirname)
    saver.run(command)
  end

  # - - - - - - - - - - - - - - - - - - -

  def create(manifest, options)
    planned_feature(options)
    manifest['version'] = 1
    manifest['created'] = time.now
    id = manifest['id'] = IdGenerator.new(@externals).group_id
    saver.assert_all([
      manifest_create_command(id, json_plain(manifest)),
      katas_create_command(id, '')
    ])
    id
  end

  # - - - - - - - - - - - - - - - - - - -

  def manifest(id)
    manifest_src = saver.assert(manifest_read_command(id))
    json_parse(manifest_src)
  end

  private

  include IdPather
  include OjAdapter

  def planned_feature(_options)
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  def katas_ids(katas_indexes)
    katas_indexes.map{ |kata_id,_| kata_id }
  end

  # - - - - - - - - - - - - - - - - - - -

  def katas_indexes(id)
    katas_src = saver.assert(katas_read_command(id))
    # G2ws77 15
    # w34rd5 2
    # ...
    katas_src
      .split
      .each_slice(2)
      .map{|kid,kindex| [kid,kindex.to_i] }
      .sort{|lhs,rhs| lhs[1] <=> rhs[1] }
    # [
    #   ['w34rd5', 2], #  2 == bat
    #   ['G2ws77',15], # 15 == fox
    #   ...
    # ]
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  def dir_make_command(id, *parts)
    saver.dir_make_command(dirname(id, *parts))
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  def manifest_create_command(id, manifest_src)
    saver.file_create_command(manifest_filename(id), manifest_src)
  end

  def manifest_read_command(id)
    saver.file_read_command(manifest_filename(id))
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  def katas_create_command(id, src)
    saver.file_create_command(katas_filename(id), src)
  end

  def katas_append_command(id, src)
    saver.file_append_command(katas_filename(id), src)
  end

  def katas_read_command(id)
    saver.file_read_command(katas_filename(id))
  end

  # - - - - - - - - - - - - - -
  # names of dirs/files

  def dirname(id, *parts)
    group_id_path(id, *parts)
    # eg id == 'wAtCfj' ==> '/cyber-dojo/groups/wA/tC/fj'
  end

  def manifest_filename(id)
    group_id_path(id, 'manifest.json')
    # eg id == 'wAtCfj' ==> '/cyber-dojo/groups/wA/tC/fj/manifest.json'
    # eg content ==> {"display_name":"Ruby, MiniTest",...}
  end

  def katas_filename(id)
    group_id_path(id, 'katas.txt')
    # eg id == 'wAtCfj' ==> '/cyber-dojo/groups/wA/tC/fj/katas.txt'
    # eg content ==>
    # SyG9sT 50
    # zhTLfa 32
  end

  # - - - - - - - - - - - - - -

  def saver
    @externals.saver
  end

  def time
    @externals.time
  end

end

# frozen_string_literal: true
require_relative 'id_generator'
require_relative 'id_pather'
require_relative 'kata_v0'
require_relative 'liner_v0'
require_relative 'oj_adapter'

class Group_v0

  def initialize(externals)
    @kata = Kata_v0.new(externals)
    @externals = externals
  end

  # - - - - - - - - - - - - - - - - - - -

  def create(manifest, options)
    planned_feature(options)
    manifest['version'] = 0
    manifest['created'] = time.now
    id = manifest['id'] = IdGenerator.new(@externals).group_id
    manifest['visible_files'] = lined_files(manifest['visible_files'])
    saver.assert(manifest_create_command(id, json_plain(manifest)))
    id
  end

  # - - - - - - - - - - - - - - - - - - -

  def manifest(id)
    manifest_src = saver.assert(manifest_read_command(id))
    manifest = json_parse(manifest_src)
    manifest['visible_files'] = unlined_files(manifest['visible_files'])
    manifest
  end

  private

  include IdPather
  include Liner_v0
  include OjAdapter

  def planned_feature(_options)
  end

  # - - - - - - - - - - - - - - - - - - -

  def katas_ids(katas_indexes)
    katas_indexes.map{ |kata_id,_| kata_id }
  end

  # - - - - - - - - - - - - - - - - - - -

  def katas_indexes(id)
    read_commands = (0..63).map do |index|
      saver.file_read_command(kata_id_filename(id, index))
    end
    reads = saver.run_all(read_commands)
    # reads is an array of 64 entries, eg
    # [
    #    nil,      # 0
    #    nil,      # 1
    #    'w34rd5', # 2
    #    nil,      # 3
    #    'G2ws77', # 4
    #    nil
    #    ...
    # ]
    # indicating there are joined animals at indexes
    # 2 (bat) id == w34rd5
    # 4 (bee) id == G2ws77
    reads.each.with_index(0).select{ |kid,_| kid }
    # [
    #   ['w34rd5', 2], #  2 == bat
    #   ['G2ws77',15], # 15 == fox
    #   ...
    # ]
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  def dir_make_command(id, *parts)
    saver.dir_make_command(group_id_path(id, *parts))
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  def manifest_create_command(id, manifest_src)
    saver.file_create_command(manifest_filename(id), manifest_src)
  end

  def manifest_read_command(id)
    saver.file_read_command(manifest_filename(id))
  end

  # - - - - - - - - - - - - - -
  # names of files

  def manifest_filename(id)
    group_id_path(id, 'manifest.json')
    # eg id == 'chy6BJ' ==> '/cyber-dojo/groups/ch/y6/BJ/manifest.json'
    # eg content ==> {"display_name":"Ruby, MiniTest",...}
  end

  def kata_id_filename(id, index)
    group_id_path(id, index, 'kata.id')
    # eg id == 'chy6BJ', index == 11 ==> '/cyber-dojo/groups/ch/y6/BJ/11/kata.id'
    # eg content ==> 'k5ZTk0'
  end

  # - - - - - - - - - - - - - -

  def events_parse(s)
    json_parse('[' + s.lines.join(',') + ']')
    # Alternative implementation, which tests show is slower.
    # s.lines.map { |line| json_parse(line) }
  end

  # - - - - - - - - - - - - - -

  def saver
    @externals.saver
  end

  def time
    @externals.time
  end

end

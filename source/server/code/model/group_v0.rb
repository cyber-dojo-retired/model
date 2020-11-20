# frozen_string_literal: true
require_relative 'id_generator'
require_relative 'id_pather'
require_relative 'kata_v0'
require_relative 'liner_v0'
require_relative '../lib/json_adapter'

class Group_v0

  def initialize(externals)
    @kata = Kata_v0.new(externals)
    @externals = externals
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  def create(manifest, options)
    # Groups created in cyber-dojo are now always version 1.
    # The ability to create version 0 groups is retained for testing.
    manifest = manifest.clone
    planned_feature(options)
    manifest['version'] = 0
    manifest['created'] = time.now
    id = manifest['id'] = IdGenerator.new(@externals).group_id
    manifest['visible_files'] = lined_files(manifest['visible_files'])
    saver.assert(manifest_create_command(id, json_plain(manifest)))
    quoted(id)
  end

  # - - - - - - - - - - - - - - - - - - -

  def manifest(id)
    json_plain(json_manifest(id))
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  def join(id, indexes)
    manifest = self.json_manifest(id)
    manifest.delete('id')
    manifest['group_id'] = id
    commands = indexes.map{ |index| dir_make_command(id, index) }
    results = saver.run_until_true(commands)
    result_index = results.find_index(true)
    if result_index.nil?
      'null' # full
    else
      index = indexes[result_index]
      manifest['group_index'] = index
      kata_id = @kata.create(manifest, default_options)
      saver.assert(saver.file_create_command(kata_id_filename(id, index), unquoted(kata_id)))
      kata_id # already quoted
    end
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  def avatars(id)
    json_plain(katas_indexes(id))
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  def events(id)
    results = {}
    indexes = katas_indexes(id)
    # read the events summary file for each avatar
    read_events_files_commands = katas_ids(indexes).map do |kata_id|
      # eg reads file /cyber-dojo/katas/k5/ZT/k0/events.json
      @kata.send(:events_file_read_command, kata_id)
    end
    katas_events = saver.assert_all(read_events_files_commands)
    indexes.each.with_index(0) do |(group_index,kata_id),index|
      results[group_index] = {
        'id' => kata_id,
        'events' => events_parse(katas_events[index])
      }
    end
    json_plain(results) # TODO: build json directly?
  end

  private

  include IdPather
  include Liner_v0
  include JsonAdapter

  def planned_feature(_options)
  end

  # - - - - - - - - - - - - - - - - - - -

  def default_options
    { "line_numbers":true,
      "syntax_highlight":false,
      "predict_colour":false
    }
  end

  # - - - - - - - - - - - - - - - - - - -

  def quoted(s)
    '"' + s + '"'
  end

  def unquoted(s)
    s[1..-2]
  end

  # - - - - - - - - - - - - - - - - - - -

  def json_manifest(id)
    manifest_src = saver.assert(manifest_read_command(id))
    manifest = json_parse(manifest_src)
    manifest['visible_files'] = unlined_files(manifest['visible_files'])
    manifest
  end

  def katas_ids(katas_indexes)
    katas_indexes.map{ |_,kata_id| kata_id }
  end

  def katas_indexes(id)
    # In version-1 this is a single command
    read_commands = (0..63).map do |index|
      saver.file_read_command(kata_id_filename(id, index))
    end
    kata_ids = saver.run_all(read_commands)
    # kata_ids is an array of entries, eg
    # [
    #    nil,      # 0
    #    nil,      # 1
    #    'w34rd5', # 2
    #    nil,      # 3
    #    'G2ws77', # 4
    #    nil,      # 5
    #    ...
    # ]
    # indicating there are joined animals at group-indexes
    # 2 (bat) kata_id == w34rd5
    # 4 (bee) kata_id == G2ws77
    # etc
    kata_ids.filter_map
            .with_index(0) { |kata_id,group_index|
              [group_index,kata_id] if kata_id
            }
    # [
    #   [ 2,'w34rd5'], #  2 == bat
    #   [15,'G2ws77'], # 15 == fox
    #   ...
    # ]
  end

  # - - - - - - - - - - - - - - - - - - -

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

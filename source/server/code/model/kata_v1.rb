# frozen_string_literal: true
require_relative 'id_generator'
require_relative 'id_pather'
require_relative '../lib/json_adapter'

# 1. Manifest now has explicit version (1)
# 2. Manifest is retrieved in single read call.
# 3. No longer stores JSON in pretty format.
# 4. No longer stores file contents in lined format.
# 5. Uses Oj as its JSON gem.
# 6. Stores explicit index in events.json summary file.
#    This improves robustness when there are Saver outages.
#    For example index==-1.
#    was    { ... } # 0
#           { ... } # 1
#    then 2-23 outage
#           { ... } # 24
#    now    { ..., "index" => 0 }
#           { ..., "index" => 1 }
#           { ..., "index" => 24 }
# 7. No longer uses separate dir for each event file.
#    This makes ran_tests() faster as it no longer needs
#    a create_command() in its saver.assert_all() call.
#    was     /cyber-dojo/katas/e3/T6/K2/0/event.json
#    now     /cyber-dojo/katas/e3/T6/K2/0.event.json

class Kata_v1

  def initialize(externals)
    @externals = externals
  end

  # - - - - - - - - - - - - - - - - - - -

  def exists?(id)
    unless IdGenerator::id?(id)
      return false
    end
    dirname = kata_id_path(id)
    command = saver.dir_exists_command(dirname)
    saver.run(command)
  end

  # - - - - - - - - - - - - - - - - - - -

  def create(manifest, options)
    planned_feature(options)
    manifest['version'] = 1
    manifest['created'] = time.now
    id = manifest['id'] = IdGenerator.new(@externals).kata_id
    event_summary = {
      'index' => 0,
      'time' => manifest['created'],
      'event' => 'created'
    }
    event0 = {
      'files' => manifest['visible_files']
    }
    saver.assert_all([
      manifest_file_create_command(id, json_plain(manifest)),
      events_file_create_command(id, json_plain(event_summary)),
      event_file_create_command(id, 0, json_plain(event0.merge(event_summary)))
    ])
    id
  end

  # - - - - - - - - - - - - - - - - - - -

  def manifest(id)
    manifest_src = saver.assert(manifest_file_read_command(id))
    json_parse(manifest_src)
  end

  # - - - - - - - - - - - - - - - - - - - - - -
  # ...

  private

  include IdPather
  include JsonAdapter

  def planned_feature(_options)
  end

  # - - - - - - - - - - - - - - - - - - - - - -
  # manifest
  #
  # In theory the manifest could store only the display_name
  # and exercise_name and be recreated, on-demand, from the relevant
  # start-point services. In practice it creates coupling, and it
  # doesn't work anyway, since start-point services change over time.

  def manifest_file_create_command(id, manifest_src)
    saver.file_create_command(manifest_filename(id), manifest_src)
  end

  def manifest_file_read_command(id)
    saver.file_read_command(manifest_filename(id))
  end

  # - - - - - - - - - - - - - - - - - - - - - -
  # events

  def events_file_create_command(id, event0_src)
    saver.file_create_command(events_filename(id), event0_src)
  end

  #def events_file_append_command(id, eventN_src)
  #  saver.file_append_command(events_filename(id), eventN_src)
  #end

  #def events_file_read_command(id)
  #  saver.file_read_command(events_filename(id))
  #end

  # - - - - - - - - - - - - - - - - - - - - - -
  # event

  def event_file_create_command(id, index, event_src)
    saver.file_create_command(event_filename(id,index), event_src)
  end

  #def event_file_read_command(id, index)
  #  saver.file_read_command(event_filename(id,index))
  #end

  # - - - - - - - - - - - - - -
  # names of dirs/files

  def manifest_filename(id)
    kata_id_path(id, 'manifest.json')
    # eg id == 'SyG9sT' ==> '/cyber-dojo/katas/Sy/G9/sT/manifest.json'
    # eg content ==> {"display_name":"Ruby, MiniTest",...}
  end

  def events_filename(id)
    kata_id_path(id, 'events.json')
    # eg id == 'SyG9sT' ==> '/cyber-dojo/katas/Sy/G9/sT/events.json'
    # eg content ==>
    # {"index":0,...,"event":"created"},
    # {"index":1,...,"colour":"red"},
    # {"index":2,...,"colour":"amber"},
  end

  def event_filename(id, index)
    kata_id_path(id, "#{index}.event.json")
    # eg id == 'SyG9sT', index == 2 ==> '/cyber-dojo/katas/Sy/G9/sT/2.event.json'
    # eg content ==>
    # {
    #   "files":{
    #     "hiker.rb":{"content":"......","truncated":false},
    #     ...
    #   },
    #   "stdout":{"content":"...","truncated":false},
    #   "stderr":{"content":"...","truncated":false},
    #   "status":1,
    #   "index":2,
    #   "time":[2020,3,27,11,56,7,719235],
    #   "duration":1.064011,
    #   "colour":"amber"
    # }
  end

  # - - - - - - - - - - - - - -

  def saver
    @externals.saver
  end

  def time
    @externals.time
  end

end

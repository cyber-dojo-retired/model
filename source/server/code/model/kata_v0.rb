# frozen_string_literal: true
require_relative 'id_generator'
require_relative 'id_pather'
require_relative 'liner_v0'
require_relative '../lib/json_adapter'

class Kata_v0

  def initialize(externals)
    @externals = externals
  end

  # - - - - - - - - - - - - - - - - - - -

  #...

  # - - - - - - - - - - - - - - - - - - -

  def create(manifest, options)
    manifest = manifest.clone
    planned_feature(options)
    manifest['version'] = 0
    manifest['created'] = time.now
    id = manifest['id'] = IdGenerator.new(@externals).kata_id
    files = manifest.delete('visible_files')
    event0 = {
      'event' => 'created',
      'time' => manifest['created']
    }
    saver.assert_all([
      dir_make_command(id, 0),
      manifest_file_create_command(id, json_plain(manifest)),
      event_file_create_command(id, 0, json_plain(lined({ 'files' => files }))),
      events_file_create_command(id, json_plain(event0) + "\n")
    ])
    '"' + id + '"'
  end

  # - - - - - - - - - - - - - - - - - - -

  def manifest(id)
     manifest_src,event0_src = saver.assert_all([
      manifest_file_read_command(id),
      event_file_read_command(id, 0)
    ])
    manifest = json_parse(manifest_src)
    # polyfill to version==1
    event0 = unlined(json_parse(event0_src))
    manifest['visible_files'] = event0['files']
    json_plain(manifest)
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  def events(id)
    result = saver.assert(events_file_read_command(id))
    json = json_parse('[' + result.lines.join(',') + ']')
    # polyfill to version==1
    json.map.with_index(0) do |h,index|
      h['index'] = index
      if h.has_key?('colour')
        h['predicted'] = 'none'
      end
    end
    json_plain(json)
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  def event(id, index)
    index = index.to_i
    if index === -1
      all = json_parse(events(id))
      index = all[-1]['index']
    end
    results = saver.assert_all([
      events_file_read_command(id),
      event_file_read_command(id, index)
    ])
    events = json_parse('[' + results[0].lines.join(',') + ']')
    json = unlined(json_parse(results[1]))
    # polyfill to version==1
    if json.has_key?('status')
      json['status'] = json['status'].to_s
    end
    if index === 0
      json['event'] = 'created'
    end
    if events[index].has_key?('colour')
      json['colour'] = events[index]['colour']
      json['duration'] = events[index]['duration']
      json['predicted'] = 'none'
    end
    json['index'] = index
    json['time'] = events[index]['time']
    json_plain(json)
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  def ran_tests(id, index, files, stdout, stderr, status, summary)
    summary['time'] = time.now
    event_n = {
      'files' => files,
      'stdout' => stdout,
      'stderr' => stderr,
      'status' => status
    }
    result = saver.assert_all([
      # A failing make_command() ensures the append_command() is not run.
      dir_exists_command(id),
      dir_make_command(id, index),
      event_file_create_command(id, index, json_plain(lined(event_n))),
      events_file_append_command(id, json_plain(summary) + "\n")
    ])
    json_plain(result)
  end

  private

  include IdPather
  include JsonAdapter
  include Liner_v0

  def planned_feature(_options)
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  def dir_make_command(id, *parts)
    saver.dir_make_command(dir_name(id, *parts))
  end

  def dir_exists_command(id, *parts)
    saver.dir_exists_command(dir_name(id, *parts))
  end

  # - - - - - - - - - - - - - - - - - - - - - -
  # manifest
  #
  # Extracts the visible_files from the manifest and
  # stores them as event-zero files. This allows a diff of the
  # first traffic-light but means manifest() has to recombine two
  # files. In theory the manifest could store only the display_name
  # and exercise_name and be recreated, on-demand, from the relevant
  # start-point services. In practice, it doesn't work because the
  # start-point services can change over time.

  def manifest_file_create_command(id, manifest_src)
    saver.file_create_command(manifest_filename(id), manifest_src)
  end

  def manifest_file_read_command(id)
    saver.file_read_command(manifest_filename(id))
  end

  # - - - - - - - - - - - - - - - - - - - - - -
  # events
  #
  # A cache of colours/time-stamps for all [test] events.
  # Helps optimize dashboard traffic-lights views.
  # Each event is stored as a single "\n" terminated line.
  # This is an optimization for ran_tests() which need only
  # append to the end of the file.

  def events_file_create_command(id, event0_src)
    saver.file_create_command(events_filename(id), event0_src)
  end

  def events_file_append_command(id, eventN_src)
    saver.file_append_command(events_filename(id), eventN_src)
  end

  def events_file_read_command(id)
    saver.file_read_command(events_filename(id))
  end

  # - - - - - - - - - - - - - - - - - - - - - -
  # event
  #
  # The visible-files are stored in a lined-format so they be easily
  # inspected on disk. Have to be unlined when read back.

  def event_file_create_command(id, index, event_src)
    saver.file_create_command(event_filename(id, index), event_src)
  end

  def event_file_read_command(id, index)
    saver.file_read_command(event_filename(id, index))
  end

  # - - - - - - - - - - - - - -
  # names of dirs/files

  def dir_name(id, *parts)
    kata_id_path(id, *parts)
    # eg id == 'k5ZTk0', parts = [  ] ==> '/cyber-dojo/katas/k5/ZT/k0'
    # eg id == 'k5ZTk0', parts = [31] ==> '/cyber-dojo/katas/k5/ZT/k0/31'
  end

  def manifest_filename(id)
    kata_id_path(id, 'manifest.json')
    # eg id == 'k5ZTk0' ==> '/cyber-dojo/katas/k5/ZT/manifest.json'
    # eg content ==> {"display_name":"Ruby, MiniTest",...}
  end

  def events_filename(id)
    kata_id_path(id, 'events.json')
    # eg id == 'k5ZTk0' ==> '/cyber-dojo/katas/k5/ZT/events.json'
    # eg content ==>
    # {"event":"created","time":[2019,1,19,12,41, 0,406370]}
    # {"colour":"red",   "time":[2019,1,19,12,45,19,994317],"duration":1.224763}
    # {"colour":"amber", "time":[2019,1,19,12,45,26,76791 ],"duration":1.1275  }
    # {"colour":"green", "time":[2019,1,19,12,45,30,656924],"duration":1.072198}
  end

  def event_filename(id, index)
    kata_id_path(id, index, 'event.json')
    # eg id == 'k5ZTk0', index == 2 ==> '/cyber-dojo/katas/k5/ZT//2/event.json'
    # eg content ==>
    # {
    #   "files":{
    #     "hiker.rb":{"content":"......","truncated":false},
    #     ...
    #   },
    #   "stdout":{"content":"...","truncated":false},
    #   "stderr":{"content":"...","truncated":false},
    #   "status":1
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

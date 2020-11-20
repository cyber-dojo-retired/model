# frozen_string_literal: true

module PolyFiller

  def polyfill_manifest(json, event0)
    json['visible_files'] = event0['files']
  end

  def polyfill_events(json)
    json.map.with_index(0) do |h,index|
      h['index'] = index
      if h.has_key?('colour')
        h['predicted'] ||= 'none'
      end
    end
  end

  def polyfill_event(json, events, index)
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
  end

end

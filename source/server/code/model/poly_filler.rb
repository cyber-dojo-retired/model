# frozen_string_literal: true

module PolyFiller

  def polyfill_manifest(json, event0)
    json['visible_files'] = event0['files']
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  def polyfill_event(event, events, index)
    event_summary = events[index]
    # event - read from /..ID../INDEX/event.json
    # events_summary - read from /..ID../events.json
    # Polyfill the former from the latter.
    if event.has_key?('status')
      event['status'] = event['status'].to_s
    end
    if index === 0
      event['event'] = 'created'
    end
    if event_summary.has_key?('colour')
      event['colour'] = event_summary['colour']
      event['duration'] = event_summary['duration']
      event['predicted'] ||= 'none'
    end
    event['index'] = index
    event['time'] = event_summary['time']
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  def polyfill_events(json)
    json.map.with_index(0) do |h,index|
      h['index'] = index
      if h.has_key?('colour')
        h['predicted'] ||= 'none'
      end
    end
  end

end

# frozen_string_literal: true
require_relative 'test_base'

class EventsTest < TestBase

  def self.id58_prefix
    'D9w'
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  v_tests [0], 'f5S', %w(
  retrieve already existing kata_events summary {test-data copied into saver}
  ) do
    actual = model.kata_events(id:'5rTJv5')
    expected = [
      { "event" => "created", "time" => [2019,1,16,12,44,55,800239] },
      { "colour" => "red",    "time" => [2019,1,16,12,45,40,544806], "duration" => 1.46448 },
      { "colour" => "amber",  "time" => [2019,1,16,12,45,46,82887],  "duration" => 1.031421 },
      { "colour" => "green",  "time" => [2019,1,16,12,45,52,220587], "duration" => 1.042027 },
    ]
    assert_equal expected, actual
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  v_tests [0], 'f5T', %w(
  retrieve already existing individual kata_event {test-data copied into saver}
  ) do
    actual = model.kata_event(id:'5rTJv5', index:0)
    assert actual.is_a?(Hash)
    assert_equal ['files'], actual.keys

    actual = model.kata_event(id:'5rTJv5', index:1)
    assert actual.is_a?(Hash)
    assert_equal ['files','stdout','stderr','status'].sort, actual.keys.sort
  end

end

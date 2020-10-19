# frozen_string_literal: true
require_relative 'test_base'

class EventsTest < TestBase

  def self.id58_prefix
    'D9w'
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  v_tests [0], 'f5S', %w(
  retrieve already existing kata_events() summary {test-data copied into saver}
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

  v_tests [1], 'rp8', %w(
  retrieve already existing kata_events() summary {test-data copied into saver}
  ) do
    actual = model.kata_events(id:'5U2J18')
    expected = [
      { "index" => 0, "event"  => "created", "time" => [2020,10,19,12,52,46,396907]},
      { "index" => 1, "colour" => "red",     "time" => [2020,10,19,12,52,54,772809], "duration" => 0.491393, "predicted" => "none"},
      { "index" => 2, "colour" => "amber",   "time" => [2020,10,19,12,52,58,547002], "duration" => 0.426736, "predicted" => "none"},
      { "index" => 3, "colour" => "green",   "time" => [2020,10,19,12,53,3,256202],  "duration" => 0.438522, "predicted" => "none"}
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

  v_tests [1], 'rp9', %w(
  retrieve already existing individual kata_event {test-data copied into saver}
  ) do
    actual = model.kata_event(id:'H8NAvN', index:0)
    assert actual.is_a?(Hash)
    assert_equal ['files','index','time','event'].sort, actual.keys.sort

    actual = model.kata_event(id:'H8NAvN', index:1)
    assert actual.is_a?(Hash)
    assert_equal ['files','stdout','stderr','status','index','time','colour','duration','predicted'].sort, actual.keys.sort
    assert_equal "1", actual['status']
    assert_equal [2020,10,19,12,15,47,353545], actual['time']
    assert_equal 0.918826, actual['duration']
    assert_equal 'red', actual['colour']
    assert_equal 'none', actual['predicted']
    assert_equal 1, actual['index']
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

end

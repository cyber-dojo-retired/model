# frozen_string_literal: true
require_relative 'test_base'

class GroupEventsTest < TestBase

  def self.id58_prefix
    'QS4'
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    v_tests [0], 'JJ0', %w(
    already existing group_events(id) {test-data copied into saver}
    with id == group-id
    ) do
      id = 'FxWwrr'
      actual = group_events(id)
      expected = {
        "32" => { # mouse
          "id" => "5rTJv5",
          "events" => [
            { "index" => 0, "time" => [2019,1,16,12,44,55,800239], "event" => "created" },
            { "index" => 1, "time" => [2019,1,16,12,45,40,544806], "colour" => "red"  , "duration" => 1.46448,  "predicted" => "red" },
            { "index" => 2, "time" => [2019,1,16,12,45,46,82887 ], "colour" => "amber", "duration" => 1.031421, "predicted" => "none" },
            { "index" => 3, "time" => [2019,1,16,12,45,52,220587], "colour" => "green", "duration" => 1.042027, "predicted" => "none" }
          ]
        }
      }
      assert_equal expected, actual
    end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  v_tests [1], 'JJ1', %w(
  already existing group_events(id) {test-data copied into saver}
  with id == group-id
  ) do
    id = 'REf1t8'
    actual = group_events(id)
    expected = {
      "44" => { # rhino
        "id" => "5U2J18",
        "events" => [
          { "index" => 0, "time" => [2020,10,19,12,52,46,396907], "event" => "created" },
          { "index" => 1, "time" => [2020,10,19,12,52,54,772809], "duration" => 0.491393, "colour" => "red",   "predicted" => "none" },
          { "index" => 2, "time" => [2020,10,19,12,52,58,547002], "duration" => 0.426736, "colour" => "amber", "predicted" => "none" },
          { "index" => 3, "time" => [2020,10,19,12,53,3,256202],  "duration" => 0.438522, "colour" => "green", "predicted" => "none" }
        ]
      }
    }
    assert_equal expected, actual
  end

end

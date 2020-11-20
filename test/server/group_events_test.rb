# frozen_string_literal: true
require_relative 'test_base'

class GroupEventsTest < TestBase

  def self.id58_prefix
    'QS4'
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  v_tests [1], 'JJ3', %w(
  already existing group_events(id) {test-data copied into saver}
  with id == group-id
  ) do
    id = 'REf1t8'
    actual = group_events(id)
    expected = {
      "44" => { # rhino
        "id" => "5U2J18",
        "events" => [
          {"index" => 0, "time" => [2020,10,19,12,52,46,396907], "event" => "created" },
          {"index" => 1, "time" => [2020,10,19,12,52,54,772809], "duration" => 0.491393, "colour" => "red",   "predicted" => "none" },
          {"index" => 2, "time" => [2020,10,19,12,52,58,547002], "duration" => 0.426736, "colour" => "amber", "predicted" => "none" },
          {"index" => 3, "time" => [2020,10,19,12,53,3,256202],  "duration" => 0.438522, "colour" => "green", "predicted" => "none" }
        ]
      }
    }
    assert_equal expected, actual
  end

end

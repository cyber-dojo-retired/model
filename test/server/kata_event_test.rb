# frozen_string_literal: true
require_relative 'test_base'
require_relative '../data/kata_test_data'

class KataEventTest < TestBase

  def self.id58_prefix
    'Lw2'
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '2R6', %w( v0 example ) do
    actual = kata_event(V0_KATA_ID, 2)
    expected = kata_event_k5ZTk0_2
    assert_equal expected, actual
  end

  test '2R7', %w( v0 example next event ) do
    actual = kata_event(V0_KATA_ID, 3)
    expected = kata_event_k5ZTk0_3
    assert_equal expected, actual
  end

  test '1P3', %w( v1 example ) do
    actual = kata_event(V1_KATA_ID, 1)
    expected = kata_event_rUqcey_1
    assert_equal expected, actual
  end

  test '1P4', %w( v1 example next event) do
    actual = kata_event(V1_KATA_ID, 2)
    expected = kata_event_rUqcey_2
    assert_equal expected, actual
  end

  private

  include KataTestData

end

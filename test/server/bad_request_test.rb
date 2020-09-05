# frozen_string_literal: true
require_relative 'test_base'

class BadRequestTest < TestBase

  def self.id58_prefix
    'f27'
  end

  # - - - - - - - - - - - - - - - - -

  test 'Kp1', %w(
  |POST /group_create
  |with JSON-Hash in its request.body
  |containing an unknown arg
  |is a 500 error
  ) do
    assert_json_post_500(
      path = 'group_create',
      args = '{"unknown":42}'
    )
  end

  # - - - - - - - - - - - - - - - - -

  test 'Kp2', %w(
  |POST /group_create
  |with JSON-not-Hash in its request.body
  |is a 500 error
  ) do
    assert_json_post_500(
      path = 'group_create',
      args = '42'
    )
  end

  # - - - - - - - - - - - - - - - - -

  test 'Kp3', %w(
  |POST /group_create
  |with non-JSON in its request.body
  |is a 500 error
  ) do
    assert_json_post_500(
      path = 'group_create',
      args = 'not-json'
    )
  end

end

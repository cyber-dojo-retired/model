# frozen_string_literal: true
require_relative 'test_base'

class BadRequestTest < TestBase

  def self.id58_prefix
    'f27'
  end

  # - - - - - - - - - - - - - - - - -

  test 'Kp1', %w(
  |POST /create_group
  |with JSON-Hash in its request.body
  |containing an unknown arg
  |is a 500 error
  ) do
    assert_json_post_500(
      path = 'create_group',
      args = '{"unknown":42}'
    )
  end

  # - - - - - - - - - - - - - - - - -

  test 'Kp4', %w(
  |POST /create_group
  |with non-JSON-Hash in its request.body
  |is a 500 error
  ) do
    assert_json_post_500(
      path = 'create_group',
      args = "{..."
    )
  end

end

# frozen_string_literal: true
require_relative '../id58_test_base'
require_source 'app'
require_source 'externals'

class TestBase < Id58TestBase

  include Rack::Test::Methods # [1]

  def app # [1]
    App.new(externals)
  end

  def externals
    @externals ||= Externals.new
  end

  # - - - - - - - - - - - - - - -

  def status?(expected)
    status === expected
  end

  def status
    last_response.status
  end

  # - - - - - - - - - - - - - - -

  def json_content?
    content_type === 'application/json'
  end

  def content_type
    last_response.headers['Content-Type']
  end

end

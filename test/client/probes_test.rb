# frozen_string_literal: true
require_relative 'test_base'

class ProbesTest < TestBase

  def self.id58_prefix
    'A86'
  end

  # - - - - - - - - - - - - - - - - -

  test '15C', 'its alive' do
    assert true?(probe.alive?)
  end

  # - - - - - - - - - - - - - - - - -

  test '15D', 'its ready' do
    assert true?(probe.ready?)
  end

end

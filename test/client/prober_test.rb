# frozen_string_literal: true
require_relative 'test_base'

class ProberTest < TestBase

  def self.id58_prefix
    'A86'
  end

  # - - - - - - - - - - - - - - - - -

  test '15C', 'its alive' do
    assert true?(prober.alive?)
  end

  # - - - - - - - - - - - - - - - - -

  test '15D', 'its ready' do
    assert true?(prober.ready?)
  end

end

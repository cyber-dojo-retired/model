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

  # - - - - - - - - - - - - - - - - -

  test '15E', %w( sha is 40-char git commit sha ) do
    sha = prober.sha
    assert git_sha?(sha), sha
  end

  private

  def git_sha?(s)
    s.is_a?(String) &&
      s.size === 40 &&
        s.each_char.all?{ |ch| is_lo_hex?(ch) }
  end

  def is_lo_hex?(ch)
    '0123456789abcdef'.include?(ch)
  end

end

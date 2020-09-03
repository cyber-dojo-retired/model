# frozen_string_literal: true
require_relative '../id58_test_base'
require_source 'externals'
require_source 'model'
require_source 'probe'

class TestBase < Id58TestBase

  def externals
    @externals ||= Externals.new
  end

  def probe
    Probe.new(externals)
  end

  def model
    Model.new(externals)
  end

  # - - - - - - - - - - - - -

  def true?(b)
    b.is_a?(TrueClass)
  end

  def false?(b)
    b.is_a?(FalseClass)
  end

end

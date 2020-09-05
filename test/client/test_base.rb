# frozen_string_literal: true
require_relative '../id58_test_base'
require_relative 'external_custom_start_points'
require_source 'externals'
require_source 'model'
require_source 'prober'

class TestBase < Id58TestBase

  def externals
    @externals ||= Externals.new
  end

  def prober
    Prober.new(externals)
  end

  def model
    Model.new(externals)
  end

  def custom_start_points
    ExternalCustomStartPoints.new
  end

  # - - - - - - - - - - - - -

  def default_options
    { "line_numbers":true,
      "syntax_highlight":false,
      "predict_colour":false
    }
  end

  # - - - - - - - - - - - - -

  def true?(b)
    b.is_a?(TrueClass)
  end

  def false?(b)
    b.is_a?(FalseClass)
  end

end

# frozen_string_literal: true
require_relative 'app_base'
require_relative 'probe'

class App < AppBase

  def initialize(externals)
    super(externals)
  end

  get_json(:alive?, Probe)
  get_json(:ready?, Probe)
  get_json(:sha,    Probe)

  # - - - - - - - - - - - - -

end

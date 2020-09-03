# frozen_string_literal: true
require_relative 'app_base'
require_relative 'probe'

class App < AppBase

  def initialize(externals)
    super(externals)
  end

  get_json(:alive?, Probe) # curl/k8s
  get_json(:ready?, Probe) # curl/k8s
  get_json(:sha,    Probe) # identity

  # - - - - - - - - - - - - -

end

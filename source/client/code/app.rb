# frozen_string_literal: true
require_relative 'app_base'
require_relative 'prober'

class App < AppBase

  def initialize(externals)
    super(externals)
  end

  get_json(:alive?, Prober)
  get_json(:ready?, Prober)
  get_json(:sha,    Prober)

  # - - - - - - - - - - - - -

end

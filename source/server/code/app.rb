# frozen_string_literal: true
require_relative 'app_base'
require_relative 'model'
require_relative 'probe'

class App < AppBase

  def initialize(externals)
    super(externals)
  end

  # - - - - - - - - - - - - - - - - - - - - -

  get_json(:alive?, Probe) # curl/k8s
  get_json(:ready?, Probe) # curl/k8s
  get_json(:sha,    Probe) # identity

  # - - - - - - - - - - - - - - - - - - - - -

  post_json(:create_group, Model)
  post_json(:create_kata,  Model)

  get_json(:group_exists?, Model)
  get_json(:kata_exists?,  Model)

  get_json(:group_manifest, Model)
  get_json(:kata_manifest,  Model)

end

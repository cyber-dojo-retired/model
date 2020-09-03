# frozen_string_literal: true
require_relative 'app_base'

class App < AppBase

  def initialize(externals)
    super(externals)
  end

  # - - - - - - - - - - - - - - - - - - - - -

  get_probe(:alive?) # curl/k8s
  get_probe(:ready?) # curl/k8s
  get_probe(:sha)    # identity

  # - - - - - - - - - - - - - - - - - - - - -

  post_json(:create_group)
  post_json(:create_kata)

  get_json(:group_exists?)
  get_json(:kata_exists?)

  get_json(:group_manifest)
  get_json(:kata_manifest)

end

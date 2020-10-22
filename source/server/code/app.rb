# frozen_string_literal: true
require_relative 'app_base'
require_relative 'model'
require_relative 'prober'

class App < AppBase

  def initialize(externals)
    super(externals)
  end

   get_json(:alive?, Prober)
   get_json(:ready?, Prober)
   get_json(:sha,    Prober)

  post_json(:group_create,   Model)
   get_json(:group_exists?,  Model)
   get_json(:group_manifest, Model)
  post_json(:group_join,     Model)
   get_json(:group_avatars,  Model)

  post_json(:kata_create,    Model)
   get_json(:kata_exists?,   Model)
   get_json(:kata_manifest,  Model)
   get_json(:kata_events,    Model)
   get_json(:kata_event,     Model)
  post_json(:kata_ran_tests, Model)

end

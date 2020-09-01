# frozen_string_literal: true
require_relative 'external_model'
require_relative 'external_http'

class Externals

  def model
    @model ||= ExternalModel.new(model_http)
  end
  def model_http
    @model_http ||= ExternalHttp.new
  end

end

# frozen_string_literal: true
require_relative 'http_json_hash/service'

class ExternalModel

  def initialize(http)
    @http = HttpJsonHash::service(self.class.name, http, 'model-server', 4528)
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  def alive?
    @http.get(__method__, {})
  end

  def ready?
    @http.get(__method__, {})
  end

  def sha
    @http.get(__method__, {})
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  def group_create(manifests, options)
    @http.post(__method__, {
      manifests:manifests,
      options:options
    })
  end

  def kata_create(manifest, options)
    @http.post(__method__, {
      manifest:manifest,
      options:options
    })
  end

end

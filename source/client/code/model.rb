# frozen_string_literal: true

class Model

  def initialize(externals)
    @externals = externals
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  def ready?
    model.ready?
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  def create_group(manifests, options)
    model.create_group(manifests, options)
  end

  def create_kata(manifest, options)
    model.create_kata(manifest, options)
  end

  private

  def model
    @externals.model
  end

end

# frozen_string_literal: true

class Model

  def initialize(externals)
    @externals = externals
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  def group_exists?(id)
    model.group_exists?(id)
  end

  def group_create(manifests, options)
    model.group_create(manifests, options)
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  def kata_exists?(id)
    model.kata_exists?(id)
  end

  def kata_create(manifest, options)
    model.kata_create(manifest, options)
  end

  private

  def model
    @externals.model
  end

end

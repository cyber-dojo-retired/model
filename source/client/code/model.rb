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

  def group_manifest(id)
    model.group_manifest(id)
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  def kata_exists?(id)
    model.kata_exists?(id)
  end

  def kata_create(manifest, options)
    model.kata_create(manifest, options)
  end

  def kata_manifest(id)
    model.kata_manifest(id)
  end

  def kata_option_get(id, name)
    model.kata_option_get(id, name)
  end

  def kata_option_set(id, name, value)
    model.kata_option_set(id, name, value)
  end

  private

  def model
    @externals.model
  end

end

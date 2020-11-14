# frozen_string_literal: true

class Prober

  def initialize(externals)
    @externals = externals
  end

  def sha
    model.sha
  end

  def healthy?
    ready?
  end

  def alive?
    model.alive?
  end

  def ready?
    model.ready?
  end

  private

  def model
    @externals.model
  end

end

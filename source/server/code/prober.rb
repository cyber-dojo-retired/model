# frozen_string_literal: true

class Prober

  def initialize(externals)
    @externals = externals
  end

  def sha
    '"' + ENV['SHA'] + '"'
  end

  def healthy?
    ready?
  end

  def alive?
    true
  end

  def ready?
    @externals.saver.ready?
  end

end

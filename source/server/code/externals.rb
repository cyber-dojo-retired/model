# frozen_string_literal: true
require_relative 'external_puller'
require_relative 'external_random'
require_relative 'external_saver'
require_relative 'external_time'

class Externals

  def puller
    @puller ||= ExternalPuller.new(puller_http)
  end
  def puller_http
    @puller_http ||= ExternalHttp.new
  end

  def saver
    @saver ||= ExternalSaver.new(saver_http)
  end
  def saver_http
    @saver_http ||= ExternalHttp.new
  end

  # - - - - - - - - - - - - - - - - - - -

  def random
    @random ||= ExternalRandom.new
  end

  def time
    @time ||= ExternalTime.new
  end

end

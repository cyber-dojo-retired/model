# frozen_string_literal: true

module OptionsChecker

  def fail_unless_known_options(options)
    unless options.is_a?(Hash)
      fail "options is not a Hash"
    end
    options.each do |key,value|
      unless known_option_key?(key)
        fail "options:{#{quoted(key)}: #{value}} unknown key: #{quoted(key)}"
      end
      unless known_option_value?(key, value)
        fail "options:{#{quoted(key)}: #{value}} unknown value: #{value}"
      end
    end
  end

  def known_option_key?(key)
    known_options = [
      "fork_button",
      "theme",
      "colour",
      "predict",
      "starting_info_dialog"
    ]
    key.is_a?(String) && known_options.include?(key)
  end

  def known_option_value?(key, value)
    on_off = [ "on", "off" ]
    case key
    when "colour"      then return on_off.include?(value)
    when "fork_button" then return on_off.include?(value)
    when "predict"     then return on_off.include?(value)
    when "starting_info_dialog" then return on_off.include?(value)
    when "theme"       then return ["dark","light"].include?(value)
    end
    false
  end

end

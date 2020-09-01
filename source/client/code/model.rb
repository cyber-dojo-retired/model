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

  def create_group(manifest, options=default_options)
    model.create_group(manifest, options)
  end

  def create_kata(manifest, options=default_options)
    model.create_kata(manifest, options)
  end

  private

  def default_options
    { "line_numbers":true,
      "syntax_highlight":false,
      "predict_colour":false
    }
  end

  def model
    @externals.model
  end

end

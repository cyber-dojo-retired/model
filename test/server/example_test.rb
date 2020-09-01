require_relative 'test_base'

class ExampleTest < TestBase

  def self.id58_prefix
    '449'
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - -

  def id58_setup
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'AC6', %w( example ) do
    assert_equal 42, 42
  end

end

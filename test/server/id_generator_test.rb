# frozen_string_literal: true
require_relative 'test_base'
require_source 'id_generator'

class IdGeneratorTest < TestBase

  def self.id58_prefix
    'A6D'
  end

  # - - - - - - - - - - - - - - - - - - -

  test 'b13', %w( a group-id is an id ) do
    assert id?(id_generator.group_id)
  end

  test 'b14', %w( a kata-id is an id ) do
    assert id?(id_generator.kata_id)
  end

  private

  def id?(s)
    IdGenerator::id?(s)
  end

  def id_generator
    IdGenerator.new(externals)
  end

end

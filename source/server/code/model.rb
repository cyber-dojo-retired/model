# frozen_string_literal: true
require_relative 'lib/json_adapter'

class Model

  def initialize(externals)
    @externals = externals
  end

  #- - - - - - - - - - - - - - - - - -

  def group_create(manifests:, options:)
    saver.group_create(manifests, options)
  end

  def group_exists?(id:)
    saver.group_exists?(id)
  end

  def group_manifest(id:)
    saver.group_manifest(id)
  end

  def group_join(id:, indexes:AVATAR_INDEXES.shuffle)
    saver.group_join(id, indexes)
  end

  def group_joined(id:)
    saver.group_joined(id)
  end

  #- - - - - - - - - - - - - - - - - -

  def kata_create(manifest:, options:)
    saver.kata_create(manifest, options)
  end

  def kata_exists?(id:)
    saver.kata_exists?(id)
  end

  def kata_manifest(id:)
    saver.kata_manifest(id)
  end

  def kata_events(id:)
    saver.kata_events(id)
  end

  def kata_event(id:, index:)
    saver.kata_event(id, index)
  end

  def katas_events(ids:, indexes:)
    saver.katas_events(ids, indexes)
  end

  def kata_ran_tests(id:, index:, files:, stdout:, stderr:, status:, summary:)
    saver.kata_ran_tests(id, index, files, stdout, stderr, status, summary)
  end

  def kata_predicted_right(id:, index:, files:, stdout:, stderr:, status:, summary:)
    saver.kata_predicted_right(id, index, files, stdout, stderr, status, summary)
  end

  def kata_predicted_wrong(id:, index:, files:, stdout:, stderr:, status:, summary:)
    saver.kata_predicted_wrong(id, index, files, stdout, stderr, status, summary)
  end

  def kata_reverted(id:, index:, files:, stdout:, stderr:, status:, summary:)
    saver.kata_reverted(id, index, files, stdout, stderr, status, summary)
  end

  def kata_checked_out(id:, index:, files:, stdout:, stderr:, status:, summary:)
    saver.kata_checked_out(id, index, files, stdout, stderr, status, summary)
  end

  def kata_option_get(id:, name:)
    saver.kata_option_get(id, name)
  end

  def kata_option_set(id:, name:, value:)
    saver.kata_option_set(id, name, value)
  end

  private

  AVATAR_INDEXES = (0..63).to_a

  def saver
    @externals.saver
  end

end

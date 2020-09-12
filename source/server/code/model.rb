# frozen_string_literal: true
require_relative 'model/id_pather'
require_relative 'model/group_v0'
require_relative 'model/group_v1'
require_relative 'model/kata_v0'
require_relative 'model/kata_v1'
require 'json'

class Model

  def initialize(externals)
    @externals = externals
  end

  #- - - - - - - - - - - - - - - - - -

  def group_exists?(id:)
    group(CURRENT_VERSION).exists?(id)
  end

  def group_manifest(id:)
    group(version_group(id)).manifest(id)
  end

  def group_create(manifests:, options:)
    manifest = manifests[0]
    version = (manifest['version'] || CURRENT_VERSION).to_i
    group(version).create(manifest, options)
  end

  #- - - - - - - - - - - - - - - - - -

  def kata_exists?(id:)
    kata(CURRENT_VERSION).exists?(id)
  end

  def kata_manifest(id:)
    kata(version_kata(id)).manifest(id)
  end

  def kata_create(manifest:, options:)
    version = (manifest['version'] || CURRENT_VERSION).to_i
    kata(version).create(manifest, options)
  end

  private

  attr_reader :externals

  include IdPather

  def group(version)
    GROUPS[version].new(externals)
  end

  def kata(version)
    KATAS[version].new(externals)
  end

  def version_group(id)
    version_path(group_id_path(id, 'manifest.json'))
  end

  def version_kata(id)
    version_path(kata_id_path(id, 'manifest.json'))
  end

  def version_path(path)
    manifest_src = saver.assert(saver.file_read_command(path))
    manifest = JSON.parse!(manifest_src)
    # if manifest['version'].nil?
    # then nil.to_i ==> 0 which is what we want
    manifest['version'].to_i
  end

  def saver
    externals.saver
  end

  CURRENT_VERSION = 1
  GROUPS = [ Group_v0, Group_v1 ]
  KATAS = [ Kata_v0, Kata_v1 ]
end

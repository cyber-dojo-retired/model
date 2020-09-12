# frozen_string_literal: true
require_relative 'model/id_pather'
require_relative 'model/group_v0'
require_relative 'model/group_v1'
require_relative 'model/kata_v0'
require_relative 'model/kata_v1'
require_relative 'model/oj_adapter'

class Model

  def initialize(externals)
    @externals = externals
  end

  #- - - - - - - - - - - - - - - - - -

  def group_exists?(id:)
    group(CURRENT_VERSION).exists?(id)
  end

  def group_manifest(id:)
    group(version_from_group_id(id)).manifest(id)
  end

  def group_create(manifests:, options:)
    manifest = manifests[0]
    group(version_from_manifest(manifest)).create(manifest, options)
  end

  #- - - - - - - - - - - - - - - - - -

  def kata_exists?(id:)
    kata(CURRENT_VERSION).exists?(id)
  end

  def kata_manifest(id:)
    kata(version_from_kata_id(id)).manifest(id)
  end

  def kata_create(manifest:, options:)
    kata(version_from_manifest(manifest)).create(manifest, options)
  end

  private

  include IdPather # group_id_path, kata_id_path
  include OjAdapter

  def group(version)
    [ Group_v0, Group_v1 ][version].new(@externals)
  end

  def kata(version)
    [ Kata_v0, Kata_v1 ][version].new(@externals)
  end

  def version_from_group_id(id)
    version_from_path(group_id_path(id, 'manifest.json'))
  end

  def version_from_kata_id(id)
    version_from_path(kata_id_path(id, 'manifest.json'))
  end

  def version_from_path(path)
    manifest_src = saver.assert(saver.file_read_command(path))
    manifest = json_parse(manifest_src)
    # if manifest['version'].nil?
    # then nil.to_i ==> 0 which is what we want
    manifest['version'].to_i
  end

  CURRENT_VERSION = 1

  def version_from_manifest(manifest)
    (manifest['version'] || CURRENT_VERSION).to_i
  end

  def saver
    @externals.saver
  end

end

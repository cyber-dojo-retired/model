#!/bin/bash -Eeu

# - - - - - - - - - - - - - - - - - - - - - - - -
echo_versioner_env_vars()
{
  docker run --rm cyberdojo/versioner
  echo CYBER_DOJO_MODEL_SHA="$(image_sha)"
  echo CYBER_DOJO_MODEL_TAG="$(image_tag)"
  #
  echo CYBER_DOJO_MODEL_CLIENT_IMAGE=cyberdojo/model-client
  echo CYBER_DOJO_MODEL_CLIENT_PORT=9999
  #
  echo CYBER_DOJO_MODEL_SERVER_USER=nobody
  echo CYBER_DOJO_MODEL_CLIENT_USER=nobody
  #
  echo CYBER_DOJO_MODEL_CLIENT_CONTAINER_NAME=test-model-client
  echo CYBER_DOJO_MODEL_SERVER_CONTAINER_NAME=test-model-server
}

# - - - - - - - - - - - - - - - - - - - - - - - -
image_sha()
{
  echo "$(cd "${ROOT_DIR}" && git rev-parse HEAD)"
}

# - - - - - - - - - - - - - - - - - - - - - - - -
image_tag()
{
  local -r sha="$(image_sha)"
  echo "${sha:0:7}"
}

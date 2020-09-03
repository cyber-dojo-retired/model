#!/bin/bash -Eeu

source ${SH_DIR}/augmented_docker_compose.sh

# - - - - - - - - - - - - - - - - - - - - - -
build_tagged_images()
{
  local -r dil=$(docker_image_ls)
  remove_current_docker_image "${dil}" "${CYBER_DOJO_MODEL_IMAGE}"
  remove_current_docker_image "${dil}" "${CYBER_DOJO_MODEL_CLIENT_IMAGE}"

  augmented_docker_compose \
    build \
    --build-arg COMMIT_SHA=$(git_commit_sha)

  docker tag ${CYBER_DOJO_MODEL_IMAGE}:$(image_tag) ${CYBER_DOJO_MODEL_IMAGE}:latest
  docker tag ${CYBER_DOJO_MODEL_CLIENT_IMAGE}:$(image_tag) ${CYBER_DOJO_MODEL_CLIENT_IMAGE}:latest

  check_embedded_env_var
  echo
  echo "CYBER_DOJO_MODEL_TAG=${CYBER_DOJO_MODEL_TAG}"
  echo "CYBER_DOJO_MODEL_SHA=${CYBER_DOJO_MODEL_SHA}"
}

# - - - - - - - - - - - - - - - - - - - - - -
docker_image_ls()
{
  docker image ls --format "{{.Repository}}:{{.Tag}}"
}

# - - - - - - - - - - - - - - - - - - - - - -
remove_current_docker_image()
{
  local -r docker_image_ls="${1}"
  local -r name="${2}"
  if image_exists "${docker_image_ls}" "${name}" 'latest' ; then
    local -r sha="$(docker run --rm -it ${name}:latest sh -c 'echo -n ${SHA}')"
    local -r tag="${sha:0:7}"
    if image_exists "{docker_image_ls}" "${name}" "${tag}" ; then
      echo "Deleting current image ${name}:${tag}"
      docker image rm "${name}:${tag}"
    fi
  fi
}

# - - - - - - - - - - - - - - - - - - - - - -
image_exists()
{
  local -r docker_image_ls="${1}"
  local -r name="${2}"
  local -r tag="${3}"
  local -r latest=$(echo "${docker_image_ls}" | grep "${name}:${tag}")
  [ "${latest}" != '' ]
}

# - - - - - - - - - - - - - - - - - - - - - -
check_embedded_env_var()
{
  if [ "$(git_commit_sha)" != "$(sha_in_image)" ]; then
    echo "ERROR: unexpected env-var inside image $(image_name):$(image_tag)"
    echo "expected: 'SHA=$(git_commit_sha)'"
    echo "  actual: 'SHA=$(sha_in_image)'"
    exit 42
  fi
}

# - - - - - - - - - - - - - - - - - - - - - -
git_commit_sha()
{
  echo $(cd "${SH_DIR}" && git rev-parse HEAD)
}

# - - - - - - - - - - - - - - - - - - - - - -
image_name()
{
  echo "${CYBER_DOJO_MODEL_IMAGE}"
}

# - - - - - - - - - - - - - - - - - - - - - -
image_tag()
{
  echo "${CYBER_DOJO_MODEL_TAG}"
}

# - - - - - - - - - - - - - - - - - - - - - -
image_sha()
{
  echo "${CYBER_DOJO_MODEL_SHA}"
}

# - - - - - - - - - - - - - - - - - - - - - -
sha_in_image()
{
  docker run --rm $(image_name):$(image_tag) sh -c 'echo -n ${SHA}'
}

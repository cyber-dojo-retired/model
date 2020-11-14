#!/bin/bash -Eeu

source ${SH_DIR}/augmented_docker_compose.sh

# - - - - - - - - - - - - - - - - - - - - - -
build_tagged_images()
{
  echo
  augmented_docker_compose \
    build \
    --build-arg COMMIT_SHA=$(git_commit_sha)
}

# - - - - - - - - - - - - - - - - - - - - - -
tag_images_to_latest()
{
  docker tag ${CYBER_DOJO_MODEL_IMAGE}:$(image_tag) ${CYBER_DOJO_MODEL_IMAGE}:latest
  docker tag ${CYBER_DOJO_MODEL_CLIENT_IMAGE}:$(image_tag) ${CYBER_DOJO_MODEL_CLIENT_IMAGE}:latest
}

# - - - - - - - - - - - - - - - - - - - - - -
show_env_vars()
{
  echo "echo CYBER_DOJO_MODEL_SHA=${CYBER_DOJO_MODEL_SHA}"
  echo "echo CYBER_DOJO_MODEL_TAG=${CYBER_DOJO_MODEL_TAG}"
  echo
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

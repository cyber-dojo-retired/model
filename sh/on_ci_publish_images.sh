#!/bin/bash -Eeu

# - - - - - - - - - - - - - - - - - - - - - - - -
on_ci_publish_images()
{
  echo
  if ! on_ci; then
    echo 'not on CI so not publishing tagged images'
  else
    echo 'on CI so publishing tagged images'
    local -r image_name="${CYBER_DOJO_MODEL_IMAGE}"
    local -r image_tag="${CYBER_DOJO_MODEL_TAG}"
    docker push ${image_name}:${image_tag}
    docker push ${image_name}:latest
  fi
  echo
}

# - - - - - - - - - - - - - - - - - - - - - - - -
on_ci()
{
  [ -n "${CIRCLECI:-}" ]
}

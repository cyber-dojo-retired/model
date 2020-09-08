#!/bin/bash -Eeu

# cyberdojo/service-yaml image lives at
# https://github.com/cyber-dojo-tools/service-yaml

# - - - - - - - - - - - - - - - - - - - - - -
augmented_docker_compose()
{
  local -r IMAGE=cyberdojo/service-yaml
  cd "${ROOT_DIR}" && cat "./docker-compose.yml" \
    | docker run \
        --rm \
        --interactive \
        ${IMAGE} \
           custom-start-points \
                         saver \
    | tee /tmp/augmented-docker-compose.model.peek.yml \
    | docker-compose \
      --file -       \
      "$@"
}

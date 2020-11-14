#!/bin/bash -Eeu

# - - - - - - - - - - - - - - - - - - - - - -
tag_images_to_latest()
{
  docker tag ${CYBER_DOJO_MODEL_IMAGE}:$(image_tag) ${CYBER_DOJO_MODEL_IMAGE}:latest
  docker tag ${CYBER_DOJO_MODEL_CLIENT_IMAGE}:$(image_tag) ${CYBER_DOJO_MODEL_CLIENT_IMAGE}:latest
}

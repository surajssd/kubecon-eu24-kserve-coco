#!/bin/bash

set -euo pipefail
# Check if the DEBUG env var is set to true
if [ "${DEBUG:-false}" = "true" ]; then
    set -x
fi

# Compulsory env vars
: "${SOURCE_IMAGE}:?"
: "${DESTINATION_IMAGE}:?"
: "${KEY_ID}:?"
: "${KEY_FILE}:?"

COCO_KEY_PROVIDER_IMAGE="${COCO_KEY_PROVIDER_IMAGE:-quay.io/surajd/coco-key-provider:480a13f}"

KEY_ID="kbs:///${KEY_ID}"
KEY_B64="$(base64 <${KEY_FILE})"

docker run \
    -v $HOME/.docker/config.json:/root/.docker/config.json:ro \
    "${COCO_KEY_PROVIDER_IMAGE}" \
    /encrypt.sh -k "${KEY_B64}" -i "${KEY_ID}" \
    -s "docker://${SOURCE_IMAGE}" -d "docker://${DESTINATION_IMAGE}"

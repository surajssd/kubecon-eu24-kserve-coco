#!/bin/bash

set -euo pipefail
# Check if the DEBUG env var is set to true
if [ "${DEBUG:-false}" = "true" ]; then
    set -x
fi

# Last release of the confidential-containers guest-components repository.
GUEST_COMPONENTS_COMMIT="${GUEST_COMPONENTS_COMMIT:-480a13f}"

# Use the image name provided by the user or use the default one.
COCO_KEY_PROVIDER_IMAGE="${COCO_KEY_PROVIDER_IMAGE:-quay.io/surajd/coco-key-provider:$GUEST_COMPONENTS_COMMIT}"

pushd $(dirname "$0")
git clone https://github.com/confidential-containers/guest-components.git
pushd guest-components
git checkout "${GUEST_COMPONENTS_COMMIT}"

docker build \
    --push \
    -t "${COCO_KEY_PROVIDER_IMAGE}" \
    -f ./attestation-agent/docker/Dockerfile.keyprovider .
popd

echo "Successfully built and pushed image: ${COCO_KEY_PROVIDER_IMAGE}"
popd

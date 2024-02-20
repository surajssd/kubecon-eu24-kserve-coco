.PHONY: build-coco-key-provider
build-coco-key-provider:
	# Provide env var to influence the build
	# GUEST_COMPONENTS_COMMIT - commit hash of the guest components repository.
	# COCO_KEY_PROVIDER_IMAGE - name of the image to be built.
	./coco-key-provider/build-push.sh

.PHONY: encrypt-image
encrypt-image:
	# SOURCE_IMAGE - image to be encrypted
	# DESTINATION_IMAGE - name of the encrypted image
	# KEY_ID - id to be used in kbs
	# KEY_FILE - key file used to encrypt the image
	# COCO_KEY_PROVIDER_IMAGE - coco key provider image which will be used to encrypt the SOURCE_IMAGE
	./encrypt-image/encrypt-image.sh

.PHONY: deploy-aks
deploy-aks:
	./deploy-infra/deploy-aks.sh

.PHONY: deploy-kbs
deploy-kbs:
	./kbs/deploy-kbs.sh

.PHONY: deploy-caa
deploy-caa:
	./deploy-infra/deploy-caa.sh

.PHONY: deploy-encrypted-app
deploy-encrypted-app:
	# Check if the env var DESTINATION_IMAGE is exported
ifndef DESTINATION_IMAGE
	$(error env var DESTINATION_IMAGE is not set)
endif
	envsubst <encrypted-app/deployment.yaml | kubectl apply -f -

.PHONY: clean
clean:
	rm key.bin
	rm -rf coco-key-provider/guest-components
	rm -rf kbs/kbs
	rm -rf deploy-infra/cloud-api-adaptor

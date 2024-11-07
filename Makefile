DOCKER?=docker

# Base directories
BASE_BUILD_DIR := $(CURDIR)/build
REPRODUCIBLE_BUILD_DIR := $(CURDIR)/reproducible-build

.PHONY: help
help: ## Display this help.
	@awk 'BEGIN {FS = ":.*##"; printf "Usage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_0-9-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

.PHONY: image-rbuilder
image-rbuilder: measurements-image prepare-dirs ### Build rbuilder image, by default outputs to reproducile-build/artifacts-rbuilder
	# $(DOCKER) build -t yocto-builder:rbuilder --build-arg MANIFEST=tdx-rbuilder.xml $(REPRODUCIBLE_BUILD_DIR)
	#$(DOCKER) run --rm --env-file env_files/rbuilder_yocto_build_config.env \
	#		-v $(REPRODUCIBLE_BUILD_DIR)/artifacts-rbuilder:/artifacts \
	#	-v $(BASE_BUILD_DIR)/rbuilder:/build \
	#	yocto-builder:rbuilder
	$(DOCKER) run --rm --env-file env_files/rbuilder_yocto_build_config.env \
		-v $(REPRODUCIBLE_BUILD_DIR)/artifacts-rbuilder:/artifacts \
		-v $(BASE_BUILD_DIR)/rbuilder:/build \
		yocto-measurements:rbuilder
	chmod 0755 $(BASE_BUILD_DIR)/rbuilder $(REPRODUCIBLE_BUILD_DIR)/artifacts-rbuilder $(REPRODUCIBLE_BUILD_DIR)/artifacts-rbuilder/measurements

.PHONY: image-bob
image-bob: prepare-dirs check-ssh-key ### Build bob image, by default outputs to reproducile-build/artifacts-bob. Make sure you update the ssh pubkey in env_files/bob_yocto_build_config.env
	$(DOCKER) build -t yocto-builder:bob --build-arg MANIFEST=tdx-bob.xml $(REPRODUCIBLE_BUILD_DIR)
	$(DOCKER) run --rm --env-file env_files/bob_yocto_build_config.env \
		-v $(REPRODUCIBLE_BUILD_DIR)/artifacts-bob:/artifacts \
		-v $(BASE_BUILD_DIR)/bob:/build \
		yocto-builder:bob
	chmod 0755 $(BASE_BUILD_DIR)/bob $(REPRODUCIBLE_BUILD_DIR)/artifacts-bob $(REPRODUCIBLE_BUILD_DIR)/artifacts-bob/measurements

.PHONY: image-base
image-base: prepare-dirs ### Build a TDX general purpose base image, by default outputs to reproducile-build/artifacts-base
	$(DOCKER) build -t yocto-builder:base --build-arg MANIFEST=tdx-base.xml $(REPRODUCIBLE_BUILD_DIR)
	$(DOCKER) run --rm --env-file env_files/tdx-base_yocto_build_config.env \
		-v $(REPRODUCIBLE_BUILD_DIR)/artifacts-base:/artifacts \
		-v $(BASE_BUILD_DIR)/base:/build \
		yocto-builder:base
	chmod 0755 $(BASE_BUILD_DIR)/base $(REPRODUCIBLE_BUILD_DIR)/artifacts-base $(REPRODUCIBLE_BUILD_DIR)/artifacts-base/measurements

.PHONY: measurements-image
measurements-image: ### Internal target preparing measurements image
	$(DOCKER) build -t yocto-measurements:rbuilder -f reproducible-build/measurements.Dockerfile $(REPRODUCIBLE_BUILD_DIR)

.PHONY: prepare-dirs
prepare-dirs: ### Internal target preparing artifact directories
	mkdir -p $(BASE_BUILD_DIR)/rbuilder $(BASE_BUILD_DIR)/bob $(BASE_BUILD_DIR)/base
	mkdir -p $(REPRODUCIBLE_BUILD_DIR)/artifacts-rbuilder $(REPRODUCIBLE_BUILD_DIR)/artifacts-bob $(REPRODUCIBLE_BUILD_DIR)/artifacts-base
	mkdir -p $(REPRODUCIBLE_BUILD_DIR)/artifacts-rbuilder/measurements $(REPRODUCIBLE_BUILD_DIR)/artifacts-bob/measurements $(REPRODUCIBLE_BUILD_DIR)/artifacts-base/measurements
	chmod 0777 $(BASE_BUILD_DIR)/rbuilder $(BASE_BUILD_DIR)/bob $(BASE_BUILD_DIR)/base \
		$(REPRODUCIBLE_BUILD_DIR)/artifacts-rbuilder $(REPRODUCIBLE_BUILD_DIR)/artifacts-bob $(REPRODUCIBLE_BUILD_DIR)/artifacts-base \
		$(REPRODUCIBLE_BUILD_DIR)/artifacts-rbuilder/measurements $(REPRODUCIBLE_BUILD_DIR)/artifacts-bob/measurements $(REPRODUCIBLE_BUILD_DIR)/artifacts-base/measurements

.PHONY: check-ssh-key
check-ssh-key: ### Internal target checking a pubkey for bob image is provided
	@if grep -q "^SEARCHER_SSH_KEY=$$" env_files/bob_yocto_build_config.env; then \
		echo "Error: SEARCHER_SSH_KEY is not set in env_files/bob_yocto_build_config.env"; \
		exit 1; \
	fi

.PHONY: clean
clean: ### Remove build cache and artifacts
	rm -rf $(BASE_BUILD_DIR) $(REPRODUCIBLE_BUILD_DIR)/artifacts-*

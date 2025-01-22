DOCKER?=docker

# Base directories
BASE_BUILD_DIR := $(CURDIR)/build
REPRODUCIBLE_BUILD_DIR := $(CURDIR)/reproducible-build
REVISION?=$(shell git rev-parse HEAD)

.PHONY: help
help: ## Display this help.
	@awk 'BEGIN {FS = ":.*##"; printf "Usage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_0-9-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

.PHONY: image-buildernet
image-buildernet: prepare-dirs ### Build BuilderNet image, by default outputs to reproducile-build/artifacts-buildernet
	$(DOCKER) build -t yocto-builder:buildernet --build-arg MANIFEST=tdx-buildernet.xml --build-arg REVISION=$(REVISION) $(REPRODUCIBLE_BUILD_DIR)
	$(DOCKER) run --rm --env-file env_files/buildernet_yocto_build_config.env \
		-v $(REPRODUCIBLE_BUILD_DIR)/artifacts-buildernet:/artifacts \
		-v $(BASE_BUILD_DIR)/buildernet:/build \
		yocto-builder:buildernet
	chmod 0755 $(BASE_BUILD_DIR)/buildernet $(REPRODUCIBLE_BUILD_DIR)/artifacts-buildernet

.PHONY: measurements-buildernet
measurements-buildernet: measurements-image image-buildernet ### Generates measurements for BuilderNet image. The measurements can be found in reproducible-build/artifacts-buildernet/measurement-<image>.json.
	chmod 0777 $(REPRODUCIBLE_BUILD_DIR)/artifacts-buildernet
	$(DOCKER) run --rm \
		-v $(REPRODUCIBLE_BUILD_DIR)/artifacts-buildernet:/artifacts \
		-v $(BASE_BUILD_DIR)/buildernet:/build \
		yocto-measurements:latest
	chmod 0755 $(REPRODUCIBLE_BUILD_DIR)/artifacts-buildernet

.PHONY: image-bob
image-bob: measurements-image prepare-dirs check-ssh-key ### Build bob image, by default outputs to reproducile-build/artifacts-bob. Make sure you update the ssh pubkey in env_files/bob_yocto_build_config.env
	$(DOCKER) build -t yocto-builder:bob --build-arg MANIFEST=tdx-bob.xml --build-arg REVISION=$(REVISION) $(REPRODUCIBLE_BUILD_DIR)
	$(DOCKER) run --rm --env-file env_files/bob_yocto_build_config.env \
		-v $(REPRODUCIBLE_BUILD_DIR)/artifacts-bob:/artifacts \
		-v $(BASE_BUILD_DIR)/bob:/build \
		yocto-builder:bob
	chmod 0755 $(BASE_BUILD_DIR)/bob $(REPRODUCIBLE_BUILD_DIR)/artifacts-bob

.PHONY: measurements-bob
measurements-bob: measurements-image image-bob ### Generates measurements for bob image. The measurements can be found in reproducible-build/artifacts-bob/measurement-<image>.json.
	chmod 0777 $(REPRODUCIBLE_BUILD_DIR)/artifacts-bob
	$(DOCKER) run --rm \
		-v $(REPRODUCIBLE_BUILD_DIR)/artifacts-bob:/artifacts \
		-v $(BASE_BUILD_DIR)/bob:/build \
		yocto-measurements:latest
	chmod 0755 $(REPRODUCIBLE_BUILD_DIR)/artifacts-bob

.PHONY: image-base
image-base: measurements-image prepare-dirs ### Build a TDX general purpose base image, by default outputs to reproducile-build/artifacts-base
	$(DOCKER) build -t yocto-builder:base --build-arg MANIFEST=tdx-base.xml --build-arg REVISION=$(REVISION) $(REPRODUCIBLE_BUILD_DIR)
	$(DOCKER) run --rm --env-file env_files/tdx-base_yocto_build_config.env \
		-v $(REPRODUCIBLE_BUILD_DIR)/artifacts-base:/artifacts \
		-v $(BASE_BUILD_DIR)/base:/build \
		yocto-builder:base
	chmod 0755 $(BASE_BUILD_DIR)/base $(REPRODUCIBLE_BUILD_DIR)/artifacts-base

.PHONY: measurements-base
measurements-base: measurements-image image-base ### Generates measurements for base image. The measurements can be found in reproducible-build/artifacts-base/measurement-<image>.json.
	chmod 0777 $(REPRODUCIBLE_BUILD_DIR)/artifacts-base
	$(DOCKER) run --rm \
		-v $(REPRODUCIBLE_BUILD_DIR)/artifacts-base:/artifacts \
		-v $(BASE_BUILD_DIR)/base:/build \
		yocto-measurements:latest
	chmod 0755 $(REPRODUCIBLE_BUILD_DIR)/artifacts-base

.PHONY: measurements-image
measurements-image: ### Internal target preparing measurements image
	$(DOCKER) build -t yocto-measurements:latest -f reproducible-build/measurements.Dockerfile $(REPRODUCIBLE_BUILD_DIR)

.PHONY: prepare-dirs
prepare-dirs: ### Internal target preparing artifact directories
	mkdir -p $(BASE_BUILD_DIR)/buildernet $(BASE_BUILD_DIR)/bob $(BASE_BUILD_DIR)/base
	mkdir -p $(REPRODUCIBLE_BUILD_DIR)/artifacts-buildernet $(REPRODUCIBLE_BUILD_DIR)/artifacts-bob $(REPRODUCIBLE_BUILD_DIR)/artifacts-base
	chmod 0777 $(BASE_BUILD_DIR)/buildernet $(BASE_BUILD_DIR)/bob $(BASE_BUILD_DIR)/base \
		$(REPRODUCIBLE_BUILD_DIR)/artifacts-buildernet $(REPRODUCIBLE_BUILD_DIR)/artifacts-bob $(REPRODUCIBLE_BUILD_DIR)/artifacts-base

.PHONY: check-ssh-key
check-ssh-key: ### Internal target checking a pubkey for bob image is provided
	@if grep -q "^SEARCHER_SSH_KEY=$$" env_files/bob_yocto_build_config.env; then \
		echo "Error: SEARCHER_SSH_KEY is not set in env_files/bob_yocto_build_config.env"; \
		exit 1; \
	fi

.PHONY: clean
clean: ### Remove build cache and artifacts
	rm -rf $(BASE_BUILD_DIR) $(REPRODUCIBLE_BUILD_DIR)/artifacts-*

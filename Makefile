DOCKER?=docker

# Base directories
BASE_BUILD_DIR := $(CURDIR)/build
REPRODUCIBLE_BUILD_DIR := $(CURDIR)/reproducible-build

.PHONY: image-rbuilder image-bob image-base prepare-dirs clean tdx-poky

image-rbuilder: prepare-dirs
	$(DOCKER) build -t yocto-builder:rbuilder --build-arg MANIFEST=tdx-rbuilder.xml $(REPRODUCIBLE_BUILD_DIR)
	$(DOCKER) run --rm --env-file env_files/rbuilder_yocto_build_config.env \
		-v $(REPRODUCIBLE_BUILD_DIR)/artifacts-rbuilder:/artifacts \
		-v $(BASE_BUILD_DIR)/rbuilder:/build \
		yocto-builder:rbuilder
	chmod 0755 $(BASE_BUILD_DIR)/rbuilder $(REPRODUCIBLE_BUILD_DIR)/artifacts-rbuilder

image-bob: prepare-dirs check-ssh-key
	$(DOCKER) build -t yocto-builder:bob --build-arg MANIFEST=tdx-bob.xml $(REPRODUCIBLE_BUILD_DIR)
	$(DOCKER) run --rm --env-file env_files/bob_yocto_build_config.env \
		-v $(REPRODUCIBLE_BUILD_DIR)/artifacts-bob:/artifacts \
		-v $(BASE_BUILD_DIR)/bob:/build \
		yocto-builder:bob
	chmod 0755 $(BASE_BUILD_DIR)/bob $(REPRODUCIBLE_BUILD_DIR)/artifacts-bob

image-base: prepare-dirs
	$(DOCKER) build -t yocto-builder:base --build-arg MANIFEST=tdx-base.xml $(REPRODUCIBLE_BUILD_DIR)
	$(DOCKER) run --rm --env-file env_files/tdx-base_yocto_build_config.env \
		-v $(REPRODUCIBLE_BUILD_DIR)/artifacts-base:/artifacts \
		-v $(BASE_BUILD_DIR)/base:/build \
		yocto-builder:base
	chmod 0755 $(BASE_BUILD_DIR)/base $(REPRODUCIBLE_BUILD_DIR)/artifacts-base

prepare-dirs:
	mkdir -p $(BASE_BUILD_DIR)/rbuilder $(BASE_BUILD_DIR)/bob $(BASE_BUILD_DIR)/base
	mkdir -p $(REPRODUCIBLE_BUILD_DIR)/artifacts-rbuilder $(REPRODUCIBLE_BUILD_DIR)/artifacts-bob $(REPRODUCIBLE_BUILD_DIR)/artifacts-base
	chmod 0777 $(BASE_BUILD_DIR)/rbuilder $(BASE_BUILD_DIR)/bob $(BASE_BUILD_DIR)/base \
		$(REPRODUCIBLE_BUILD_DIR)/artifacts-rbuilder $(REPRODUCIBLE_BUILD_DIR)/artifacts-bob $(REPRODUCIBLE_BUILD_DIR)/artifacts-base

clean:
	rm -rf $(BASE_BUILD_DIR) $(REPRODUCIBLE_BUILD_DIR)/artifacts-*

.PHONY: check-ssh-key
check-ssh-key:
	@if grep -q "^SEARCHER_SSH_KEY=$$" env_files/bob_yocto_build_config.env; then \
		echo "Error: SEARCHER_SSH_KEY is not set in env_files/bob_yocto_build_config.env"; \
		exit 1; \
	fi

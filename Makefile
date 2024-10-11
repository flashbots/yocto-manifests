DOCKER?=docker

# Default YOCTO_ENV_FILE (can be overridden)
YOCTO_ENV_FILE?=env_files/tdx-base_yocto_build_config.env

.PHONY: image-rbuilder image-bob image-base prepare-dirs tdx-poky

image-rbuilder: prepare-dirs
	$(DOCKER) build -t yocto-builder:rbuilder -f reproducible-build/Dockerfile --build-arg MANIFEST=tdx-rbuilder.xml .
	$(DOCKER) run --rm --env-file env_files/rbuilder_yocto_build_config.env \
		-v $(CURDIR)/reproducible-build/artifacts-rbuilder:/artifacts \
		-v $(CURDIR)/build:/build \
		--build-arg MANIFEST=tdx-rbuilder.xml \
		yocto-builder:rbuilder
	chmod 0755 build reproducible-build/artifacts-rbuilder

image-bob: prepare-dirs check-ssh-key
	$(DOCKER) build -t yocto-builder:bob -f reproducible-build/Dockerfile --build-arg MANIFEST=tdx-bob.xml .
	$(DOCKER) run --rm --env-file env_files/bob_yocto_build_config.env \
		-v $(CURDIR)/reproducible-build/artifacts-bob:/artifacts \
		-v $(CURDIR)/build:/build \
		--build-arg MANIFEST=tdx-bob.xml \
		yocto-builder:bob
	chmod 0755 build reproducible-build/artifacts-bob

image-base: prepare-dirs
	$(DOCKER) build -t yocto-builder:base -f reproducible-build/Dockerfile --build-arg MANIFEST=tdx-base.xml .
	$(DOCKER) run --rm --env-file env_files/base_yocto_build_config.env \
		-v $(CURDIR)/reproducible-build/artifacts-base:/artifacts \
		-v $(CURDIR)/build:/build \
		--build-arg MANIFEST=tdx-base.xml \
		yocto-builder:base
	chmod 0755 build reproducible-build/artifacts-base

prepare-dirs:
	mkdir -p build && chmod 0777 ./build
	mkdir -p reproducible-build/artifacts-rbuilder && chmod 0777 reproducible-build/artifacts-rbuilder
	mkdir -p reproducible-build/artifacts-bob && chmod 0777 reproducible-build/artifacts-bob
	mkdir -p reproducible-build/artifacts-base && chmod 0777 reproducible-build/artifacts-base

.PHONY: check-ssh-key
check-ssh-key:
	@if grep -q "^SEARCHER_SSH_KEY=$$" env_files/bob_yocto_build_config.env; then \
		echo "Error: SEARCHER_SSH_KEY is not set in env_files/bob_yocto_build_config.env"; \
		exit 1; \
	fi

# Keeping the original azure-image target for backwards compatibility
.PHONY: azure-image
azure-image: tdx-poky
	mkdir -p build && chmod 0777 ./build
	mkdir -p reproducible-build/artifacts && chmod 0777 reproducible-build/artifacts
	$(DOCKER) run --rm --env-file $(YOCTO_ENV_FILE) -it -v $(CURDIR)/reproducible-build/artifacts:/artifacts -v $(CURDIR)/build:/build tdx-poky
	chmod 0755 build reproducible-build/artifacts

.PHONY: tdx-poky
tdx-poky:
	$(DOCKER) build -t tdx-poky reproducible-build/

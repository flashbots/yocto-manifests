DOCKER?=docker
YOCTO_ENV_FILE?=yocto_build_config.env

.PHONY: azure-image
azure-image: tdx-poky
	mkdir -p build && chmod 0777 ./build
	mkdir -p reproducible-build/artifacts && chmod 0777 reproducible-build/artifacts
	$(DOCKER) run --rm --env-file $(YOCTO_ENV_FILE) -it -v $(CURDIR)/reproducible-build/artifacts:/artifacts -v $(CURDIR)/build:/build tdx-poky
	chmod 0755 build reproducible-build/artifacts

.PHONY: tdx-poky
tdx-poky: check-ssh-key
	$(DOCKER) build -t tdx-poky reproducible-build/

.PHONY: check-ssh-key
check-ssh-key:
	@if grep -q "^SEARCHER_SSH_KEY=$$" $(YOCTO_ENV_FILE); then \
		echo "Error: SEARCHER_SSH_KEY is not set in $(YOCTO_ENV_FILE)"; \
		exit 1; \
	fi
	
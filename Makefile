DOCKER?=docker

.PHONY: azure-image
azure-image: tdx-poky
	mkdir -p build && chmod 0777 ./build
	mkdir -p reproducible-build/artifacts && chmod 0777 reproducible-build/artifacts
	$(DOCKER) run --rm -it -e SSH_KEY="$(SSH_KEY)" -v $(CURDIR)/reproducible-build/artifacts:/artifacts -v $(CURDIR)/build:/build tdx-poky
	chmod 0755 build reproducible-build/artifacts

.PHONY: tdx-poky
tdx-poky: check-ssh-key
	$(DOCKER) build -t tdx-poky --build-arg SSH_KEY="$(SSH_KEY)" reproducible-build/

.PHONY: check-ssh-key
check-ssh-key:
	@if [ -z "$(SSH_KEY)" ]; then \
		echo "Error: SSH_KEY is not set. Please set it before running the make command."; \
		exit 1; \
	fi
	
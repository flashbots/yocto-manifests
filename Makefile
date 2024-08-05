DOCKER?=docker

.PHONY: azure-image
azure-image: tdx-poky
	mkdir -p build && chmod 0777 ./build
	mkdir -p reproducible-build/artifacts && chmod 0777 reproducible-build/artifacts
	$(DOCKER) run --rm -it -v $(CURDIR)/reproducible-build/artifacts:/artifacts -v $(CURDIR)/build:/build tdx-poky
	chmod 0755 build reproducible-build/artifacts

.PHONY: tdx-poky
tdx-poky:
	$(DOCKER) build -t tdx-poky reproducible-build/

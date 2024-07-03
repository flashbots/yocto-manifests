DOCKER?=docker

reproducible-build/rbuilder:
	git clone git@github.com:flashbots/rbuilder-private.git reproducible-build/rbuilder
	cd rbuilder && git checkout 60cab091848e90ee78cca7a2e8b0043edec1f472

.PHONY: build/rbuilder
build/rbuilder: reproducible-build/rbuilder
	$(DOCKER) build --platform linux/amd64 --output=. -f reproducible-build/rbuilder.Dockerfile ./reproducible-build/

reproducible-build/lighthouse:
	git clone git@github.com:sigp/lighthouse.git reproducible-build/lighthouse
	cd lighthouse && git checkout v5.2.1

.PHONY: build/lighthouse
build/lighthouse: reproducible-build/lighthouse
	$(DOCKER) build --platform linux/amd64 --output=. -f reproducible-build/lighthouse.Dockerfile ./reproducible-build/lighthouse/

.PHONY: tdx-poky
tdx-poky:
	$(DOCKER) build -t tdx-poky reproducible-build/

.PHONY: azure-image
azure-image: tdx-poky build/rbuilder build/lighthouse
	mkdir -p ./build && chmod 0777 ./build
	$(DOCKER) run --rm -it -v $(CURDIR)/build:/build -v $(shell readlink -f ${SSH_AUTH_SOCK}):/ssh-agent -e SSH_AUTH_SOCK=/ssh-agent tdx-poky
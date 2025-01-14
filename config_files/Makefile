.PHONY: build gen-measurements

build:
	cd srcs/poky/ && bitbake core-image-minimal

gen-measurements:
	mkdir -p measurements
	CURRENT_DIR=$(shell pwd) && \
	IMAGE_DIR=$$CURRENT_DIR/srcs/poky/build/tmp/deploy/images/tdx && \
	cd srcs/poky/meta-confidential-compute/scripts/measured-boot && \
	for script in precalculate_pcr*; do \
		output_file="$$CURRENT_DIR/measurements/$$(basename $$script .sh | sed 's/precalculate_//')_output.json"; \
		./$$script $$IMAGE_DIR/core-image-minimal-tdx.rootfs.wic.vhd $$output_file >/dev/null; \
	done

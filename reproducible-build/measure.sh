#!/bin/bash

set -e

source /build/srcs/poky/oe-init-build-env

for image in /artifacts/*.vhd
do
	image_name=$(basename $image | sed -e "s|\..*||")
	output_file=measurement-${image_name}.json
	/app/measured-boot $image /artifacts/$output_file
done

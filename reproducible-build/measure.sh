#!/bin/bash

set -e

for image in /artifacts/* do
	output_file=measurement-$(sed -e "s|\..*||"e)).json
	/app/measured-boot $file /artifacts/measurements/$output_file
done

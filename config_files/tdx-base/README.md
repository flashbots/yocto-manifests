# TDX Base Profile

This is the minimal TEE-enabled profile that serves as a foundation for other specialized images. It provides basic AMD SEV-SNP/TDX support with essential security features.

## Features
- Basic AMD SEV-SNP/TDX support
- TPM2 integration
- Minimal system footprint

## Included Layers
- meta-confidential-compute: Core confidential computing support
- meta-openembedded: Basic system utilities and libraries
- poky: Base Yocto distribution

## Build Configuration
- Image Type: `core-image-minimal`
- Package Format: IPK
- Supported Machine: tdx
- Distribution: cvm

## Environment Variables
The following environment variables can be set to customize the build:
- `DEBUG_TWEAKS_ENABLED`: Enable debug features (default: 1)
- `DISK_ENCRYPTION_KEY_STORAGE`: Configure disk encryption key storage location (optional)
- `TARGET_LUN`: The logical unit number of the attached disk (optiona, default: 10)

## Usage
```bash
make image-base
```

For measurement generation:
```bash
make measurements-base
```

Build artifacts will be available in `reproducible-build/artifacts-base/`.

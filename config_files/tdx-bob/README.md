# TDX BOB (Builder/Searcher) Profile

This profile creates a specialized image for running searcher nodes in confidential compute environments. It includes podman support and searcher-specific configurations.

## Features
- AMD SEV-SNP/TDX support
- Secure container runtime isolation via podman
- SSH key-based authentication
- TPM2 measurements and attestation

## Included Layers
- meta-confidential-compute: Core confidential computing support
- meta-openembedded: System utilities and libraries
- meta-secure-core: Security features
- meta-virtualization: Container support
- meta-custom-podman: Customized podman configuration
- meta-searcher: Searcher-specific features
- poky: Base Yocto distribution

## Build Configuration
- Image Type: `core-image-minimal`
- Package Format: IPK
- Supported Machine: tdx
- Distribution: cvm

## Required Configuration
Before building, you must set the following in env_files/bob_yocto_build_config.env:
- `SEARCHER_SSH_KEY`: SSH public key for searcher access (required)

## Usage
```bash
# First set SEARCHER_SSH_KEY in env_files/bob_yocto_build_config.env
make image-bob
```

For measurement generation:
```bash
make measurements-bob
```

Build artifacts will be available in `reproducible-build/artifacts-bob/`.

## Notes
- Ensure SSH key is properly configured before building
- The image is optimized for searcher workloads
- Includes container management capabilities

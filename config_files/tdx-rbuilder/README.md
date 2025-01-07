# TDX RBuilder Profile

This profile creates an image optimized for running Ethereum validators and builders, including reth and lighthouse clients. It provides a comprehensive environment for blockchain node operation.

## Features
- AMD SEV-SNP/TDX support
- Rust/Clang toolchain support
- EVM integration
- Observability tools
- Secure container runtime isolation via podman
- Builder/validator configuration

## Included Layers
- meta-confidential-compute: Core confidential computing support
- meta-openembedded: System utilities and libraries
- meta-secure-core: Security features
- meta-virtualization: Container support
- meta-clang: LLVM/Clang compiler support
- meta-evm: Ethereum Virtual Machine support
- meta-rust-bin: Rust toolchain
- meta-observability: Monitoring tools
- meta-custom-podman: Container runtime
- poky: Base Yocto distribution

## Build Configuration
- Image Type: `cvm-image-azure`
- Package Format: IPK
- Supported Machine: tdx
- Distribution: cvm

## Environment Variables
The following environment variables can be set in env_files/rbuilder_yocto_build_config.env:
- `DEBUG_TWEAKS_ENABLED`: Enable debug features (default: 1)
- `INCLUDE_RCLONE`: Include rclone tool (default: 1)
- `INIT_CONFIG_URL`: Builder initialization config URL
- `DISK_ENCRYPTION_KEY_STORAGE`: Configure disk encryption key storage location (optional)
- `SSH_PUBKEY`: SSH public key for access (optional)
- `TARGET_LUN`: The logical unit number of the attached disk (optiona, default: 10)

## Usage
```bash
make image-rbuilder
```

For measurement generation:
```bash
make measurements-rbuilder
```

Build artifacts will be available in `reproducible-build/artifacts-rbuilder/`.

## Notes
- Includes full development toolchain
- Enhanced monitoring capabilities
- Container support for service isolation

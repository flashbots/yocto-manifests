# TDX BuilderNet Profile

This profile creates an image to run as part of [BuilderNet](https://buildernet.org/). Includes Lighthouse, Reth, and rbuilder.

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
The following environment variables can be set in env_files/buildernet_yocto_build_config.env:
- `DEBUG_TWEAKS_ENABLED`: Enable debug features (default: 1)
- `INCLUDE_RCLONE`: Include rclone tool (default: 1)
- `INIT_CONFIG_URL`: Builder initialization config URL
- `DISK_ENCRYPTION_KEY_STORAGE`: Configure disk encryption key storage location (optional)
- `SSH_PUBKEY`: SSH public key for access (optional)
- `TARGET_LUN`: The logical unit number of the attached disk (optional, default: 10)

## Usage
```bash
make image-buildernet
```

For measurement generation:
```bash
make measurements-buildernet
```

Build artifacts will be available in `reproducible-build/artifacts-buildernet/`.

## Notes
- Includes full development toolchain
- Enhanced monitoring capabilities
- Container support for service isolation

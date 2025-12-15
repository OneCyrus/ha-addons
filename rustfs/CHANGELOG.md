# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-12-15

### Added

- Initial release of RustFS S3 Server add-on
- Using RustFS version 1.0.0-alpha.73 (latest release)
- S3-compatible object storage server
- Support for aarch64 (Raspberry Pi 4), amd64, and armv7 architectures
- Web-based admin console
- Configurable storage path mapping to Home Assistant `/share` directory
- Auto-generated access and secret keys for security
- Configurable log levels (error, warn, info, debug, trace)
- Default bucket creation on startup
- Comprehensive documentation and usage examples
- Support for AWS CLI, boto3, Node.js SDK, and rclone
- s6-overlay service management for reliability
- Proper file permissions and ownership (UID 10001)

### Security

- Secure credential handling with auto-generation
- Password-type configuration for secret keys
- Proper file permissions on configuration files

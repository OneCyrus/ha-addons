# Home Assistant Add-on: RustFS S3 Server

![Version](https://img.shields.io/badge/version-1.0.0-blue.svg)
![Supports aarch64 Architecture](https://img.shields.io/badge/aarch64-yes-green.svg)
![Supports amd64 Architecture](https://img.shields.io/badge/amd64-yes-green.svg)
![Supports armv7 Architecture](https://img.shields.io/badge/armv7-yes-green.svg)

High-performance S3-compatible object storage server written in Rust.

## About

RustFS is a blazing-fast, S3-compatible object storage server built with Rust. It provides a lightweight alternative to MinIO or AWS S3 for local storage needs, perfect for backups, media storage, and application data.

### Features

- 🚀 **High Performance**: Written in Rust for maximum speed and efficiency
- 🔒 **S3 Compatible**: Works with any S3-compatible client or SDK
- 🌐 **Web Console**: Built-in web interface for easy management
- 🔐 **Secure**: Configurable access and secret keys for authentication
- 💾 **Persistent Storage**: Data stored in Home Assistant's `/share` directory
- 🎯 **Default Bucket**: Automatically creates a default bucket on startup
- 🔧 **Configurable**: Flexible configuration options for various use cases

### Use Cases

- **Backup Storage**: Store Home Assistant backups and snapshots
- **Media Server**: Host media files for Plex, Jellyfin, or other media servers
- **Application Data**: S3-compatible storage for applications and integrations
- **Development**: Local S3 endpoint for testing and development

## Installation

1. Add this repository to your Home Assistant add-on store
2. Install the "RustFS S3 Server" add-on
3. Configure the add-on (see Configuration section)
4. Start the add-on
5. Check the logs for your access credentials

## Configuration

See the [full documentation](DOCS.md) for detailed configuration options.

## Support

For issues and feature requests, please visit the [GitHub repository](https://github.com/OneCyrus/ha-addons).

## License

Apache License 2.0 - See [LICENSE](LICENSE) for details.

# GarageHQ S3 Server

## Overview
GarageHQ is a lightweight S3-compatible storage server that can be used to store and retrieve files using the S3 API protocol. This add-on allows you to run your own S3-compatible storage server within Home Assistant.

## Features
- Full S3 API compatibility
- Configurable storage location
- Easy integration with existing S3 clients
- Simple authentication with access/secret keys
- Persistent storage using Home Assistant's share folder
- Optional web interface for static website hosting
- Automatic metadata snapshots for data integrity

## Installation

1. Add this repository to your Home Assistant instance
2. Install the "GarageHQ S3 Server" add-on
3. Configure the add-on (see configuration section)
4. Start the add-on

## Configuration

### Required Configuration

- `storage_path`: The path where GarageHQ will store its data. Defaults to `/share/garagehq`
- `access_key`: Your desired S3 access key (like an AWS access key)
- `secret_key`: Your desired S3 secret key (like an AWS secret key)
- `region`: S3 region name (defaults to us-east-1)
- `replication_factor`: The number of copies of each object to store (1-3). For a single node deployment, use 1.
- `web_ui_enabled`: Enable the web interface for static website hosting
- `log_level`: The log level for the Garage server (error, warn, info, debug, trace)
- `snapshot_interval`: Interval for automatic metadata snapshots (e.g., 24h, 7d). Helps with recovery in case of database corruption.

### Advanced Configuration

Enable `advanced_options` to access these settings:

- `rpc_secret`: Custom RPC secret for node communication (auto-generated if not provided)
- `metadata_dir`: Custom directory for metadata storage
- `data_dir`: Custom directory for data storage

Example configuration:
```yaml
storage_path: /share/garagehq
access_key: AKIAIOSFODNN7EXAMPLE
secret_key: wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
region: us-east-1
replication_factor: 1
web_ui_enabled: true
log_level: info
snapshot_interval: 24h
advanced_options: false
```

## Using with S3 clients

The GarageHQ server exposes an S3-compatible API on port 9000. You can use any S3-compatible client to connect to it. Here are some examples:

### AWS CLI
```bash
aws s3 --endpoint-url http://your-ha-ip:9000 ls
```

### MinIO Client
```bash
mc alias set garagehq http://your-ha-ip:9000 YOUR_ACCESS_KEY YOUR_SECRET_KEY
mc ls garagehq/
```

### Python (using boto3)
```python
import boto3

s3 = boto3.client('s3',
    endpoint_url='http://your-ha-ip:9000',
    aws_access_key_id='YOUR_ACCESS_KEY',
    aws_secret_access_key='YOUR_SECRET_KEY'
)
```

## Static Website Hosting

If you enable the web UI, you can host static websites from your buckets. To do this:

1. Create a bucket with the name of your website
2. Upload your website files to the bucket (make sure to include an index.html file)
3. Access your website at http://your-ha-ip:3902

## Backup and Restore

The add-on automatically backs up all data when a Home Assistant backup is created. To ensure data integrity, it's recommended to create regular backups of your Home Assistant instance.

Additionally, the add-on creates automatic snapshots of the metadata database at the interval specified in the `snapshot_interval` option. These snapshots can be used to recover from database corruption in case of unexpected shutdowns or power failures.

## Troubleshooting

### Common Issues

- **Connection refused**: Make sure the add-on is running and the port 9000 is not blocked by a firewall.
- **Authentication failed**: Double-check your access key and secret key.
- **Bucket not found**: Make sure you've created the bucket before trying to use it.

### Logs

Check the add-on logs for more detailed information about any issues. You can increase the log level to `debug` or `trace` for more verbose logging.

## Support

If you encounter any issues or have questions, please open an issue on the [GitHub repository](https://github.com/home-assistant/addons/tree/master/garagehq).

## Credits

This add-on is based on the [Garage](https://garagehq.deuxfleurs.fr/) project, an open-source distributed object storage service.

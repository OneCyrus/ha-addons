# GarageHQ S3 Server

## Overview
GarageHQ is a lightweight S3-compatible storage server that can be used to store and retrieve files using the S3 API protocol. This add-on allows you to run your own S3-compatible storage server within Home Assistant.

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

Example configuration:
```yaml
storage_path: /share/garagehq
access_key: AKIAIOSFODNN7EXAMPLE
secret_key: wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
region: us-east-1
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

## Network Access

The add-on exposes port 9000 for S3 API access. Make sure this port is accessible from the clients that need to connect to the S3 server.
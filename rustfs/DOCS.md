# Home Assistant Add-on: RustFS S3 Server

## Overview

RustFS is a high-performance, S3-compatible object storage server written in Rust. This add-on provides a local S3-compatible storage solution for Home Assistant, perfect for backups, media storage, and application data.

## Installation

1. Navigate to the Supervisor panel in Home Assistant
2. Go to the Add-on Store
3. Add this repository if you haven't already
4. Find "RustFS S3 Server" in the list
5. Click "Install"
6. Wait for the installation to complete

## Configuration

### Basic Configuration

```yaml
storage_path: "/share/rustfs"
access_key: ""
secret_key: ""
console_enabled: true
log_level: "info"
server_domains: ""
default_bucket: "homeassistant"
```

### Configuration Options

#### `storage_path` (required)

The path where RustFS will store all data. Default is `/share/rustfs`.

- **Type**: string
- **Default**: `/share/rustfs`
- **Example**: `/share/rustfs` or `/share/s3-storage`

#### `access_key` (optional)

The S3 access key for authentication. If left empty, a random key will be generated automatically.

- **Type**: string
- **Default**: Auto-generated
- **Example**: `myaccesskey123`

**Note**: If auto-generated, the key will be displayed in the logs. Save it for future use!

#### `secret_key` (optional)

The S3 secret key for authentication. If left empty, a random key will be generated automatically.

- **Type**: password
- **Default**: Auto-generated
- **Example**: `mysecretkey456789`

**Note**: If auto-generated, the key will be displayed in the logs. Save it for future use!

#### `console_enabled` (required)

Enable or disable the web-based admin console.

- **Type**: boolean
- **Default**: `true`
- **Options**: `true` or `false`

When enabled, you can access the web console at `http://homeassistant.local:9001`

#### `log_level` (required)

Set the logging verbosity level.

- **Type**: list
- **Default**: `info`
- **Options**: `error`, `warn`, `info`, `debug`, `trace`

Use `debug` or `trace` for troubleshooting, `info` for normal operation.

#### `server_domains` (optional)

Comma-separated list of server domains for virtual-host-style requests.

- **Type**: string
- **Default**: Empty
- **Example**: `s3.example.com,storage.example.com`

Leave empty for most use cases.

#### `default_bucket` (optional)

Name of the default bucket to create on startup.

- **Type**: string
- **Default**: `homeassistant`
- **Example**: `backups` or `media`

Set to empty string to disable automatic bucket creation.

## Usage

### Accessing the S3 API

Once the add-on is running, the S3 API is available at:

```
http://homeassistant.local:9000
```

### Accessing the Web Console

If `console_enabled` is `true`, access the web console at:

```
http://homeassistant.local:9001
```

Log in with your configured (or auto-generated) access key and secret key.

### Using with S3 Clients

#### AWS CLI

Install the AWS CLI and configure it:

```bash
aws configure
# AWS Access Key ID: <your-access-key>
# AWS Secret Access Key: <your-secret-key>
# Default region name: us-east-1
# Default output format: json
```

Then use it with the `--endpoint-url` parameter:

```bash
# List buckets
aws --endpoint-url http://homeassistant.local:9000 s3 ls

# Create a bucket
aws --endpoint-url http://homeassistant.local:9000 s3 mb s3://mybucket

# Upload a file
aws --endpoint-url http://homeassistant.local:9000 s3 cp myfile.txt s3://mybucket/

# Download a file
aws --endpoint-url http://homeassistant.local:9000 s3 cp s3://mybucket/myfile.txt ./
```

#### Python (boto3)

```python
import boto3

# Create S3 client
s3 = boto3.client(
    's3',
    endpoint_url='http://homeassistant.local:9000',
    aws_access_key_id='your-access-key',
    aws_secret_access_key='your-secret-key',
    region_name='us-east-1'
)

# List buckets
response = s3.list_buckets()
print('Buckets:', [bucket['Name'] for bucket in response['Buckets']])

# Upload a file
s3.upload_file('myfile.txt', 'mybucket', 'myfile.txt')

# Download a file
s3.download_file('mybucket', 'myfile.txt', 'downloaded.txt')
```

#### Node.js (AWS SDK)

```javascript
const AWS = require('aws-sdk');

const s3 = new AWS.S3({
    endpoint: 'http://homeassistant.local:9000',
    accessKeyId: 'your-access-key',
    secretAccessKey: 'your-secret-key',
    s3ForcePathStyle: true,
    signatureVersion: 'v4'
});

// List buckets
s3.listBuckets((err, data) => {
    if (err) console.log(err);
    else console.log('Buckets:', data.Buckets);
});

// Upload a file
const fs = require('fs');
const fileContent = fs.readFileSync('myfile.txt');

s3.putObject({
    Bucket: 'mybucket',
    Key: 'myfile.txt',
    Body: fileContent
}, (err, data) => {
    if (err) console.log(err);
    else console.log('File uploaded successfully');
});
```

#### Rclone

Configure rclone:

```bash
rclone config
# Choose: n (New remote)
# Name: rustfs
# Storage: s3
# Provider: Other
# Access Key: <your-access-key>
# Secret Key: <your-secret-key>
# Endpoint: http://homeassistant.local:9000
# Leave other options as default
```

Use rclone:

```bash
# List buckets
rclone lsd rustfs:

# Copy files
rclone copy /path/to/files rustfs:mybucket

# Sync directories
rclone sync /path/to/dir rustfs:mybucket/dir
```

## Backup Integration

### Home Assistant Backups

You can use RustFS to store Home Assistant backups:

1. Create a backup bucket (or use the default `homeassistant` bucket)
2. Use an automation or script to copy backups to S3
3. Example automation:

```yaml
automation:
  - alias: "Backup to S3"
    trigger:
      - platform: time
        at: "02:00:00"
    action:
      - service: hassio.backup_full
        data:
          name: "Automated Backup {{ now().strftime('%Y-%m-%d') }}"
      - delay: "00:30:00"
      - service: shell_command.upload_backup_to_s3

shell_command:
  upload_backup_to_s3: >
    aws --endpoint-url http://homeassistant.local:9000 
    s3 sync /backup s3://homeassistant/backups/
```

## Troubleshooting

### Cannot Connect to S3 API

1. Check that the add-on is running
2. Verify port 9000 is accessible
3. Check the add-on logs for errors
4. Ensure your client is using the correct endpoint URL

### Authentication Errors

1. Verify your access key and secret key are correct
2. Check the add-on logs for the auto-generated credentials
3. Ensure your S3 client is configured with the correct credentials

### Permission Errors

1. Check that the storage path exists and is writable
2. Verify the add-on has access to the `/share` directory
3. Check the add-on logs for permission-related errors

### Web Console Not Accessible

1. Verify `console_enabled` is set to `true`
2. Check that port 9001 is accessible
3. Try accessing via IP address instead of hostname
4. Check browser console for errors

### Performance Issues

1. Ensure you're using local storage (not network storage)
2. Consider using SSD/NVMe storage for better performance
3. Increase log level to `debug` to identify bottlenecks
4. Check system resources (CPU, memory, disk I/O)

### Default Bucket Not Created

1. Check the `default_bucket` configuration option
2. Verify the storage path is writable
3. Check the add-on logs for errors during initialization
4. Try creating the bucket manually via the web console or S3 client

## Advanced Configuration

### Using Custom Domains

If you want to use virtual-host-style requests (e.g., `bucket.s3.example.com`):

1. Set up DNS records pointing to your Home Assistant instance
2. Configure `server_domains` with your domain(s)
3. Use a reverse proxy (like Nginx Proxy Manager) to handle SSL/TLS

Example configuration:

```yaml
server_domains: "s3.example.com"
```

### Security Considerations

1. **Change Default Credentials**: Always set custom access and secret keys
2. **Use Strong Keys**: Generate long, random keys for better security
3. **Network Access**: Consider restricting access to trusted networks only
4. **HTTPS**: Use a reverse proxy with SSL/TLS for production use
5. **Regular Backups**: Keep backups of your S3 data in multiple locations

## Performance Tips

1. **Storage**: Use local SSD/NVMe storage for best performance
2. **Network**: Use wired Ethernet instead of Wi-Fi when possible
3. **Resources**: Ensure adequate CPU and RAM for your workload
4. **Buckets**: Organize data into multiple buckets for better management
5. **Cleanup**: Regularly delete unused objects to free up space

## Support

For issues, feature requests, or questions:

- GitHub Issues: [https://github.com/OneCyrus/ha-addons/issues](https://github.com/OneCyrus/ha-addons/issues)
- Home Assistant Community: [https://community.home-assistant.io/](https://community.home-assistant.io/)

## Credits

- RustFS: [https://github.com/rustfs/rustfs](https://github.com/rustfs/rustfs)
- Home Assistant: [https://www.home-assistant.io/](https://www.home-assistant.io/)

## License

This add-on is licensed under the Apache License 2.0.
RustFS is licensed under the Apache License 2.0.

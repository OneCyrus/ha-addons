#!/usr/bin/with-contenv bashio

# Get config values
STORAGE_PATH=$(bashio::config 'storage_path')
ACCESS_KEY=$(bashio::config 'access_key')
SECRET_KEY=$(bashio::config 'secret_key')
REGION=$(bashio::config 'region')
REPLICATION_FACTOR=$(bashio::config 'replication_factor')
WEB_UI_ENABLED=$(bashio::config 'web_ui_enabled')
ADVANCED_OPTIONS=$(bashio::config 'advanced_options')
LOG_LEVEL=$(bashio::config 'log_level')

# Create storage directories
mkdir -p "${STORAGE_PATH}"
mkdir -p "${STORAGE_PATH}/meta"
mkdir -p "${STORAGE_PATH}/data"
mkdir -p "${STORAGE_PATH}/snapshots"

# Set up configuration file
CONFIG_DIR="/config"
CONFIG_FILE="${CONFIG_DIR}/garage.toml"

# Create config directory if it doesn't exist
mkdir -p "${CONFIG_DIR}"

# Generate a random RPC secret if not provided
if bashio::config.exists 'rpc_secret'; then
    RPC_SECRET=$(bashio::config 'rpc_secret')
else
    RPC_SECRET=$(openssl rand -hex 32)
    bashio::log.info "Generated random RPC secret"
fi

# Set metadata and data directories
if bashio::config.exists 'metadata_dir' && [[ $(bashio::config 'metadata_dir') != "" ]]; then
    METADATA_DIR=$(bashio::config 'metadata_dir')
    mkdir -p "${METADATA_DIR}"
else
    METADATA_DIR="${STORAGE_PATH}/meta"
fi

if bashio::config.exists 'data_dir' && [[ $(bashio::config 'data_dir') != "" ]]; then
    DATA_DIR=$(bashio::config 'data_dir')
    mkdir -p "${DATA_DIR}"
else
    DATA_DIR="${STORAGE_PATH}/data"
fi

# Create the configuration file
cat > "${CONFIG_FILE}" << EOF
metadata_dir = "${METADATA_DIR}"
data_dir = "${DATA_DIR}"
metadata_snapshots_dir = "${STORAGE_PATH}/snapshots"
db_engine = "sqlite"
metadata_auto_snapshot_interval = "$(bashio::config 'snapshot_interval')"

replication_factor = ${REPLICATION_FACTOR}

rpc_bind_addr = "[::]:3901"
rpc_public_addr = "127.0.0.1:3901"
rpc_secret = "${RPC_SECRET}"

[s3_api]
s3_region = "${REGION}"
api_bind_addr = "[::]:9000"
root_domain = ".s3.garage.local"

EOF

# Add web UI configuration if enabled
if bashio::var.true "${WEB_UI_ENABLED}"; then
    cat >> "${CONFIG_FILE}" << EOF
[s3_web]
bind_addr = "[::]:3902"
root_domain = ".web.garage.local"
index = "index.html"
EOF
fi

# Set environment variable for log level
export RUST_LOG="garage=${LOG_LEVEL}"

# Log the configuration
bashio::log.info "Starting GarageHQ S3 Server..."
bashio::log.info "Storage path: ${STORAGE_PATH}"
bashio::log.info "Metadata directory: ${METADATA_DIR}"
bashio::log.info "Data directory: ${DATA_DIR}"
bashio::log.info "Replication factor: ${REPLICATION_FACTOR}"
bashio::log.info "S3 region: ${REGION}"
bashio::log.info "Log level: ${LOG_LEVEL}"
if bashio::var.true "${WEB_UI_ENABLED}"; then
    bashio::log.info "Web UI enabled on port 3902"
fi

# Start Garage server
bashio::log.info "Starting Garage server..."
garage -c "${CONFIG_FILE}" server &
SERVER_PID=$!

# Wait for server to start
sleep 5

# Initialize the layout if this is the first run
if [ ! -f "${STORAGE_PATH}/.initialized" ]; then
    bashio::log.info "First run detected, initializing cluster layout..."

    # Get node ID
    NODE_ID=$(garage -c "${CONFIG_FILE}" node id | awk '{print $1}')

    # Assign layout
    bashio::log.info "Assigning layout with node ID: ${NODE_ID}"
    garage -c "${CONFIG_FILE}" layout assign -z dc1 -c 1G "${NODE_ID}"

    # Apply layout
    bashio::log.info "Applying layout..."
    garage -c "${CONFIG_FILE}" layout apply --version 1

    # Create marker file to indicate initialization is complete
    touch "${STORAGE_PATH}/.initialized"

    bashio::log.info "Cluster layout initialized successfully"
fi

# Check if access key is already created
if [ ! -f "${STORAGE_PATH}/.key_created" ] && [ -n "${ACCESS_KEY}" ] && [ -n "${SECRET_KEY}" ]; then
    bashio::log.info "Creating access key..."

    # Create key with specified credentials
    echo "${SECRET_KEY}" | garage -c "${CONFIG_FILE}" key import "${ACCESS_KEY}"

    # Create marker file to indicate key creation is complete
    touch "${STORAGE_PATH}/.key_created"

    bashio::log.info "Access key created successfully"
fi

# Keep the script running
wait ${SERVER_PID}

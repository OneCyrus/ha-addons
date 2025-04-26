#!/usr/bin/with-contenv bashio

# Get config values
STORAGE_PATH=$(bashio::config 'storage_path')
ACCESS_KEY=$(bashio::config 'access_key')
SECRET_KEY=$(bashio::config 'secret_key')
REGION=$(bashio::config 'region')

# Ensure storage directory exists
mkdir -p "${STORAGE_PATH}"

# Configure environment variables
export GARAGEHQ_STORAGE_PATH="${STORAGE_PATH}"
export GARAGEHQ_ACCESS_KEY="${ACCESS_KEY}"
export GARAGEHQ_SECRET_KEY="${SECRET_KEY}"
export GARAGEHQ_REGION="${REGION}"

# Start GarageHQ
bashio::log.info "Starting GarageHQ S3 Server..."
/usr/local/bin/garagehq
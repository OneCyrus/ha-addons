ARG BUILD_FROM
FROM $BUILD_FROM

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Setup base
ARG GARAGE_VERSION="1.1.0"
ARG TARGETARCH

# Install required packages
RUN apk add --no-cache \
    bash \
    curl \
    jq \
    tzdata \
    ca-certificates

# Download and install Garage
RUN if [ "${TARGETARCH}" = "amd64" ]; then \
        DOWNLOAD_URL="https://garagehq.deuxfleurs.fr/_releases/v${GARAGE_VERSION}/x86_64-unknown-linux-musl/garage"; \
    elif [ "${TARGETARCH}" = "aarch64" ]; then \
        DOWNLOAD_URL="https://garagehq.deuxfleurs.fr/_releases/v${GARAGE_VERSION}/aarch64-unknown-linux-musl/garage"; \
    elif [ "${TARGETARCH}" = "armv7" ]; then \
        DOWNLOAD_URL="https://garagehq.deuxfleurs.fr/_releases/v${GARAGE_VERSION}/armv6l-unknown-linux-musleabihf/garage"; \
    elif [ "${TARGETARCH}" = "armhf" ]; then \
        DOWNLOAD_URL="https://garagehq.deuxfleurs.fr/_releases/v${GARAGE_VERSION}/armv6l-unknown-linux-musleabihf/garage"; \
    elif [ "${TARGETARCH}" = "386" ]; then \
        DOWNLOAD_URL="https://garagehq.deuxfleurs.fr/_releases/v${GARAGE_VERSION}/i686-unknown-linux-musl/garage"; \
    else \
        DOWNLOAD_URL="https://garagehq.deuxfleurs.fr/_releases/v${GARAGE_VERSION}/x86_64-unknown-linux-musl/garage"; \
    fi \
    && echo "Downloading from: ${DOWNLOAD_URL}" \
    && curl -L -s "${DOWNLOAD_URL}" -o /usr/local/bin/garage \
    && chmod +x /usr/local/bin/garage

# Copy data
COPY run.sh /
RUN chmod a+x /run.sh

# Labels
LABEL \
    io.hass.name="GarageHQ S3 Server" \
    io.hass.description="S3-compatible storage server for Home Assistant" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION} \
    io.hass.arch="${BUILD_ARCH}" \
    maintainer="Home Assistant Community Add-ons"

ENTRYPOINT ["/run.sh"]

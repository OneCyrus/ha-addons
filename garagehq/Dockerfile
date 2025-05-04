ARG BUILD_FROM=ghcr.io/hassio-addons/debian-base:7.7.0
FROM ${BUILD_FROM}

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Setup base
ENV GARAGE_VERSION="1.1.0"

# Download and install Garage
RUN echo "Building for architecture: ${BUILD_ARCH}" \
    && if [ "${BUILD_ARCH}" = "amd64" ]; then \
        DOWNLOAD_URL="https://garagehq.deuxfleurs.fr/_releases/v${GARAGE_VERSION}/x86_64-unknown-linux-musl/garage"; \
    elif [ "${BUILD_ARCH}" = "aarch64" ]; then \
        DOWNLOAD_URL="https://garagehq.deuxfleurs.fr/_releases/v${GARAGE_VERSION}/aarch64-unknown-linux-musl/garage"; \
    elif [ "${BUILD_ARCH}" = "armv7" ]; then \
        DOWNLOAD_URL="https://garagehq.deuxfleurs.fr/_releases/v${GARAGE_VERSION}/armv6l-unknown-linux-musleabihf/garage"; \
    elif [ "${BUILD_ARCH}" = "armhf" ]; then \
        DOWNLOAD_URL="https://garagehq.deuxfleurs.fr/_releases/v${GARAGE_VERSION}/armv6l-unknown-linux-musleabihf/garage"; \
    elif [ "${BUILD_ARCH}" = "i386" ]; then \
        DOWNLOAD_URL="https://garagehq.deuxfleurs.fr/_releases/v${GARAGE_VERSION}/i686-unknown-linux-musl/garage"; \
    else \
        DOWNLOAD_URL="https://garagehq.deuxfleurs.fr/_releases/v${GARAGE_VERSION}/x86_64-unknown-linux-musl/garage"; \
    fi \
    && echo "Downloading from: ${DOWNLOAD_URL}" \
    && curl ${DOWNLOAD_URL} -o /usr/local/bin/garage \
    && chmod +x /usr/local/bin/garage

# Copy root filesystem
COPY rootfs /

# Labels
LABEL \
    io.hass.name="GarageHQ S3 Server" \
    io.hass.description="S3-compatible storage server for Home Assistant" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION} \
    io.hass.arch="${BUILD_ARCH}" \
    maintainer="Home Assistant Community Add-ons"

# ENTRYPOINT ["/run.sh"]

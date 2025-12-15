ARG BUILD_FROM=ghcr.io/hassio-addons/debian-base:7.7.0
FROM ${BUILD_FROM}

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Setup base system
ARG BUILD_ARCH=amd64
ENV RUSTFS_VERSION="0.3.0"

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        curl \
        ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Download and install RustFS based on architecture
RUN echo "Building for architecture: ${BUILD_ARCH}" \
    && if [ "${BUILD_ARCH}" = "amd64" ]; then \
        RUSTFS_ARCH="x86_64"; \
    elif [ "${BUILD_ARCH}" = "aarch64" ]; then \
        RUSTFS_ARCH="aarch64"; \
    elif [ "${BUILD_ARCH}" = "armv7" ]; then \
        RUSTFS_ARCH="armv7"; \
    else \
        echo "Unsupported architecture: ${BUILD_ARCH}"; \
        exit 1; \
    fi \
    && DOWNLOAD_URL="https://github.com/rustfs/rustfs/releases/download/v${RUSTFS_VERSION}/rustfs-${RUSTFS_ARCH}-unknown-linux-musl" \
    && echo "Downloading from: ${DOWNLOAD_URL}" \
    && curl -L -f "${DOWNLOAD_URL}" -o /usr/local/bin/rustfs \
    && chmod +x /usr/local/bin/rustfs

# Create rustfs user with UID 10001
RUN useradd -u 10001 -U -M -s /bin/false rustfs

# Copy root filesystem
COPY rootfs /

# Build arguments
ARG BUILD_DATE
ARG BUILD_DESCRIPTION
ARG BUILD_NAME
ARG BUILD_REF
ARG BUILD_REPOSITORY
ARG BUILD_VERSION

# Labels
LABEL \
    io.hass.name="${BUILD_NAME}" \
    io.hass.description="${BUILD_DESCRIPTION}" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION} \
    maintainer="OneCyrus" \
    org.opencontainers.image.title="${BUILD_NAME}" \
    org.opencontainers.image.description="${BUILD_DESCRIPTION}" \
    org.opencontainers.image.vendor="OneCyrus" \
    org.opencontainers.image.authors="OneCyrus" \
    org.opencontainers.image.licenses="Apache-2.0" \
    org.opencontainers.image.url="https://github.com/OneCyrus/ha-addons" \
    org.opencontainers.image.source="https://github.com/${BUILD_REPOSITORY}" \
    org.opencontainers.image.documentation="https://github.com/${BUILD_REPOSITORY}/blob/main/README.md" \
    org.opencontainers.image.created=${BUILD_DATE} \
    org.opencontainers.image.revision=${BUILD_REF} \
    org.opencontainers.image.version=${BUILD_VERSION}

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
        ARCH="x86_64"; \
    elif [ "${TARGETARCH}" = "aarch64" ]; then \
        ARCH="aarch64"; \
    elif [ "${TARGETARCH}" = "armv7" ]; then \
        ARCH="armv7"; \
    else \
        ARCH="x86_64"; \
    fi \
    && curl -L -s "https://garagehq.deuxfleurs.fr/download/garage-v${GARAGE_VERSION}-${ARCH}-unknown-linux-musl.tar.gz" \
        | tar xzf - -C /tmp \
    && mv /tmp/garage /usr/local/bin/garage \
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

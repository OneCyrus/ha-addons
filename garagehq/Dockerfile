ARG BUILD_FROM
FROM ${BUILD_FROM}

# Install GarageHQ
FROM garagehq/s3:latest

# Copy our run script
COPY run.sh /
RUN chmod a+x /run.sh

# Labels
LABEL \
    io.hass.name="GarageHQ S3 Server" \
    io.hass.description="S3-compatible storage server for Home Assistant" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION} \
    io.hass.arch="${BUILD_ARCH}"

ENTRYPOINT [ "/run.sh" ]
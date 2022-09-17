ARG BUILD_FROM=ghcr.io/hassio-addons/debian-base/amd64:6.0.0
FROM $BUILD_FROM

ENV LANG C.UTF-8

# Copy data for add-on
COPY victoria-metrics-prod_arm64_1-81-2 /victoria-metrics-prod
COPY prometheus.yml /
RUN chmod a+x /victoria-metrics-prod

CMD [ "/victoria-metrics-prod", "-storageDataPath", "/data" ] 
# , "-promscrape.config", "/prometheus.yml"]

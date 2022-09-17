ARG BUILD_FROM
FROM $BUILD_FROM

ENV LANG C.UTF-8

# Copy data for add-on
COPY victoria-metrics-prod_arm64_1-81-2 /tmp/victoria-metrics-prod
COPY prometheus.yml /
RUN chmod a+x /tmp/victoria-metrics-prod

CMD [ "/victoria-metrics-prod", "-storageDataPath", "/data" ] 
# , "-promscrape.config", "/prometheus.yml"]

ARG BUILD_FROM
FROM victoriametrics/victoria-metrics:v1.72.0

ENV LANG C.UTF-8

# Copy data for add-on
COPY victoria-metrics-prod_arm64_1-72 /
COPY prometheus.yml /
RUN chmod a+x /victoria-metrics-prod

CMD [ "/victoria-metrics-prod", "-storageDataPath", "/data" ] 
# , "-promscrape.config", "/prometheus.yml"]

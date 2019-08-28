#########################
# graylog sidecar       #
#########################
FROM debian:jessie-slim

# Update and install some required dependencies
RUN apt-get update && apt-get install -y openssl libapr1 libdbi1 libexpat1 ca-certificates

# Install Graylog Sidecar (Filebeat included)
ENV SIDECAR_BINARY_URL  https://github.com/Graylog2/collector-sidecar/releases/download/1.0.2/graylog-sidecar_1.0.2-1_amd64.deb
ENV filebeat_url https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-7.3.1-amd64.deb
RUN apt-get install -y --no-install-recommends curl && \
    curl -Lo collector.deb ${SIDECAR_BINARY_URL} && \
    dpkg -i collector.deb && \
    rm collector.deb && \
    curl -Lo filebeat.deb ${filebeat_url} && \
    dpkg -i filebeat.deb && \
    rm filebeat.deb && \
    filebeat version && \
    apt-get purge -y --auto-remove curl


# Define default environment values
ENV server_url="" \
    server_api_token="" \
    node_name=""


ADD ./data /data

CMD /data/start.sh

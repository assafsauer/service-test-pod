FROM ubuntu:20.04

# Install required packages
RUN apt-get update && \
    apt-get install -y gnupg2 wget openjdk-8-jdk mongodb-clients rabbitmq-server postgresql-13 postgresql-client-13 && \
    wget -q -O - https://packages.grafana.com/gpg.key | apt-key add - && \
    echo "deb https://packages.grafana.com/oss/deb stable main" | tee /etc/apt/sources.list.d/grafana.list && \
    apt-get update && \
    apt-get install -y grafana && \
    wget https://github.com/prometheus/prometheus/releases/download/v2.30.3/prometheus-2.30.3.linux-amd64.tar.gz && \
    tar -xzf prometheus-2.30.3.linux-amd64.tar.gz && \
    rm prometheus-2.30.3.linux-amd64.tar.gz && \
    mv prometheus-2.30.3.linux-amd64 /usr/local/prometheus && \
    echo "postgres:5432:*:postgres:postgres" > ~/.pgpass && \
    chmod 0600 ~/.pgpass

# Set environment variables
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/
ENV PATH=${PATH}:${JAVA_HOME}/bin:/usr/local/prometheus

# Copy JMeter test plan
COPY test.jmx /test.jmx

# Copy Grafana dashboards
COPY dashboard.json /dashboard.json

# Copy Prometheus configuration file
COPY prometheus.yml /usr/local/prometheus/prometheus.yml

# Start services
CMD service rabbitmq-server start && service postgresql start && \
    prometheus --config.file=/usr/local/prometheus/prometheus.yml & \
    grafana-server --homepath=/usr/share/grafana &

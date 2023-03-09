FROM ubuntu:latest

# Install common dependencies
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    git \
    zip \
    unzip \
    vim \
    nano \
    gnupg \
    openssl \
    ca-certificates \
    apt-transport-https \
    software-properties-common \
    python3 \
    python3-pip \
    openjdk-11-jdk

RUN wget http://archive.ubuntu.com/ubuntu/pool/main/o/openssl/libssl1.1_1.1.0g-2ubuntu4_amd64.deb
RUN dpkg -i libssl1.1_1.1.0g-2ubuntu4_amd64.deb

# Install MongoDB testing tools
RUN wget -qO - https://www.mongodb.org/static/pgp/server-4.4.asc | apt-key add - \
    && echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/4.4 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-4.4.list \
    && apt-get update && apt-get install -y libssl1.1 mongodb-org-shell \
    && wget https://github.com/brianfrankcooper/YCSB/releases/download/0.18.0/ycsb-0.18.0.tar.gz \
    && tar xvfz ycsb-0.18.0.tar.gz

# Install RabbitMQ testing tools
RUN pip3 install pika \
    && wget https://github.com/rabbitmq/rabbitmq-perf-test/releases/download/v2.11.0/rabbitmq-perf-test-2.11.0.tar.gz \
    && tar xvfz rabbitmq-perf-test-2.11.0.tar.gz

# Install Nginx testing tools
RUN apt-get install -y apache2-utils \
    && wget https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-5.4.1.tgz \
    && tar xvfz apache-jmeter-5.4.1.tgz

# Install Spring testing tools
RUN wget https://repo1.maven.org/maven2/io/gatling/highcharts/gatling-charts-highcharts-bundle/3.6.0/gatling-charts-highcharts-bundle-3.6.0-bundle.zip \
    && unzip gatling-charts-highcharts-bundle-3.6.0-bundle.zip \
    && pip3 install locust

# Install Node.js testing tools
RUN npm install -g artillery \
    && npm install -g loadtest \
    && wget https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-5.4.1.tgz \
    && tar xvfz apache-jmeter-5.4.1.tgz

# Set up environment variables and entrypoint
ENV YCSB_HOME=/ycsb-0.18.0 \
    RABBITMQ_PERF_TEST_HOME=/rabbitmq-perf-test-2.11.0 \
    JMETER_HOME=/apache-jmeter-5.4.1
ENTRYPOINT ["/bin/bash"]

COPY tester.sh /app/
RUN chmod 777 /app/tester.sh

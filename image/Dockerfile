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

# Install MongoDB testing tools
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 656408E390CFB1F5 \
    && echo "deb [ arch=amd64,arm64 ] http://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/4.4 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-4.4.list \
    && apt-get update \
    && apt-get install -y mongodb-org-shell \
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

# Install Postgres client for JMeter
RUN apt-get install -y postgresql-client

# Install JMeter plugins for MongoDB, RabbitMQ, and Postgres
RUN wget https://repo1.maven.org/maven2/kg/apc/jmeter-plugins-cmn-jmeter/0.6/jmeter-plugins-cmn-jmeter-0.6.jar -P /apache-jmeter-5.4.1/lib/ext \
    && wget https://github.com/temptemp3/jmeter-AMQP/releases/download/0.5-alpha2/jmeter-rabbitmq-0.5-alpha2.jar -P /apache-jmeter-5.4.1/lib/ext \
    && wget https://repo1.maven.org/maven2/kg/apc/jmeter-plugins-mongodb/1.3/jmeter-plugins-mongodb-1.3.jar -P /apache-jmeter-5.4.1/lib/ext \
    && wget https://github.com/blkbsstt/jmeter-j

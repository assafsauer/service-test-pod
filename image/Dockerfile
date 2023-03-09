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
    openjdk-11-jdk \
    postgresql-client

# Install MongoDB testing tools
RUN apt-get install -y mongodb-clients \
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

# Copy tester.sh script
COPY tester.sh /app/
RUN chmod 777 /app/tester.sh

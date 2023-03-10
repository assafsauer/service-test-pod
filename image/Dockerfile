FROM ubuntu:latest

# Install necessary packages
RUN apt-get update && apt-get install -y \
    gnupg \
    wget \
    curl \
    openjdk-8-jdk \
    mongodb-clients \
    rabbitmq-server \
    postgresql-client \
    nodejs \
    npm

# Install YCSB
RUN wget https://github.com/brianfrankcooper/YCSB/releases/download/0.18.0/ycsb-0.18.0.tar.gz && \
    tar xvfz ycsb-0.18.0.tar.gz && \
    rm ycsb-0.18.0.tar.gz

# Install RabbitMQ perf test
RUN wget https://github.com/rabbitmq/rabbitmq-perf-test/releases/download/v2.11.0/rabbitmq-perf-test-2.11.0.tar.gz && \
    tar xvfz rabbitmq-perf-test-2.11.0.tar.gz && \
    rm rabbitmq-perf-test-2.11.0.tar.gz

# Copy the testplan.jmx file to the container
COPY testplan.jmx /testplan.jmx

# Copy the bash script to the container
COPY test.sh /test.sh

# Make the bash script executable
RUN chmod +x /test.sh

# Start the script when the container starts
CMD ["bash", "/test.sh"]

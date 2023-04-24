FROM openjdk:8-jdk

# Install JMeter
ENV JMETER_VERSION 5.4.1
ENV JMETER_HOME /opt/apache-jmeter-${JMETER_VERSION}
ENV JMETER_DOWNLOAD_URL https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-${JMETER_VERSION}.tgz
RUN curl -L --silent ${JMETER_DOWNLOAD_URL} > /tmp/apache-jmeter.tgz \
    && mkdir -p /opt \
    && tar -xzf /tmp/apache-jmeter.tgz -C /opt \
    && rm /tmp/apache-jmeter.tgz
ENV PATH $PATH:$JMETER_HOME/bin

# Install kubectl for checking service existence
RUN apt-get update && \
    apt-get install -y apt-transport-https gnupg2 curl && \
    curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
    echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list && \
    apt-get update && \
    apt-get install -y kubectl

# Create necessary directories
RUN mkdir -p /test/scripts /test/results /testplans

# Copy test script and JMeter configuration
COPY test.sh /test/scripts
RUN chmod +x /test/scripts/test.sh
COPY user.properties ${JMETER_HOME}/bin/user.properties

# Copy test plan files
COPY jmeter-plans /jmeter-plans

# Set working directory to the scripts directory
WORKDIR /test/scripts

# Set entrypoint to the test script
ENTRYPOINT ["/test/scripts/test.sh"]

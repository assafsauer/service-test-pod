FROM ubuntu:18.04

# Set environment variables
ENV JMETER_VERSION 5.4.1
ENV POSTGRES_VERSION 13

# Install required packages
RUN apt-get update && \
    apt-get install -y wget gnupg2 software-properties-common default-jre mongodb-clients curl unzip postgresql-client && \
    wget -qO - https://adoptopenjdk.jfrog.io/adoptopenjdk/api/gpg/key/public | apt-key add - && \
    add-apt-repository --yes https://adoptopenjdk.jfrog.io/adoptopenjdk/deb/ && \
    add-apt-repository --yes https://www.postgresql.org/media/keys/ACCC4CF8.asc && \
    echo "deb http://apt.postgresql.org/pub/repos/apt/ bionic-pgdg main" > /etc/apt/sources.list.d/pgdg.list && \
    apt-get update && \
    apt-get install -y adoptopenjdk-8-hotspot && \
    wget https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-${JMETER_VERSION}.tgz && \
    tar xzf apache-jmeter-${JMETER_VERSION}.tgz && \
    rm apache-jmeter-${JMETER_VERSION}.tgz && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Set JMeter home environment variable
ENV JMETER_HOME /apache-jmeter-${JMETER_VERSION}

# Add JMeter to the PATH
ENV PATH $JMETER_HOME/bin:$PATH

# Copy test plan
COPY testplan.jmx /testplan.jmx

# Start JMeter non-GUI mode and run the test plan
CMD jmeter -n -t /testplan.jmx -l /results.jtl && \
    curl -X POST -H "Content-Type: application/json" -d @/results.jtl https://my-api-endpoint/submit-results && \
    echo "Test finished and results submitted to API endpoint."

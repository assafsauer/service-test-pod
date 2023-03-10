FROM ubuntu:18.04

# Install required packages
RUN apt-get update && \
    apt-get install -y apt-transport-https gnupg wget && \
    wget -qO - https://www.mongodb.org/static/pgp/server-4.4.asc | apt-key add - && \
    echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/4.4 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-4.4.list && \
    apt-get update && \
    apt-get install -y mongodb-org-shell postgresql-12 rabbitmq-server curl && \
    wget https://github.com/brianfrankcooper/YCSB/releases/download/0.18.0/ycsb-0.18.0.tar.gz && \
    tar xvfz ycsb-0.18.0.tar.gz && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Copy testplan file
COPY testplan.jmx .

# Copy script file
COPY test.sh .

# Set execution permissions for script file
RUN chmod +x test.sh

# Expose JMeter port
EXPOSE 1099

# Start JMeter in server mode
CMD ["sh", "-c", "jmeter -s -Jserver.rmi.ssl.disable=true -Jserver.rmi.localport=1099 -Jserver_port=1099 -n"] 

FROM ubuntu:20.04

ENV JMETER_VERSION=5.4.1
ENV JMETER_HOME=/opt/apache-jmeter-${JMETER_VERSION}
ENV JMETER_BIN=${JMETER_HOME}/bin
ENV MONGODB_VERSION=4.4
ENV RABBITMQ_VERSION=3.9.8
ENV POSTGRES_VERSION=13

RUN apt-get update && apt-get install -y \
    curl \
    gnupg \
    openjdk-8-jdk \
    mongodb-clients \
    rabbitmq-server \
    postgresql-${POSTGRES_VERSION} \
    postgresql-client-${POSTGRES_VERSION} \
    && curl -L https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-${JMETER_VERSION}.tgz -o /tmp/apache-jmeter-${JMETER_VERSION}.tgz \
    && mkdir /opt \
    && tar -xzf /tmp/apache-jmeter-${JMETER_VERSION}.tgz -C /opt \
    && rm /tmp/apache-jmeter-${JMETER_VERSION}.tgz \
    && rabbitmq-plugins enable rabbitmq_management \
    && service rabbitmq-server start \
    && sed -i 's/md5/trust/g' /etc/postgresql/${POSTGRES_VERSION}/main/pg_hba.conf \
    && service postgresql start \
    && curl -L https://github.com/brianfrankcooper/YCSB/releases/download/0.18.0/ycsb-0.18.0.tar.gz -o /tmp/ycsb-0.18.0.tar.gz \
    && tar -xzf /tmp/ycsb-0.18.0.tar.gz -C /opt \
    && rm /tmp/ycsb-0.18.0.tar.gz \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY jmeter-mongo-test.jmx /test/

CMD ${JMETER_BIN}/jmeter -n -t /test/jmeter-mongo-test.jmx -l /test/result.jtl \
    && service rabbitmq-server stop \
    && service postgresql stop \
    && /opt/ycsb-0.18.0/bin/ycsb run mongodb -s -P /opt/ycsb-0.18.0/workloads/workloada \
    && /opt/ycsb-0.18.0/bin/ycsb run rabbitmq -s -P /opt/ycsb-0.18.0/workloads/workloada \
    && /opt/ycsb-0.18.0/bin/ycsb run jdbc -s -P /opt/ycsb-0.18.0/workloads/workloada -cp /usr/share/java/postgresql.jar -p db.driver=org.postgresql.Driver -p db.url=jdbc:postgresql://localhost:5432/ -p db.user=postgres -p db.passwd=password \
    && service rabbitmq-server start \
    && service postgresql start \
    && /usr/bin/touch /test/done.flag

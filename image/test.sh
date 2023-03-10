#!/bin/bash

# Check for service and endpoint URL arguments
if [[ -z $1 || -z $2 ]]; then
  echo "Usage: $0 [service] [endpoint_url]"
  exit 1
fi

# Assign arguments to variables
SERVICE=$1
ENDPOINT_URL=$2

# Clear variables
MONGO_POD=""
POSTGRES_POD=""
RABBITMQ_POD=""
NODEJS_POD=""
NGINX_POD=""

# Find PODs running MongoDB, PostgreSQL, RabbitMQ, Node.js and Nginx services
MONGO_POD=$(kubectl get pods -l app=mongodb -o=jsonpath='{.items[0].metadata.name}')
POSTGRES_POD=$(kubectl get pods -l app=postgres -o=jsonpath='{.items[0].metadata.name}')
RABBITMQ_POD=$(kubectl get pods -l app=rabbitmq -o=jsonpath='{.items[0].metadata.name}')
NODEJS_POD=$(kubectl get pods -l app=nodejs -o=jsonpath='{.items[0].metadata.name}')
NGINX_POD=$(kubectl get pods -l app=nginx -o=jsonpath='{.items[0].metadata.name}')

# Test the specified service with JMeter
case "$SERVICE" in
  "mongodb")
    echo "Testing MongoDB with JMeter..."
    jmeter -n -t /testplans/mongodb.jmx -Jhost=$ENDPOINT_URL
    ;;
  "postgres")
    echo "Testing PostgreSQL with JMeter..."
    jmeter -n -t /testplans/postgres.jmx -Jhost=$ENDPOINT_URL
    ;;
  "rabbitmq")
    echo "Testing RabbitMQ with JMeter..."
    jmeter -n -t /testplans/rabbitmq.jmx -Jhost=$ENDPOINT_URL
    ;;
  "nodejs")
    echo "Testing Node.js with JMeter..."
    jmeter -n -t /testplans/nodejs.jmx -Jhost=$ENDPOINT_URL
    ;;
  "nginx")
    echo "Testing Nginx with JMeter..."
    jmeter -n -t /testplans/nginx.jmx -Jhost=$ENDPOINT_URL
    ;;
  *)
    echo "Invalid service specified."
    exit 1
    ;;
esac

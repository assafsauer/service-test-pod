#!/bin/bash

# Check for service arguments
if [[ -z $1 ]]; then
  echo "Usage: $0 [service1] [service2] ..."
  exit 1
fi

# Function to test a specific service with JMeter
function test_service() {
  local service=$1
  local endpoint_url="${service}.default.svc.cluster.local"

  case "$service" in
    "mongodb")
      echo "Testing MongoDB with JMeter..."
      jmeter -n -t /testplans/mongodb.jmx -Jhost=$endpoint_url
      ;;
    "postgres")
      echo "Testing PostgreSQL with JMeter..."
      jmeter -n -t /testplans/postgres.jmx -Jhost=$endpoint_url
      ;;
    "rabbitmq")
      echo "Testing RabbitMQ with JMeter..."
      jmeter -n -t /testplans/rabbitmq.jmx -Jhost=$endpoint_url
      ;;
    "nodejs")
      echo "Testing Node.js with JMeter..."
      jmeter -n -t /testplans/nodejs.jmx -Jhost=$endpoint_url
      ;;
    "nginx")
      echo "Testing Nginx with JMeter..."
      jmeter -n -t /testplans/nginx.jmx -Jhost=$endpoint_url
      ;;
    *)
      echo "Invalid service specified: $service"
      ;;
  esac
}

# Loop through the provided service arguments and run tests for each of them
for service in "$@"
do
  test_service $service
done

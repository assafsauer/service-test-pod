#!/bin/bash

# Function to test a specific service with JMeter
function test_service() {
  local service=$1
  local endpoint_url="${service}.default.svc.cluster.local"

  case "$service" in
    "mongodb")
      echo "Testing MongoDB with JMeter..."
      jmeter -n -t /jmeter-plans/mongodb.jmx -Jhost=$endpoint_url
      ;;
    "postgres")
      echo "Testing PostgreSQL with JMeter..."
      jmeter -n -t /jmeter-plans/postgres.jmx -Jhost=$endpoint_url
      ;;
    "rabbitmq")
      echo "Testing RabbitMQ with JMeter..."
      jmeter -n -t /jmeter-plans/rabbitmq.jmx -Jhost=$endpoint_url
      ;;
    "nodejs")
      echo "Testing Node.js with JMeter..."
      jmeter -n -t /jmeter-plans/nodejs.jmx -Jhost=$endpoint_url
      ;;
    "nginx")
      echo "Testing Nginx with JMeter..."
      jmeter -n -t /jmeter-plans/nginx.jmx -Jhost=$endpoint_url
      ;;
    *)
      echo "Invalid service specified: $service"
      ;;
  esac
}

# Get the list of services
services=$(kubectl get services --no-headers -o custom-columns=":metadata.name")

# Loop through the discovered services and run tests for each of them
for service in $services
do
  test_service $service
done

# Sleep for a specified amount of time (e.g., 1 hour) before exiting
sleep 1h

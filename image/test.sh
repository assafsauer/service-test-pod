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

# List of specific services you want to test
services_to_test=("mongodb" "postgres" "rabbitmq" "nodejs" "nginx")

# Get the list of services in the namespace
existing_services=$(kubectl get services --no-headers -o custom-columns=":metadata.name")

# Loop through the list of specific services to test
for service_to_test in "${services_to_test[@]}"
do
  # Check if the service exists in the namespace
  if echo "$existing_services" | grep -q -w "$service_to_test"; then
    # Test the service
    test_service "$service_to_test"
  else
    echo "Service $service_to_test not found, skipping the test."
  fi
done

# Sleep for a specified amount of time (e.g., 1 hour) before exiting
sleep 1h

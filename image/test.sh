#!/bin/bash

# Check for service arguments
if [[ -z $1 ]]; then
  echo "Usage: $0 [service1] [service2] ..."
  exit 1
fi

# Function to check if a service exists
function service_exists() {
  local service=$1
  local svc_exists=$(kubectl get svc --namespace=default | grep -w "${service}" | wc -l)
  
  if [ $svc_exists -eq 1 ]; then
    return 0
  else
    return 1
  fi
}

# Function to test a specific service with JMeter
function test_service() {
  local service=$1
  local endpoint_url="${service}.default.svc.cluster.local"

  if service_exists $service; then
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
  else
    echo "Service $service not found, skipping the test."
  fi
}

# Loop through the provided service arguments and run tests for each of them
for service in "$@"
do
  test_service $service
done

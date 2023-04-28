
root@test-pod:/test/scripts# 
root@test-pod:/test/scripts# cat test2.sh 
#!/bin/bash

# Function to test a specific service with JMeter
function test_service() {
  local service=$1
  local namespace=$2
  local endpoint_url=""

  # Check if the service is of type LoadBalancer
  if kubectl get service $service -n $namespace -o jsonpath='{.spec.type}' | grep -q "LoadBalancer"; then
    # Get the external IP address of the LoadBalancer
    local lb_ip=$(kubectl get service $service -n $namespace -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
    endpoint_url="$lb_ip"
  else
    # Use the ClusterIP address of the service
    endpoint_url="${service}.${namespace}.svc.cluster.local"
  fi

  case "$service" in
    "mongodb")
      echo "Testing MongoDB with JMeter..."
      jmeter -n -t /jmeter-plans/mongodb.jmx -H $endpoint_url -P 27017 -l logfile.jtl
      ;;
    "postgres")
      echo "Testing PostgreSQL with JMeter..."
      jmeter -n -t /jmeter-plans/postgres.jmx -H $endpoint_url -P 5432 -l logfile.jtl
      ;;
    "rabbitmq")
      echo "Testing RabbitMQ with JMeter..."
      jmeter -n -t /jmeter-plans/rabbitmq.jmx -H $endpoint_url -P 5672 -l logfile.jtl
      ;;
    "nodejs")
      echo "Testing Node.js with JMeter..."
      local nodejs_port=$(kubectl get service $service -n $namespace -o jsonpath="{.spec.ports[0].nodePort}")
      jmeter -n -t /jmeter-plans/nodejs.jmx -H 34.70.140.119 -P 8080 -l logfile.jtl
      ;;
    "nginx-ingress-nginx-ingress-controller")
      echo "Testing Nginx with JMeter..."
      local nginx_port=$(kubectl get service $service -n $namespace -o jsonpath="{.spec.ports[0].nodePort}")
      jmeter -n -t /jmeter-plans/nginx.jmx -H $endpoint_url -P $nginx_port -l logfile.jtl
      ;;
    *)
      echo "Invalid service specified: $service"
      ;;
  esac
}

# List of specific services you want to test
services_to_test=("mongodb" "postgres" "rabbitmq" "nodejs" "nginx-ingress-nginx-ingress-controller")

# Get the list of namespaces
namespaces=$(kubectl get namespaces --no-headers -o custom-columns=":metadata.name")

# Loop through the list of namespaces
for namespace in $namespaces
do
  echo "Testing services in namespace: $namespace"

  # Get the list of services in the namespace
  existing_services=$(kubectl get services -n $namespace --no-headers -o custom-columns=":metadata.name")

  # Loop through the list of specific services to test
  for service_to_test in "${services_to_test[@]}"
  do
    # Check if the service exists in the namespace
    if echo "$existing_services" | grep -q -w "$service_to_test"; then
      # Test the service
      test_service "$service_to_test" "$namespace"
    else
      echo "Service $service_to_test not found in namespace $namespace, skipping the test."
    fi
  done
done

# Sleep for a specified amount of time (e.g., 1 hour) before exiting
sleep 1h


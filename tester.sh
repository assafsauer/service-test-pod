#!/bin/bash

# Define the namespace and labels for each service
NAMESPACE="my-namespace"
MONGODB_LABELS="app=mongodb"
RABBITMQ_LABELS="app=rabbitmq"
NGINX_LABELS="app=nginx"
SPRING_LABELS="app=spring"
NODEJS_LABELS="app=nodejs"

# Define the test command and report path for each service
MONGODB_TEST_CMD="mongo --host my-mongodb-service --eval 'printjson(db.stats())'"
MONGODB_REPORT_PATH="/reports/mongodb-report.txt"
RABBITMQ_TEST_CMD="python3 rabbitmq-perf-test-2.11.0/bin/runjava com.rabbitmq.perf.PerfTest --uri amqp://my-rabbitmq-service --queue q1 --producers 2 --consumers 4 --time 30 --vsize 1000"
RABBITMQ_REPORT_PATH="/reports/rabbitmq-report.txt"
NGINX_TEST_CMD="ab -n 10000 -c 100 -H 'Accept-Encoding: gzip, deflate' http://my-nginx-service/"
NGINX_REPORT_PATH="/reports/nginx-report.txt"
SPRING_TEST_CMD="locust -f my-spring-test.py --host=http://my-spring-service:8080 --csv /reports/spring-report"
SPRING_REPORT_PATH="/reports/spring-report.csv"
NODEJS_TEST_CMD="loadtest http://my-nodejs-service:8080 --rps 100 --duration 30s --timeout 5s --concurrency 10"
NODEJS_REPORT_PATH="/reports/nodejs-report.txt"

# Run the test and save the report for each service
kubectl get pods -n $NAMESPACE -l $MONGODB_LABELS -o jsonpath='{.items[*].metadata.name}' | tr ' ' '\n' | while read pod; do
  kubectl exec -n $NAMESPACE $pod -- /bin/bash -c "$MONGODB_TEST_CMD" > "$MONGODB_REPORT_PATH"
done

kubectl get pods -n $NAMESPACE -l $RABBITMQ_LABELS -o jsonpath='{.items[*].metadata.name}' | tr ' ' '\n' | while read pod; do
  kubectl exec -n $NAMESPACE $pod -- /bin/bash -c "$RABBITMQ_TEST_CMD" > "$RABBITMQ_REPORT_PATH"
done

kubectl get pods -n $NAMESPACE -l $NGINX_LABELS -o jsonpath='{.items[*].metadata.name}' | tr ' ' '\n' | while read pod; do
  kubectl exec -n $NAMESPACE $pod -- /bin/bash -c "$NGINX_TEST_CMD" > "$NGINX_REPORT_PATH"
done

kubectl get pods -n $NAMESPACE -l $SPRING_LABELS -o jsonpath='{.items[*].metadata.name}' | tr ' ' '\n' | while read pod; do
  kubectl exec -n $NAMESPACE $pod -- /bin/bash -c "$SPRING_TEST_CMD"
done

kubectl get pods -n $NAMESPACE -l $NODEJS_LABELS -o jsonpath='{.items[*].metadata.name}' | tr ' ' '\n' | while read pod; do
  kubectl exec -n $NAMESPACE $pod -- /bin/bash -c "$NODEJS_TEST_CMD" > "$NODEJS_REPORT_PATH"
done

# Generate a report for each service
mongo --quiet <(echo "db.stats()") > "$MONGODB_REPORT_PATH.html"
python3 rabbitmq-perf-test-2.11

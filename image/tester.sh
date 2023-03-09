#!/bin/bash

# Clear variables
MONGO_POD=""
RABBITMQ_POD=""
POSTGRES_POD=""
NODEJS_POD=""

# Find PODs running MongoDB, RabbitMQ, PostgreSQL and Node.js services
MONGO_POD=$(kubectl get pods -l app=mongodb -o=jsonpath='{.items[0].metadata.name}')
RABBITMQ_POD=$(kubectl get pods -l app=rabbitmq -o=jsonpath='{.items[0].metadata.name}')
POSTGRES_POD=$(kubectl get pods -l app=postgres -o=jsonpath='{.items[0].metadata.name}')
NODEJS_POD=$(kubectl get pods -l app=nodejs -o=jsonpath='{.items[0].metadata.name}')

# Test MongoDB with YCSB
echo "Testing MongoDB with YCSB..."
kubectl exec $MONGO_POD -- bash -c "cd /ycsb-0.18.0/ && bin/ycsb load mongodb -s -P workloads/workloada"

# Test RabbitMQ with rabbitmq-perf-test
echo "Testing RabbitMQ with rabbitmq-perf-test..."
kubectl exec $RABBITMQ_POD -- bash -c "cd /rabbitmq-perf-test-2.11.0/ && ./bin/runjava com.rabbitmq.perf.PerfTest --exchange perfTestEx --queue perfTestQ --flag persistent --size 1024 --count 10000"

# Test PostgreSQL with pgbench
echo "Testing PostgreSQL with pgbench..."
kubectl exec $POSTGRES_POD -- bash -c "pgbench -i -U postgres -d postgres"
kubectl exec $POSTGRES_POD -- bash -c "pgbench -c 10 -T 60 -U postgres -d postgres"

# Test Node.js with Artillery
echo "Testing Node.js with Artillery..."
kubectl exec $NODEJS_POD -- bash -c "cd /app && artillery quick --duration 60 --rate 10 http://localhost:3000"

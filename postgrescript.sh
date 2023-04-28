#!/bin/bash

LABEL_SELECTOR="app=postgres"
NAMESPACE="kcloak"

POD_NAME=$(kubectl get pods -n $NAMESPACE -l $LABEL_SELECTOR -o jsonpath='{.items[0].metadata.name}')

# Check if the pod is ready
while [[ $(kubectl get pods -n $NAMESPACE $POD_NAME -o 'jsonpath={..status.conditions[?(@.type=="Ready")].status}') != "True" ]]; do
    echo "Waiting for pod $POD_NAME to be ready..."
    sleep 5
done

kubectl delete -f keycloak.yaml
export PGPASSWORD=p-password
psql -h 192.168.49.7 -p 5432 -d postgres -U p-user -c "DROP DATABASE keycloak"
psql -h 192.168.49.7 -p 5432 -d postgres -U p-user -c "CREATE DATABASE keycloak"
psql -h 192.168.49.7 -p 5432 -d keycloak -U p-user < ./sqlcloak.db
kubectl apply -f keycloak.yaml

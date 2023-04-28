#!/bin/bash

LABEL_SELECTOR="app=postgres"
NAMESPACE="kcloak"

POD_NAME=$(kubectl get pods -n $NAMESPACE -l $LABEL_SELECTOR -o jsonpath='{.items[0].metadata.name}')
message="Waiting for pod $POD_NAME to be ready"

echo "[6/6] Updating Postgres DB..."

# Check if the pod is ready
while [[ $(kubectl get pods -n $NAMESPACE $POD_NAME -o 'jsonpath={..status.conditions[?(@.type=="Ready")].status}') != "True" ]]; do
    echo "$message".
    message="$message."
    sleep 5
done
echo "Pod $POD_NAME is now ready, commencing..."
kubectl delete -f keycloak.yaml
export PGPASSWORD=p-password
sleep 3
psql -h 192.168.49.7 -p 5432 -d postgres -U p-user -c "DROP DATABASE keycloak"
psql -h 192.168.49.7 -p 5432 -d postgres -U p-user -c "CREATE DATABASE keycloak"
echo "Postgres db aligned, $(psql -h 192.168.49.7 -p 5432 -d keycloak -U p-user < ./sqlcloak.db | wc -l) lines of output omitted"
#psql -h 192.168.49.7 -p 5432 -d keycloak -U p-user < ./sqlcloak.db
kubectl apply -f keycloak.yaml

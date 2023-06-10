#!/bin/bash
if [ $# -ne 1 ]; then
  echo "Usage: $0 <Multicloud Flag>"
  exit 1
fi

if [ $1 -eq 1 ]; then
    POSTGRESIP=192.168.58.7
    CONTEXT=cube2
else
    POSTGRESIP=192.168.49.6
    CONTEXT=cube1
fi


NAMESPACE=authzone

LABEL_SELECTOR="app=postgres"

POD_NAME=$(kubectl get pods -n $NAMESPACE -l $LABEL_SELECTOR --context=$CONTEXT -o jsonpath='{.items[0].metadata.name}')
message="Waiting for pod $POD_NAME to be ready"

echo "[6/6] Updating Postgres DB..."

# Check if the pod is ready
while [[ $(kubectl get pods -n $NAMESPACE $POD_NAME --context=$CONTEXT -o 'jsonpath={..status.conditions[?(@.type=="Ready")].status}') != "True" ]]; do
    echo "$message".
    message="$message."
    sleep 10
done
echo "Pod $POD_NAME is now ready, commencing..."
#kubectl delete -f res/deplo/keycloak.yaml --context=$CONTEXT
export PGPASSWORD=p-password
sleep 3
psql -h $POSTGRESIP -p 5432 -d postgres -U p-user -c "DROP DATABASE keycloak"
psql -h $POSTGRESIP -p 5432 -d postgres -U p-user -c "CREATE DATABASE keycloak"
echo "Postgres db aligned, $(psql -h $POSTGRESIP -p 5432 -d keycloak -U p-user < res/sqlcloak.db | wc -l) lines of output omitted"
#psql -h 192.168.49.8 -p 5432 -d keycloak -U p-user < ./sqlcloak.db

kubectl apply -f res/deplo/keycloak.yaml --context=$CONTEXT -n $NAMESPACE

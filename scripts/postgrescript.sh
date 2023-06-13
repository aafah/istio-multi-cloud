
POSTGRESIP=192.168.58.7
CONTEXT=cube2
NAMESPACE=authzone
LABEL_SELECTOR="app=postgres"
export PGPASSWORD=p-password

#Find Postgres Pod
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

#Updating Postgres
psql -h $POSTGRESIP -p 5432 -d postgres -U p-user -c "DROP DATABASE keycloak"
psql -h $POSTGRESIP -p 5432 -d postgres -U p-user -c "CREATE DATABASE keycloak"
echo "Postgres db aligned, $(psql -h $POSTGRESIP -p 5432 -d keycloak -U p-user < res/sqlcloak.db | wc -l) lines of output omitted"

echo "Setting up authzone..."
#Deploy Keycloak
kubectl apply -f res/deplo/keycloak.yaml --context=$CONTEXT -n $NAMESPACE -l app=keycloak
kubectl apply -f res/deplo/keycloak.yaml --context=$CONTEXT -n $NAMESPACE -l svc=keycloak

# Wait until the pod is ready
KC_NAME=$(kubectl get pods -n $NAMESPACE -l app=keycloak --context=$CONTEXT -o jsonpath='{.items[0].metadata.name}')
while [[ $(kubectl get pods -n $NAMESPACE $KC_NAME --context=$CONTEXT -o 'jsonpath={..status.conditions[?(@.type=="Ready")].status}') != "True" ]]; do
    sleep 5
done

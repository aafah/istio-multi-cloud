kubectl delete -f keycloak.yaml
export PGPASSWORD=p-password
port_number=$1
psql -h 192.168.49.2 -p $port_number -d postgres -U p-user -c "DROP DATABASE keycloak"
psql -h 192.168.49.2 -p $port_number -d postgres -U p-user -c "CREATE DATABASE keycloak"
psql -h 192.168.49.2 -p $port_number -d keycloak -U p-user < ./sqlcloak.db
kubectl apply -f keycloak.yaml

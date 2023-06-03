echo "[5/6] Building cluster..."


kubectl apply -f istioconf.yaml --context='cube1'
kubectl apply -f jwtrules.yaml --context='cube1'
kubectl apply -f policy.yaml --context='cube1'

kubectl apply -f microtwo.yaml --context='cube1'
kubectl apply -f microdb.yaml --context='cube1'
kubectl apply -f microusr.yaml --context='cube1'
kubectl apply -f react.yaml --context='cube1'
kubectl apply -f probe.yaml --context='cube1'
kubectl apply -f igate.yaml --context='cube1'
kubectl apply -f keycloak.yaml --context='cube1'
kubectl apply -f postgres.yaml --context='cube1'
kubectl apply -f redis.yaml --context='cube1'
kubectl apply -f oauth2.yaml --context='cube1'

./postgrescript.sh

#kubectl delete -f keycloak.yaml
#psql -h 127.0.0.1 -p 42223 -U p-user postgres
#DELETE DATABASE keycloak;
#CREATE DATABASE keycloak;
#\q
#psql -h 127.0.0.1 -p 42223 -d keycloak -U p-user < tesi/first/sqlcloak.db
#
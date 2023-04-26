kubectl apply -f microtwo.yaml
kubectl apply -f microdb.yaml
kubectl apply -f microusr.yaml
kubectl apply -f react.yaml
kubectl apply -f probe.yaml
kubectl apply -f igate.yaml
kubectl apply -f istioconf.yaml
kubectl apply -f policy.yaml
kubectl apply -f postgres.yaml
kubectl apply -f keycloak.yaml
kubectl apply -f redis.yaml
kubectl apply -f oauth2.yaml

#kubectl delete -f keycloak.yaml
#psql -h 127.0.0.1 -p 42223 -U p-user postgres
#DELETE DATABASE keycloak;
#CREATE DATABASE keycloak;
#\q
#psql -h 127.0.0.1 -p 42223 -d keycloak -U p-user < tesi/first/sqlcloak.db
#
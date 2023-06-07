echo "[5/6] Building cluster..."


kubectl apply -f res/istio/istioconf.yaml --context='cube1'
kubectl apply -f res/istio/jwtrules.yaml --context='cube1'
kubectl apply -f res/istio/policy.yaml --context='cube1'

kubectl apply -f res/deplo/microtwo.yaml --context='cube1'
kubectl apply -f res/deplo/microdb.yaml --context='cube1'
kubectl apply -f res/deplo/microusr.yaml --context='cube1'
kubectl apply -f res/deplo/react.yaml --context='cube1'
kubectl apply -f res/deplo/probe.yaml --context='cube1'
kubectl apply -f res/istio/igate.yaml --context='cube1'
kubectl apply -f res/deplo/keycloak.yaml --context='cube1'
kubectl apply -f res/deplo/postgres.yaml --context='cube1'
kubectl apply -f res/deplo/redis.yaml --context='cube1'
kubectl apply -f res/deplo/oauth2.yaml --context='cube1'

scripts/postgrescript.sh

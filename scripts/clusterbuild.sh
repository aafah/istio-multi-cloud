if [ $# -ne 1 ]; then
  echo "Usage: $0 <Multicluster flag 0/1>"
  exit 1
fi

echo "[5/6] Building cluster..."

kubectl apply -f res/istio/istioconf.yaml --context='cube1'
kubectl apply -f res/istio/jwtrules.yaml --context='cube1'
kubectl apply -f res/istio/policy.yaml --context='cube1'
kubectl apply -f res/istio/igate.yaml --context='cube1'

#kubectl apply -f res/deplo/probe.yaml --context='cube1'

kubectl apply -f res/deplo/microtwo.yaml --context='cube1' -n appspace
kubectl apply -f res/deplo/microdb.yaml --context='cube1' -n appspace
kubectl apply -f res/deplo/react.yaml --context='cube1' -n appspace


if [ $1 -eq 1 ]; then
  kubectl apply -f res/istio/policy2.yaml --context='cube2'

  kubectl apply -f res/deplo/microusr.yaml --context='cube2' -n appspace

  kubectl apply -f res/deplo/postgres.yaml -n authzone --context='cube2' 
  kubectl apply -f res/deplo/redis.yaml -n default --context='cube2'
  kubectl apply -f res/deplo/oauth2.yaml -n authzone --context='cube2'
    
  kubectl apply -f res/deplo/keycloak.yaml --context='cube1' -n authzone -l svc=keycloak
  kubectl apply -f res/deplo/oauth2.yaml -n authzone --context='cube1' -l svc=oauth
  kubectl apply -f res/deplo/microusr.yaml --context='cube1' -n appspace -l svc=api-usr
  kubectl apply -f res/deplo/microtwo.yaml --context='cube2' -n appspace -l svc=api-two
  kubectl apply -f res/deplo/microdb.yaml --context='cube2' -n appspace -l svc=api-db
  kubectl apply -f res/deplo/react.yaml --context='cube2' -n appspace -l svc=react
else
  kubectl apply -f res/deplo/postgres.yaml -n authzone --context='cube1' 
  kubectl apply -f res/deplo/redis.yaml -n default --context='cube1'
  kubectl apply -f res/deplo/oauth2.yaml -n authzone --context='cube1'   

fi

scripts/postgrescript.sh $1
sleep 5





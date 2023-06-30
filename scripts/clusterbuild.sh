#
CONTEXT=cube2

echo "[5/6] Building cluster..."

#Build Application components
kubectl apply -f res/deplo/react.yaml --context='cube1' -n appspace
kubectl apply -f res/deplo/microusr.yaml --context='cube1' -n appspace
kubectl apply -f res/deplo/microtwo.yaml --context='cube1' -n appspace
kubectl apply -f res/deplo/microdb.yaml --context=$CONTEXT -n appspace

#Deploy Auth-Support Dbs
kubectl apply -f res/deplo/postgres.yaml -n authzone --context=$CONTEXT 
kubectl apply -f res/deplo/redis.yaml -n default --context=$CONTEXT

#Mirror Services Across clusters
kubectl apply -f res/deplo/microusr.yaml --context=$CONTEXT -n appspace -l svc=api-usr
kubectl apply -f res/deplo/microtwo.yaml --context=$CONTEXT -n appspace -l svc=api-two
kubectl apply -f res/deplo/react.yaml --context=$CONTEXT -n appspace -l svc=react
kubectl apply -f res/deplo/microdb.yaml --context='cube1' -n appspace -l svc=api-db

#Align Postgres
scripts/postgrescript.sh

#Build Oauth-Proxy
kubectl apply -f res/deplo/oauth2.yaml -n authzone --context=$CONTEXT

#Mirror Auth Services
kubectl apply -f res/deplo/keycloak.yaml --context='cube1' -n authzone -l svc=keycloak2
kubectl apply -f res/deplo/oauth2.yaml -n authzone --context='cube1' -l svc=oauth

# Wait until oauth is deployed
echo "Waiting for deployments ready status..."
OAUTH_NAME=$(kubectl get pods -n authzone -l app=oauth-proxy --context=$CONTEXT -o jsonpath='{.items[0].metadata.name}')
while [[ $(kubectl get pods -n authzone $OAUTH_NAME --context=$CONTEXT -o 'jsonpath={..status.conditions[?(@.type=="Ready")].status}') != "True" ]]; do
    sleep 3
done

#Istio resources on cluster1
kubectl apply -f res/istio/istioconf.yaml --context='cube1'
kubectl apply -f res/istio/policy.yaml --context='cube1'
kubectl apply -f res/istio/igate.yaml --context='cube1'

#Istio resources
kubectl apply -f res/istio/jwtrules.yaml --context=$CONTEXT
kubectl apply -f res/istio/appspace2.yaml --context=$CONTEXT
kubectl apply -f res/istio/policy2.yaml --context=$CONTEXT





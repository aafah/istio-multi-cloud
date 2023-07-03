echo "[3/3] Setting up for multicluster mesh..."
scripts/istio-scripts/gen-eastwest-gateway.sh --mesh mesh1 --cluster cluster1 --network network1 | \
istioctl install --context='cube1' -y -f -

kubectl apply -n istio-system --context='cube1' -f scripts/istio-scripts/expose-services.yaml
echo "Services exposed"

DISCOVERY_ADDRESS=$(kubectl -n istio-system --context='cube1' get svc istio-eastwestgateway -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
echo "Istio Eastwest Gateway listening on $DISCOVERY_ADDRESS."
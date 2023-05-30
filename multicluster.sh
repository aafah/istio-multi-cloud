echo "[7/6] Setting up for multicluster mesh..."
istio-script/gen-eastwest-gateway.sh --mesh mesh1 --cluster cluster1 --network network1 | istioctl install -y -f -

#kubectl apply -n istio-system -f istio-script/expose-istiod.yaml
#echo "Istiod exposed"
kubectl apply -n istio-system -f istio-script/expose-services.yaml
echo "Services exposed"

DISCOVERY_ADDRESS=$(kubectl -n istio-system get svc istio-eastwestgateway -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
echo "Istio Eastwest Gateway listening on $DISCOVERY_ADDRESS."
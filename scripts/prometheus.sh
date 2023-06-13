# Configure Prometheus federation
kubectl patch svc prometheus -n istio-system --context cube2 -p "{\"spec\": {\"type\": \"LoadBalancer\"}}"

WEST_PROMETHEUS_ADDRESS=$(kubectl --context='cube2' -n istio-system get svc prometheus -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
sed -i "s/WEST_PROMETHEUS_ADDRESS/$WEST_PROMETHEUS_ADDRESS/g" res/prome.yaml
kubectl apply -f res/prome.yaml -n istio-system --context cube1
sed -i "s/$WEST_PROMETHEUS_ADDRESS/WEST_PROMETHEUS_ADDRESS/g" res/prome.yaml

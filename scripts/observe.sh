#kubectl apply -f ../istio-1.17.2/samples/addons/prometheus.yaml --context=cube1
kubectl apply -f ../istio-1.17.2/samples/addons/prometheus.yaml --context=cube2

#scripts/prometheus.sh

kubectl apply -f ../istio-1.17.2/samples/addons/kiali.yaml --context=cube2
#kubectl apply -f ../istio-1.17.2/samples/addons/kiali.yaml --context=cube1

sleep 10
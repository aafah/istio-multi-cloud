kubectl create namespace sample
kubectl label namespace sample istio-injection=enabled
kubectl apply -f helloworld.yaml -l service=helloworld -n sample
kubectl apply -f helloworld.yaml -l version=v1 -n sample
kubectl apply -f sleep.yaml -n sample
#kubectl exec -n sample -c sleep "$(kubectl get pod -n sample -l app=sleep -o jsonpath='{.items[0].metadata.name}')" -- curl -sS helloworld.sample:5000/hello
#for i in $(seq 15); do kubectl -n sample exec sleep-bc9998558-gw8w8 -c sleep -- curl -s helloworld:5000/hello; done

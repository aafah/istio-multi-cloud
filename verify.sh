kubectl create --context="cube1" namespace sample
kubectl create --context="cube2" namespace sample
kubectl label --context="cube1" namespace sample \
    istio-injection=enabled
kubectl label --context="cube2" namespace sample \
    istio-injection=enabled
kubectl apply --context="cube1" \
    -f sample/helloworld.yaml \
    -l service=helloworld -n sample
kubectl apply --context="cube2" \
    -f sample/helloworld.yaml \
    -l service=helloworld -n sample
kubectl apply --context="cube1" \
    -f sample/helloworld.yaml \
    -l version=v1 -n sample
kubectl apply --context="cube2" \
    -f sample/helloworld.yaml \
    -l version=v2 -n sample

kubectl apply --context="cube1" \
    -f sample/sleep.yaml -n sample
kubectl apply --context="cube2" \
    -f sample/sleep.yaml -n sample


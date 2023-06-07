echo " "
echo "---------------------------------"
echo "Testing multicluster connectivity"
echo "---------------------------------"
echo " "

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

echo "Test Deployment complete, testing connectivity..."

LABEL_SELECTED="app=sleep"
POD1=$(kubectl get pods -n sample -l "app=sleep" --context='cube1' -o jsonpath='{.items[0].metadata.name}')
POD2=$(kubectl get pods -n sample -l "app=sleep" --context='cube2' -o jsonpath='{.items[0].metadata.name}')

PODH1=$(kubectl get pods -n sample -l "app=helloworld" --context='cube1' -o jsonpath='{.items[0].metadata.name}')
PODH2=$(kubectl get pods -n sample -l "app=helloworld" --context='cube2' -o jsonpath='{.items[0].metadata.name}')

echo "Waiting for receiving services to be up..."
while [[ $(kubectl get pods -n sample $PODH1 --context='cube1' -o 'jsonpath={..status.conditions[?(@.type=="Ready")].status}') != "True" ]]; do
    sleep 5
done
while [[ $(kubectl get pods -n sample $PODH2 --context='cube2' -o 'jsonpath={..status.conditions[?(@.type=="Ready")].status}') != "True" ]]; do
    sleep 5
done

echo " "
echo "-----------------------------------"
echo "sleep (cube1) -> helloworld service"
echo "-----------------------------------"

message="Waiting for pod $POD1 to be ready"
while [[ $(kubectl get pods -n sample $POD1 --context='cube1' -o 'jsonpath={..status.conditions[?(@.type=="Ready")].status}') != "True" ]]; do
    echo "$message".
    message="$message."
    sleep 5
done
echo "Testing loadbalancing capabilities..."
for i in $(seq 10); do kubectl --context='cube1' -n sample exec $POD1 -c sleep -- curl -s helloworld:5000/hello; done

echo " "
echo "-----------------------------------"
echo "sleep (cube2) -> helloworld service"
echo "-----------------------------------"
message="Waiting for pod $POD2 to be ready"
while [[ $(kubectl get pods -n sample $POD2 --context='cube2' -o 'jsonpath={..status.conditions[?(@.type=="Ready")].status}') != "True" ]]; do
    echo "$message".
    message="$message."
    sleep 5
done
echo "Testing loadbalancing capabilities..."
for i in $(seq 10); do kubectl --context='cube2' -n sample exec $POD2 -c sleep -- curl -s helloworld:5000/hello; done

echo " "

echo "----------------------------------"
echo "          Testing done"
echo "----------------------------------"
echo " "
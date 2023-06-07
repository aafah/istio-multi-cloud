echo " "
echo "-------------------------"
echo "CLUSTER CUBE2"
echo "-------------------------"
echo " "

echo "[1/3] Starting second minikube cluster cube2..."
minikube start \
    --service-cluster-ip-range='10.112.0.0/12' \
    --apiserver-ips 192.168.58.2 \
    --cpus 2 --memory 6000 \
    --profile cube2 

kubectl create namespace appspace --context='cube2'
minikube addons enable metallb --profile='cube2'
kubectl apply -f res/metal2.yaml --context='cube2'

echo "[2/3] Configuring Istio for 2P installation..."

kubectl create namespace istio-system --context='cube2'
kubectl --context='cube2' create secret generic cacerts -n istio-system \
      --from-file=cert/cluster2/ca-cert.pem \
      --from-file=cert/cluster2/ca-key.pem \
      --from-file=cert/cluster2/root-cert.pem \
      --from-file=cert/cluster2/cert-chain.pem

#kubectl annotate namespace istio-system topology.istio.io/controlPlaneClusters=cluster1 --context='cube2'
kubectl --context='cube2' label namespace istio-system topology.istio.io/network=network2

# Install Istio
istioctl install --context='cube2' -y -f res/istio/cluster2.yaml

#Multicluster resources
echo "Creating EW Gate..."
scripts/istio-scripts/gen-eastwest-gateway.sh --mesh mesh1 --cluster cluster2 --network network2 | \
istioctl install --context='cube2' -y -f -

kubectl apply -n istio-system --context='cube2' -f scripts/istio-scripts/expose-services.yaml
echo "Services exposed"

# Remote secrets to allow cross API server observation
echo "Exchanging Remote Secret"
istioctl x create-remote-secret \
  --context='cube2' \
  --name=cluster2 | \
  kubectl apply -f - --context='cube1'

istioctl x create-remote-secret \
  --context='cube1' \
  --name=cluster1 | \
  kubectl apply -f - --context='cube2'

echo "[3/3] Second Primary Cluster now running"
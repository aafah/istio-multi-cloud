# Check if an IP address was provided as an argument
if [ $# -ne 1 ]; then
  echo "Usage: $0 <IP address>"
  exit 1
fi

# Set the IP address
MY_SERVICE_IP=$1

SECONDS=0
echo "[1/6] Starting minikube..."
minikube start --mount-string=/home/admar/first:/host --mount \
--cpus 4 --memory 10240 \
--apiserver-ips $MY_SERVICE_IP 

echo "Setting up certificates..."
kubectl create namespace istio-system
cd cert
rm -r *
make -f ../../istio-1.17.2/tools/certs/Makefile.selfsigned.mk root-ca
make -f ../../istio-1.17.2/tools/certs/Makefile.selfsigned.mk cluster1-cacerts
cd ..
kubectl create secret generic cacerts -n istio-system \
      --from-file=cert/cluster1/ca-cert.pem \
      --from-file=cert/cluster1/ca-key.pem \
      --from-file=cert/cluster1/root-cert.pem \
      --from-file=cert/cluster1/cert-chain.pem

echo "[2/6] Configuring the mesh..."

#--set values.pilot.env.EXTERNAL_ISTIOD=true \

istioctl install -y \
  --set profile=demo \
  --set values.global.proxy.privileged=true \
  --set meshConfig.outboundTrafficPolicy.mode=REGISTRY_ONLY \
  -f operator.yaml

kubectl label namespace istio-system topology.istio.io/network=network1
kubectl create namespace appspace
kubectl create namespace kcloak
kubectl label namespace appspace istio-injection=enabled
kubectl apply -f pvs.yaml
# kubectl apply -f istio-configmap.yaml --force --overwrite

minikube addons enable metallb 
kubectl apply -f metal.yaml

./dockerbuildall.sh
./dynfix.sh $MY_SERVICE_IP
./clusterbuild.sh

echo "Cluster now up and running, have fun!"
./multicluster.sh

./remote.sh $MY_SERVICE_IP
ELAPSED="Elapsed: $(($SECONDS / 3600))hrs $((($SECONDS / 60) % 60))min $(($SECONDS % 60))sec"
echo $ELAPSED
echo " "
echo " "
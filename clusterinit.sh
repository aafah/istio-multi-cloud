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
  --service-cluster-ip-range='10.96.0.0/12' \
  --apiserver-ips 192.168.49.2 \
  --cpus 2 --memory 7000 \
  --profile cube1

#--apiserver-ips $MY_SERVICE_IP\

#: '
echo "Setting up certificates..."
kubectl create namespace istio-system --context='cube1'
cd cert
rm -r *
make -f ../../istio-1.17.2/tools/certs/Makefile.selfsigned.mk root-ca
make -f ../../istio-1.17.2/tools/certs/Makefile.selfsigned.mk cluster1-cacerts
make -f ../../istio-1.17.2/tools/certs/Makefile.selfsigned.mk cluster2-cacerts

cd ..
kubectl --context='cube1' create secret generic cacerts -n istio-system \
      --from-file=cert/cluster1/ca-cert.pem \
      --from-file=cert/cluster1/ca-key.pem \
      --from-file=cert/cluster1/root-cert.pem \
      --from-file=cert/cluster1/cert-chain.pem
#'

echo "[2/6] Configuring the mesh..."

minikube addons enable metallb --profile='cube1'
kubectl apply -f metal.yaml --context='cube1'

kubectl label namespace istio-system topology.istio.io/network=network1 --context='cube1'

istioctl install -y \
  --set profile=demo \
  --set values.global.proxy.privileged=true \
  --set meshConfig.outboundTrafficPolicy.mode=REGISTRY_ONLY \
  --set values.pilot.env.EXTERNAL_ISTIOD=true \
  --context='cube1' \
  -f operator.yaml 


#kubectl create namespace appspace --context='cube1'
#kubectl create namespace kcloak --context='cube1'
#kubectl label namespace appspace istio-injection=enabled --context='cube1'
#kubectl apply -f pvs.yaml --context='cube1'

#./dockerbuildall.sh
#./dynfix.sh $MY_SERVICE_IP
#./clusterbuild.sh

echo "Cluster now up and running, have fun!"
./multicluster.sh

#Start up and configure Istio on Remote Cluster
./remotecluster.sh

# ./remote.sh $MY_SERVICE_IP
ELAPSED="Elapsed: $(($SECONDS / 3600))hrs $((($SECONDS / 60) % 60))min $(($SECONDS % 60))sec"
echo $ELAPSED
echo " "
echo " "
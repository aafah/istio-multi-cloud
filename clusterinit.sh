# Check the number of arguments
if [[ $# -lt 1 || $# -gt 4 ]]; then
  echo "Usage: $0 <IP address> [flags]"
  exit 1
fi

# Set the IP address
MY_SERVICE_IP=$1
SECONDS=0

# Create Networks
scripts/networksetup.sh

echo " "
echo "------------------------"
echo "CERTIFICATE AND CA SETUP"
echo "------------------------"
echo " "

# Creates certificates using a custom CA instead of Istio's
# Necessary to have both cluster's certificates belong to the same root
echo "Setting up certificates..."
cd cert
rm -r *
make -f ../../istio-1.17.2/tools/certs/Makefile.selfsigned.mk root-ca
make -f ../../istio-1.17.2/tools/certs/Makefile.selfsigned.mk cluster1-cacerts
make -f ../../istio-1.17.2/tools/certs/Makefile.selfsigned.mk cluster2-cacerts
cd ..

echo " "
echo "-------------------------"
echo "CLUSTER CUBE1"
echo "-------------------------"
echo " "

#Starts up minikube
echo "[1/3] Starting minikube..."
minikube start --mount-string=/home/admar/first/app-code:/host --mount \
  --service-cluster-ip-range='10.96.0.0/12' \
  --apiserver-ips 192.168.49.2 \
  --cpus 4 --memory 6000 \
  --profile cube1

#--apiserver-ips $MY_SERVICE_IP\

kubectl create namespace istio-system --context='cube1'
kubectl --context='cube1' create secret generic cacerts -n istio-system \
      --from-file=cert/cluster1/ca-cert.pem \
      --from-file=cert/cluster1/ca-key.pem \
      --from-file=cert/cluster1/root-cert.pem \
      --from-file=cert/cluster1/cert-chain.pem

#MetalLB & Istio Installation
echo "[2/3] Configuring the mesh..."
minikube addons enable metallb --profile='cube1'
kubectl apply -f res/metal.yaml --context='cube1'


scripts/dynfix.sh $MY_SERVICE_IP


kubectl label namespace istio-system topology.istio.io/network=network1 --context='cube1'
istioctl install -y \
  --set profile=demo \
  --set values.global.proxy.privileged=true \
  --set meshConfig.outboundTrafficPolicy.mode=REGISTRY_ONLY \
  --context='cube1' \
  -f res/istio/operator.yaml 

ELAPSED="Infrastructure configured! Elapsed: $(($SECONDS / 3600))hrs $((($SECONDS / 60) % 60))min $(($SECONDS % 60))sec"
echo $ELAPSED

#Sets up Required resources for multicluster purposes
scripts/multicluster.sh
sleep 10
echo "First Cluster now up and running..."

#Start up and configure Istio on Remote Cluster
scripts/remotecluster.sh

# Check if the --app flag is passed
if [[ " $* " == *" --app "* ]]; then 
  echo "Mounting application, please wait..."
  scripts/appmount.sh 
else
  echo "Skipping app mounting phase. Run clusterinit.sh with --app to mount the application"
fi

if [[ " $* " == *" --kiali "* ]]; then
  scripts/observe.sh 1
fi

# Check if the --test flag is passed
if [[ " $* " == *" --test "* ]]; then
  #Tests connectivity between clusters
  scripts/verify.sh --init
else
  echo "Skipping test phase. Run clusterinit.sh with --test to verify connectivity"
fi

TOTELA="Finish! Total Time: $(($SECONDS / 3600))hrs $((($SECONDS / 60) % 60))min $(($SECONDS % 60))sec"
echo $TOTELA
echo " "
if [[ " $* " == *" --app "* ]]; then
  echo "App reachable at $MY_SERVICE_IP"
  echo "Keycloak console reachable at $MY_SERVICE_IP/auth"
fi
if [[ " $* " == *" --kiali "* ]]; then
  echo "Kiali console reachable at $MY_SERVICE_IP/kiali"
fi
echo " "

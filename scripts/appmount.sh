# Check if an IP address was provided as an argument
if [ $# -ne 1 ]; then
  echo "Usage: $0 <MultiCluster Flag 0/1>"
  exit 1
fi

kubectl create namespace appspace --context='cube1'
kubectl label namespace appspace istio-injection=enabled --context='cube1'
kubectl create namespace authzone --context='cube1'

if [ $1 -eq 1 ]; then
  kubectl create namespace appspace --context='cube2'
  kubectl label namespace appspace istio-injection=enabled --context='cube2'
  kubectl create namespace authzone --context='cube2'
  kubectl label namespace authzone istio-injection=enabled --context='cube2'
  kubectl apply -f res/pvs.yaml -n authzone --context='cube2'
  scripts/dockerbuildall.sh
  scripts/dockerbuild2.sh
else
  kubectl apply -f res/pvs.yaml -n authzone --context='cube1'
  scripts/dockerbuildall.sh
fi

scripts/clusterbuild.sh $1
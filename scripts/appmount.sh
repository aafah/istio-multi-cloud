# Check if an IP address was provided as an argument
if [ $# -ne 3 ]; then
  echo "Usage: $0 <IP address> <Num of cluster> <Postgress IP>"
  exit 1
fi

kubectl create namespace appspace --context='cube1'
kubectl create namespace kcloak --context='cube1'
kubectl label namespace appspace istio-injection=enabled --context='cube1'
kubectl apply -f res/pvs.yaml --context='cube1'

scripts/dockerbuildall.sh
scripts/dynfix.sh $1
scripts/clusterbuild.sh $2 $3
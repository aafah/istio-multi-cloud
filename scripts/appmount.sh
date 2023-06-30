#
#Cluster 1
kubectl create namespace appspace --context='cube1'
kubectl label namespace appspace istio-injection=enabled --context='cube1'
kubectl create namespace authzone --context='cube1'

#Cluster 2
kubectl create namespace appspace --context='cube2'
kubectl label namespace appspace istio-injection=enabled --context='cube2'
kubectl create namespace authzone --context='cube2'
kubectl label namespace authzone istio-injection=enabled --context='cube2'
kubectl apply -f res/pvs.yaml -n authzone --context='cube2'

#Docker Images Build
scripts/dockerbuildall.sh
scripts/dockerbuild2.sh

#Cluster Build
scripts/clusterbuild.sh 
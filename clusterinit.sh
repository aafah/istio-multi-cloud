istioctl install -y --set profile=demo --set values.global.proxy.privileged=true
kubectl create namespace appspace
kubectl label namespace appspace istio-injection=enabled
./dockerbuildall.sh
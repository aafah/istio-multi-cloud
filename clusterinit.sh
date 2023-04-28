# Check if an IP address was provided as an argument
if [ $# -ne 1 ]; then
  echo "Usage: $0 <IP address>"
  exit 1
fi

# Set the IP address
MY_SERVICE_IP=$1

SECONDS=0

minikube start --mount-string=/home/admar/first:/host --mount --cpus 4 --memory 10240
istioctl install -y --set profile=demo --set values.global.proxy.privileged=true --set meshConfig.outboundTrafficPolicy.mode=REGISTRY_ONLY
kubectl create namespace appspace
kubectl create namespace kcloak
kubectl label namespace appspace istio-injection=enabled
kubectl apply -f pvs.yaml
kubectl apply -f istio-configmap.yaml --force --overwrite
minikube addons enable metallb 
kubectl apply -f metal.yaml 
./dockerbuildall.sh
./oauthfix.sh $MY_SERVICE_IP
./clusterbuild.sh

echo "Cluster now up and running, have fun!"
ELAPSED="Elapsed: $(($SECONDS / 3600))hrs $((($SECONDS / 60) % 60))min $(($SECONDS % 60))sec"
echo $ELAPSED

#EDIT ISTIO configmap
#- name: "oauth2-proxy"
#      envoyExtAuthzHttp:
#       service: "oauth-proxy-service.default.svc.cluster.local"
#       port: "4180" # The default port used by oauth2-proxy.
#       includeHeadersInCheck: ["authorization", "cookie","x-forwarded-access-token","x-forwarded-user","x-forwarded-email","x-forwarded-proto","proxy-authorization","user-agent","x-forwarded-host","from","x-forwarded-for","accept","x-auth-request-redirect"] # headers sent to the oauth2-proxy in the check request.
#       headersToUpstreamOnAllow: ["authorization", "path", "x-auth-request-user", "x-auth-request-email", "x-auth-request-access-token","x-forwarded-access-token", "X-Auth-Request-Redirect"] # headers sent to backend application when request is allowed.
#       headersToDownstreamOnDeny: ["content-type", "set-cookie"] # headers sent back to the client when request is denied.
istioctl install -y --set profile=demo --set values.global.proxy.privileged=true --set meshConfig.outboundTrafficPolicy.mode=REGISTRY_ONLY
kubectl create namespace appspace
kubectl create namespace kcloak
kubectl label namespace appspace istio-injection=enabled
kubectl apply -f pvs.yaml
kubectl apply -f istio-configmap.yaml --force --overwrite
minikube addons enable metallb 
kubectl apply -f config.yaml --force --overwrite
./dockerbuildall.sh


#EDIT ISTIO configmap
#- name: "oauth2-proxy"
#      envoyExtAuthzHttp:
#       service: "oauth-proxy-service.default.svc.cluster.local"
#       port: "4180" # The default port used by oauth2-proxy.
#       includeHeadersInCheck: ["authorization", "cookie","x-forwarded-access-token","x-forwarded-user","x-forwarded-email","x-forwarded-proto","proxy-authorization","user-agent","x-forwarded-host","from","x-forwarded-for","accept","x-auth-request-redirect"] # headers sent to the oauth2-proxy in the check request.
#       headersToUpstreamOnAllow: ["authorization", "path", "x-auth-request-user", "x-auth-request-email", "x-auth-request-access-token","x-forwarded-access-token", "X-Auth-Request-Redirect"] # headers sent to backend application when request is allowed.
#       headersToDownstreamOnDeny: ["content-type", "set-cookie"] # headers sent back to the client when request is denied.
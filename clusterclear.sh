kubectl delete all --all -n appspace
kubectl delete all --all -n default
kubectl delete all --all -n kcloak
kubectl delete serviceaccount --all -n appspace
kubectl delete authorizationpolicy --all -n istio-system
kubectl delete virtualservice,deployment,service,destinationrule,gateway,peerauthentication,authorizationpolicy --all -n appspace
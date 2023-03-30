kubectl delete all --all -n appspace
kubectl delete all --all -n default
kubectl delete serviceaccount --all -n appspace
kubectl delete authorizationpolicy --all -n appspace
kubectl delete authorizationpolicy --all -n istio-system
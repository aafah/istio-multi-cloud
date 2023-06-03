# Set the BUNDLE
CA_BUNDLE=$(kubectl get secret cacerts -n istio-system --context='cube1' -o jsonpath={.data."ca-cert\.pem"})

kubectl --context='cube2' patch mutatingwebhookconfigurations.admissionregistration.k8s.io -n istio-system istio-sidecar-injector -p "{\"webhooks\":[{\"clientConfig\":{\"caBundle\":\"${CA_BUNDLE}\"},\"name\":\"rev.namespace.sidecar-injector.istio.io\"}]}"
kubectl --context='cube2' patch mutatingwebhookconfigurations.admissionregistration.k8s.io -n istio-system istio-sidecar-injector -p "{\"webhooks\":[{\"clientConfig\":{\"caBundle\":\"${CA_BUNDLE}\"},\"name\":\"rev.object.sidecar-injector.istio.io\"}]}"
kubectl --context='cube2' patch mutatingwebhookconfigurations.admissionregistration.k8s.io -n istio-system istio-sidecar-injector -p "{\"webhooks\":[{\"clientConfig\":{\"caBundle\":\"${CA_BUNDLE}\"},\"name\":\"namespace.sidecar-injector.istio.io\"}]}"
kubectl --context='cube2' patch mutatingwebhookconfigurations.admissionregistration.k8s.io -n istio-system istio-sidecar-injector -p "{\"webhooks\":[{\"clientConfig\":{\"caBundle\":\"${CA_BUNDLE}\"},\"name\":\"object.sidecar-injector.istio.io\"}]}"

kubectl --context='cube2' patch mutatingwebhookconfigurations.admissionregistration.k8s.io -n istio-system istio-revision-tag-default -p "{\"webhooks\":[{\"clientConfig\":{\"caBundle\":\"${CA_BUNDLE}\"},\"name\":\"rev.namespace.sidecar-injector.istio.io\"}]}"
kubectl --context='cube2' patch mutatingwebhookconfigurations.admissionregistration.k8s.io -n istio-system istio-revision-tag-default -p "{\"webhooks\":[{\"clientConfig\":{\"caBundle\":\"${CA_BUNDLE}\"},\"name\":\"rev.object.sidecar-injector.istio.io\"}]}"
kubectl --context='cube2' patch mutatingwebhookconfigurations.admissionregistration.k8s.io -n istio-system istio-revision-tag-default -p "{\"webhooks\":[{\"clientConfig\":{\"caBundle\":\"${CA_BUNDLE}\"},\"name\":\"namespace.sidecar-injector.istio.io\"}]}"
kubectl --context='cube2' patch mutatingwebhookconfigurations.admissionregistration.k8s.io -n istio-system istio-revision-tag-default -p "{\"webhooks\":[{\"clientConfig\":{\"caBundle\":\"${CA_BUNDLE}\"},\"name\":\"object.sidecar-injector.istio.io\"}]}"

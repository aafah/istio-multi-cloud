eval $(minikube docker-env)
docker build -t probe-image probejs/
docker build -t microtwo-image microtwo/
docker build -t microdb-image microdb/
docker build -t react-image exapp/
docker build -t microusr-image microusr/
echo "Deleting minikube instances..."
minikube stop --profile='cube1'
minikube delete --profile='cube1'
minikube stop --profile='cube2'
minikube delete --profile='cube2'

echo "Removing docker networks..."
docker network rm cube1
docker network rm cube2

echo "Finished!"
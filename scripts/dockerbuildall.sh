function update_progress {
  local progress=$(($1))
  local done=$(($progress))
  local left=$((100 - $done))
  local fill=$(printf "%${done}s" | tr ' ' '#')
  local empty=$(printf "%${left}s" | tr ' ' '-')
  echo "$fill" "$empty" "$1"
}

echo "[3/6] Building docker images..."
update_progress 0
eval $(minikube docker-env --profile='cube1')
docker build -t probe-image app-code/probejs/
update_progress 20
docker build -t microtwo-image app-code/microtwo/
update_progress 40
docker build -t microdb-image app-code/microdb/
update_progress 60
docker build -t react-image app-code/exapp/
update_progress 100
eval $(minikube docker-env --profile='cube1' --unset)
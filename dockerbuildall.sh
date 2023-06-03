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
docker build -t probe-image probejs/
update_progress 10
docker build -t microtwo-image microtwo/
update_progress 30
docker build -t microdb-image microdb/
update_progress 50
docker build -t microusr-image microusr/
update_progress 70
docker build -t react-image exapp/
update_progress 100
function update_progress {
  local progress=$(($1))
  local done=$(($progress))
  local left=$((100 - $done))
  local fill=$(printf "%${done}s" | tr ' ' '#')
  local empty=$(printf "%${left}s" | tr ' ' '-')
  echo "$fill" "$empty" "$1"
}
echo "[3/6] Building docker images for second cluster..."
eval $(minikube docker-env --profile='cube2')

update_progress 0
docker build -t microdb-image app2-code/microdb/
update_progress 100

eval $(minikube docker-env --profile='cube2' --unset)
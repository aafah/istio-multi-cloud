# Array of pod tags and corresponding endpoints
# Function to test the connection
test_connection() {
    source_pod=$1
    endpoint=$2
    context=$3
    method=$4
    
    echo "Testing $method connection from ${source_pod:0:7}... to ${endpoint:0:7}..."
    
    # Perform GET request and check response status
    response=$(kubectl exec -n appspace --context=$context $source_pod -- curl -s -o /dev/null -w "%{http_code}" \
        -X $method http://$endpoint)
    
    if [ $response -eq 200 ]; then
        echo "Connection ACCEPTED"
    else
        echo "Connection DENIED"
    fi
}

# Get the list of pods
pods=$(kubectl get pods -n appspace --context='cube1' -o jsonpath='{.items[*].metadata.name}' )
pods2=$(kubectl get pods -n appspace --context='cube2' -o jsonpath='{.items[*].metadata.name}' )

svc_endpoints_get=(
  "api-two-service.appspace.svc.cluster.local:3002/updates/7d796226"
  "api-db-service.appspace.svc.cluster.local:3003/topics"
  "api-usr-service.appspace.svc.cluster.local:3005/userinfo/anon@cloak.app"
  "react-service.appspace.svc.cluster.local:3000/"
)

# Iterate over each pod
for source_pod in $pods; do
    # Iterate over each service
    for endpoint in "${svc_endpoints_get[@]}"; do
        test_connection $source_pod $endpoint 'cube1' 'GET'
    done
done

# Iterate over each pod
for source_pod in $pods2; do
    # Iterate over each service
    for endpoint in "${svc_endpoints_get[@]}"; do
        test_connection $source_pod $endpoint 'cube2' 'GET'
    done
    for endpoint in "${svc_endpoints_get[@]}"; do
        test_connection $source_pod $endpoint 'cube2' 'DELETE'
    done
done
echo " "
echo "---------------------------------"
echo "Testing RBAC connectivity"
echo "---------------------------------"
echo " "

if [[ " $* " == *" --init "* ]]; then
    kubectl apply -f res/deplo/probe.yaml --context='cube1' -n default
    kubectl apply -f res/deplo/probe.yaml --context='cube1' -n appspace
    kubectl apply -f res/deplo/probe.yaml --context='cube2' -n authzone
    echo "Test Deployment complete, Starting testing phase..."
else
    echo "Skipping setup phase. Run testall.sh with --init to setup environment"
fi

PROBE_DEF=$(kubectl get pods -n default -l "app=api-probe" --context='cube1' -o jsonpath='{.items[0].metadata.name}')
PROBE_APP=$(kubectl get pods -n appspace -l "app=api-probe" --context='cube1' -o jsonpath='{.items[0].metadata.name}')
PROBE_APP2=$(kubectl get pods -n authzone -l "app=api-probe" --context='cube2' -o jsonpath='{.items[0].metadata.name}')

while [[ $(kubectl get pods -n default $PROBE_DEF --context='cube1' -o 'jsonpath={..status.conditions[?(@.type=="Ready")].status}') != "True" ]]; do
    sleep 5
done
while [[ $(kubectl get pods -n appspace $PROBE_APP --context='cube1' -o 'jsonpath={..status.conditions[?(@.type=="Ready")].status}') != "True" ]]; do
    sleep 5
done

echo " "
echo "---------------------------------------------"
echo "probe.default.cube1 -> microdb.appspace.cube2"
echo "---------------------------------------------"
kubectl --context='cube1' -n default \
    exec $PROBE_DEF -- \
    curl api-db-service.appspace.svc.cluster.local:3003/debug
echo " "

echo "-----------------------------------------------"
echo "probe.default.cube1 -> micro-two.appspace.cube1"
echo "-----------------------------------------------"
kubectl --context='cube1' -n default \
    exec $PROBE_DEF -- \
    curl api-two-service.appspace.svc.cluster.local:3002/updates/7d796226
echo " "

echo "------------------------------------------------"
echo "probe.appspace.cube1 -> micro-two.appspace.cube1"
echo "------------------------------------------------"
kubectl --context='cube1' -n appspace \
    exec $PROBE_APP -- sh -c \
    "wget -qO- \
    api-two-service.appspace.svc.cluster.local:3002/updates/7d796226 \
    | jq -C"
echo " "

echo "----------------------------------------------"
echo "probe.appspace.cube1 -> microdb.appspace.cube2"
echo "----------------------------------------------"
kubectl --context='cube1' -n appspace \
     exec $PROBE_APP -- \
     curl api-db-service.appspace.svc.cluster.local:3003/debug
echo " "

echo "----------------Allowing route---------------"
kubectl apply -f res/istio/test-pol.yaml --context='cube2'
echo ""

kubectl --context='cube1' -n appspace \
     exec $PROBE_APP -- \
     curl api-db-service.appspace.svc.cluster.local:3003/debug
echo " "

#echo "-----------------Tracing Route----------------"
#kubectl --context='cube1' -n appspace \
#     exec $PROBE_APP -- \
#     traceroute api-db-service.appspace.svc.cluster.local:3003


#echo "-----------------------------------------------------------"
#echo "probe.appspace.cube1 -> keycloak.authspace.cube2  [JWT req] "
#echo "-----------------------------------------------------------"
#kubectl --context='cube1' -n appspace \
#     exec $PROBE_APP -- sh -c \
#     "curl \
#     -d 'client_id=appclient' -d 'username=user-one' -d 'password=password' \
#     -d 'grant_type=password' \
#     'http://keycloak-service.authzone.svc.cluster.local:8080/auth/realms/appcloak/protocol/openid-connect/token'"


echo "----------------------------------"
echo "          Testing done"
echo "----------------------------------"
echo " "
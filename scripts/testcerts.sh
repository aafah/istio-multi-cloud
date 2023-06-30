if [[ " $* " == *" --init "* ]]; then
    kubectl apply -f res/deplo/probe.yaml --context='cube1' -n appspace
    kubectl apply -f res/deplo/probe.yaml --context='cube2' -n appspace
    echo "Test Deployment complete, Starting testing phase..."
else
    echo "Skipping setup phase. Run testall.sh with --init to setup environment"
fi

PROBE_APP=$(kubectl get pods -n appspace -l "app=api-probe" --context='cube1' -o jsonpath='{.items[0].metadata.name}')
PROBE_APP2=$(kubectl get pods -n appspace -l "app=api-probe" --context='cube2' -o jsonpath='{.items[0].metadata.name}')

while [[ $(kubectl get pods -n appspace $PROBE_APP --context='cube1' -o 'jsonpath={..status.conditions[?(@.type=="Ready")].status}') != "True" ]]; do
    sleep 5
done


echo " "
echo "---------------------------------"
echo "      Testing CERTIFICATES"
echo "---------------------------------"
echo " "

echo "-----------------------------------------------------"
echo "probe.appspace.cube1 -cert-> micro-two.appspace.cube1"
echo "-----------------------------------------------------"
kubectl --context='cube1' -n appspace \
    exec $PROBE_APP -c istio-proxy -- sh -c \
    "openssl s_client -showcerts -connect api-two-service.appspace.svc.cluster.local:3002 \
    -CAfile /var/run/secrets/istio/root-cert.pem | openssl x509 -in /dev/stdin -text -noout"
echo " "

echo "----------------------------------------------------"
echo "probe.appspace.cube2 -cert-> micro-db.appspace.cube2"
echo "----------------------------------------------------"
kubectl --context='cube2' -n appspace \
    exec $PROBE_APP2 -c istio-proxy -- sh -c \
    "openssl s_client -showcerts -connect api-db-service.appspace.svc.cluster.local:3003 \
    -CAfile /var/run/secrets/istio/root-cert.pem | openssl x509 -in /dev/stdin -text -noout"
echo " "


echo "----------------------------------"
echo "          Testing done"
echo "----------------------------------"
echo " "
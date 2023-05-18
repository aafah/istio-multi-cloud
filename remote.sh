SERVICE_IP=$1
# Define the base64 encoded password
PASSWORD_BASE64="YUQxNzcwMTM/bWFy"

# Decode the base64 encoded password
PASSWORD=$(echo $PASSWORD_BASE64 | base64 -d)

#local CA_BUNDLE=$(kubectl get secret cacerts -n istio-system -o jsonpath={.data."ca-cert\.pem"})
istioctl x create-remote-secret --name=cluster1 > aws.txt

sed -i "s/192.168.49.2/$SERVICE_IP/g" aws.txt
  

#scp aws.txt admar@20.111.26.14:second/
echo "Secret forged"
sshpass -p "$PASSWORD" ssh -o StrictHostKeyChecking=no admar@20.111.26.14 "cd second;\
  cat > aws.txt;\
  ./clusterinit.sh;\
  ./istio-attach.sh \"$SERVICE_IP\";\
  kubectl apply -f aws.txt;" < aws.txt
echo "Remote session initialized"

# echo \"$CA_BUNDLE\" > second/bundle.txt; \
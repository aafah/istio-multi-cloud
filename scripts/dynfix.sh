#!/bin/bash

# Check if an IP address was provided as an argument
if [ $# -ne 1 ]; then
  echo "Usage: $0 <IP address>"
  exit 1
fi

echo "Configuring dynamic entries..."

# Set the IP address
MY_SERVICE_IP=$1

# Generate the actual YAML file from the template
#cp res/istio/operator-tmp.yaml res/istio/operator.yaml
#sed -i "s/{{NAMESPA}}/$REDN/g" res/istio/operator.yaml
#echo "Istio operator configured"

cp res/deplo/oauth2-tmp.yaml res/deplo/oauth2.yaml
cp res/istio/jwtrules-tmp.yaml res/istio/jwtrules.yaml

sed -i "s/{{MY_SERVICE_IP}}/$MY_SERVICE_IP/g" res/deplo/oauth2.yaml
echo "Oauth2-proxy configured"

sed -i "s/{{MY_SERVICE_IP}}/$MY_SERVICE_IP/g" res/istio/jwtrules.yaml
echo "JWT Rules configured"

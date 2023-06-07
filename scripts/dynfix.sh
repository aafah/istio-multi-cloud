#!/bin/bash

# Check if an IP address was provided as an argument
if [ $# -ne 1 ]; then
  echo "Usage: $0 <IP address>"
  exit 1
fi

echo "[4/6] Configuring dynamic IP entries..."

# Set the IP address
MY_SERVICE_IP=$1

# Generate the actual YAML file from the template
cp res/deplo/oauth2-tmp.yaml res/deplo/oauth2.yaml
cp res/istio/jwtrules-tmp.yaml res/istio/jwtrules.yaml

# Replace placeholders with environment variables using sed
sed -i "s/{{MY_SERVICE_IP}}/$MY_SERVICE_IP/g" res/deplo/oauth2.yaml
sed -i "s/{{MY_SERVICE_IP}}/$MY_SERVICE_IP/g" res/istio/jwtrules.yaml

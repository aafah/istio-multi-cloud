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
cp oauth2-tmp.yaml oauth2.yaml
cp jwtrules-tmp.yaml jwtrules.yaml

# Replace placeholders with environment variables using sed
sed -i "s/{{MY_SERVICE_IP}}/$MY_SERVICE_IP/g" oauth2.yaml
sed -i "s/{{MY_SERVICE_IP}}/$MY_SERVICE_IP/g" jwtrules.yaml

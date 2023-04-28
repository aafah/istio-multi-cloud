#!/bin/bash

# Set the IP address
MY_SERVICE_IP= $1

# Generate the actual YAML file from the template
cp oauth2-tmp.yaml oauth2.yaml

# Replace placeholders with environment variables using sed
sed -i "s/{{MY_SERVICE_IP}}/$MY_SERVICE_IP/g" oauth2.yaml

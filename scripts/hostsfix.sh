MULTI=$1

# Define the new IP address and hostname
if [ $MULTI -eq 1 ]; then
    new_ip="192.168.58.8"
else
    new_ip="192.168.49.7"
fi

hostname="keycloak.com"

# Use grep to search for the line containing the old IP address and extract it
line=$(grep " $hostname$" /etc/hosts)

# Check if the line exists
if [[ -n $line ]]; then
    # Use sed to replace the line with the new IP address and hostname
    sudo sed -i "s/$line/$new_ip $hostname/" /etc/hosts
else
    # Append a new line with the new IP address and hostname at the end of the file
    sudo echo "$new_ip $hostname" | sudo tee -a /etc/hosts > /dev/null
fi

sudo systemctl stop nginx
sudo systemctl start nginx
echo "Nginx reloaded"
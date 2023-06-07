echo " "
echo "------------------------"
echo "     NETWORK SETUP"
echo "------------------------"
echo " "
echo "Creating communicating networks for the two clusters..."
# Create the cube1 network
docker network create -d bridge --opt com.docker.network.bridge.name=cube1-net cube1 --subnet=192.168.49.0/24 --gateway=192.168.49.1
echo "Created cube1 network with bridge: cube1-net"

# Create the cube2 network
docker network create -d bridge --opt com.docker.network.bridge.name=cube2-net cube2 --subnet=192.168.58.0/24 --gateway=192.168.58.1
echo "Created cube2 network with bridge: cube2-net"

# Add iptables rules
sudo iptables -I DOCKER-USER -i "cube1-net" -o "cube2-net" -j ACCEPT
sudo iptables -I DOCKER-USER -i "cube2-net" -o "cube1-net" -j ACCEPT
echo "Added iptables rules for network bridges"
### install k3s without the default load balancer and ingresses
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="server --no-deploy=traefik --disable servicelb" sh -s -


### grab your server token
cat /var/lib/rancher/k3s/server/node-token

### on your nodes
curl -sfL https://get.k3s.io | K3S_URL="<host_ip>:6443" K3S_TOKEN="<server_token_from_above>" K3S_NODE_NAME="<node_name>" sh 

### disallow pods to be created on master node
k taint node raspberrypi node-role.kubernetes.io/raspberrypi=:NoSchedule-


### install metallb
helm repo add metallb https://metallb.github.io/metallb

helm upgrade --install metallb metallb/metallb -f metallb/values.yaml

### metallb has some issues on bare-metal/rpi setups 
### https://github.com/metallb/metallb/issues/253
### on your nginx nodes, run the following to fix
sudo ip link set dev wlan0 promisc on


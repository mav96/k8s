sudo apt-get update
sudo apt-get install nfs-kernel-server

sudo mkdir /var/nfs/general -p
sudo chown nobody:nogroup /var/nfs/general

echo "/var/nfs/general   *(rw,sync,no_subtree_check)" | sudo tee -a /etc/exports -

sudo systemctl restart nfs-kernel-server

sudo ufw allow from 10.0.0.0/24 to any port nfs


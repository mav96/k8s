USER=super
sudo mkdir -p /etc/kubernetes/pki/etcd
sudo mv /home/${USER}/ca.crt /etc/kubernetes/pki/
sudo mv /home/${USER}/ca.key /etc/kubernetes/pki/
sudo mv /home/${USER}/sa.pub /etc/kubernetes/pki/
sudo mv /home/${USER}/sa.key /etc/kubernetes/pki/
sudo mv /home/${USER}/front-proxy-ca.crt /etc/kubernetes/pki/
sudo mv /home/${USER}/front-proxy-ca.key /etc/kubernetes/pki/
sudo mv /home/${USER}/etcd-ca.crt /etc/kubernetes/pki/etcd/ca.crt
sudo mv /home/${USER}/etcd-ca.key /etc/kubernetes/pki/etcd/ca.key
sudo mv /home/${USER}/admin.conf /etc/kubernetes/admin.conf

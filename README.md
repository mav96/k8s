# k8s

## We have:
LoadBalancer: ```masterkub.tran.lan:6443```

Master-nodes:
```
kub-01.tran.lan 192.168.12.34
kub-02.tran.lan 192.168.12.34
kub-03.tran.lan 192.168.12.34
```

Worker-nodes:
```
docker-01.tran.lan
docker-02.tran.lan
```


### Install software on all nodes
```bash
sudo apt-get update && sudo apt-get upgrade -y
sudo swapoff -a
echo 'net.bridge.bridge-nf-call-iptables=1' | sudo tee /etc/sysctl.conf
sudo sysctl -p

echo "Install docker"
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") $(lsb_release -cs) stable"
sudo mkdir -p /etc/docker && echo '{"storage-driver": "overlay2"}' | sudo tee /etc/docker/daemon.json
sudo apt-get update && sudo apt-get install -y docker-ce=$(apt-cache madison docker-ce | grep 17.03 | head -1 | awk '{print $3}')
sudo usermod -aG docker $USER

echo "Install Kubernetes"
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo 'deb http://apt.kubernetes.io/ kubernetes-xenial main' | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update && sudo apt-get install kubelet kubeadm kubectl -y

```

### Configuration master-nodes
#### Create kubeadm-config.yaml on master-nodes

##### kubeadm-config.yaml on kub-01.tran.lan
```yaml
apiVersion: kubeadm.k8s.io/v1alpha2
kind: MasterConfiguration
apiServerCertSANs:
- "masterkub.tran.lan"
api:
    controlPlaneEndpoint: "masterkub.tran.lan:6443"
    advertiseAddress: 192.168.12.34
etcd:
  local:
    extraArgs:
      listen-client-urls: "https://127.0.0.1:2379,https://192.168.12.34:2379"
      advertise-client-urls: "https://192.168.12.34:2379"
      listen-peer-urls: "https://192.168.12.34:2380"
      initial-advertise-peer-urls: "https://192.168.12.34:2380"
      initial-cluster: "kub-01=https://192.168.12.34:2380"
    serverCertSANs:
      - kub-01
      - 192.168.12.34
    peerCertSANs:
      - kub-01
      - 192.168.12.34
```
#
##### kubeadm-config.yaml on kub-02.tran.lan
```yaml
apiVersion: kubeadm.k8s.io/v1alpha2
kind: MasterConfiguration
apiServerCertSANs:
- "masterkub.tran.lan"
api:
    controlPlaneEndpoint: "masterkub.tran.lan:6443"
    advertiseAddress: 192.168.12.35
etcd:
  local:
    extraArgs:
      listen-client-urls: "https://127.0.0.1:2379,https://192.168.12.35:2379"
      advertise-client-urls: "https://192.168.12.35:2379"
      listen-peer-urls: "https://192.168.12.35:2380"
      initial-advertise-peer-urls: "https://192.168.12.35:2380"
      initial-cluster: "kub-01=https://192.168.12.34:2380,kub-02=https://192.168.12.35:2380"
      initial-cluster-state: existing
    serverCertSANs:
      - kub-02
      - 192.168.12.35
    peerCertSANs:
      - kub-02
      - 192.168.12.35
```

#
##### kubeadm-config.yaml on kub-03.tran.lan
```yaml
apiVersion: kubeadm.k8s.io/v1alpha2
kind: MasterConfiguration
apiServerCertSANs:
- "masterkub.tran.lan"
api:
    controlPlaneEndpoint: "masterkub.tran.lan:6443"
    advertiseAddress: 192.168.12.36
etcd:
  local:
    extraArgs:
      listen-client-urls: "https://127.0.0.1:2379,https://192.168.12.36:2379"
      advertise-client-urls: "https://192.168.12.36:2379"
      listen-peer-urls: "https://192.168.12.36:2380"
      initial-advertise-peer-urls: "https://192.168.12.36:2380"
      initial-cluster: "kub-01=https://192.168.12.34:2380,kub-02=https://192.168.12.35:2380,kub-03=https://192.168.12.36:2380"
      initial-cluster-state: existing
    serverCertSANs:
      - kub-03
      - 192.168.12.36
    peerCertSANs:
      - kub-03
      - 192.168.12.36
```

#

Bootstrap the first stacked control plane node
```bash
sudo kubeadm init --config kubeadm-config.yaml
```
Good if you see something like: 
```
kubeadm join masterkub.tran.lan:6443 --token i7z7dy.9t4zaf7u0nkm1my8 --discovery-token-ca-cert-hash sha256:f15064211455b890699af1e2dfb203781e6f09705356107018640aa4e1c06c62
```
It's command for join worker-nodes. 

#
Copy required files to other control plane nodes ( to kub-0{2-3}.tran.lan )
```ini
/etc/kubernetes/pki/ca.crt
/etc/kubernetes/pki/ca.key
/etc/kubernetes/pki/sa.key
/etc/kubernetes/pki/sa.pub
/etc/kubernetes/pki/front-proxy-ca.crt
/etc/kubernetes/pki/front-proxy-ca.key
/etc/kubernetes/pki/etcd/ca.crt
/etc/kubernetes/pki/etcd/ca.key
/etc/kubernetes/admin.conf
```

Script copy_kub-01.sh
```bash
sudo tar rvf  archive.tar  /path/to/newfile.txt
sudo tar rvf  archive.tar  /etc/kubernetes/pki/ca.crt
sudo tar rvf  archive.tar  /etc/kubernetes/pki/ca.key
sudo tar rvf  archive.tar  /etc/kubernetes/pki/sa.key
sudo tar rvf  archive.tar  /etc/kubernetes/pki/sa.pub
sudo tar rvf  archive.tar  /etc/kubernetes/pki/front-proxy-ca.crt
sudo tar rvf  archive.tar  /etc/kubernetes/pki/front-proxy-ca.key
sudo tar rvf  archive.tar  /etc/kubernetes/pki/etcd/ca.crt
sudo tar rvf  archive.tar  /etc/kubernetes/pki/etcd/ca.key
sudo tar rvf  archive.tar  /etc/kubernetes/admin.conf
sudo chown ${USER} archive.tar

scp archive.tar kub-02.tran.lan:~/
scp archive.tar kub-03.tran.lan:~/
```
#
##### Add the second stacked control plane node
Move the copied files to the correct locations:
```bash
tar -xvf archive.tar
sudo mkdir -p /etc/kubernetes/pki/etcd
sudo mv etc/kubernetes/pki/ca.crt /etc/kubernetes/pki/
sudo mv etc/kubernetes/pki/ca.key /etc/kubernetes/pki/
sudo mv etc/kubernetes/pki/sa.pub /etc/kubernetes/pki/
sudo mv etc/kubernetes/pki/sa.key /etc/kubernetes/pki/
sudo mv etc/kubernetes/pki//front-proxy-ca.crt /etc/kubernetes/pki/
sudo mv etc/kubernetes/pki/front-proxy-ca.key /etc/kubernetes/pki/
sudo mv etc/kubernetes/pki/etcd/ca.crt /etc/kubernetes/pki/etcd/ca.crt
sudo mv etc/kubernetes/pki/etcd/ca.key /etc/kubernetes/pki/etcd/ca.key
sudo mv etc/kubernetes/admin.conf /etc/kubernetes/admin.conf
rm -rf etc
```

Create kubeadm-config.yaml for kub-02.tran.lan

Run the kubeadm phase commands to bootstrap the kubelet:
```bash
sudo kubeadm alpha phase certs all --config kubeadm-config.yaml
sudo kubeadm alpha phase kubelet config write-to-disk --config kubeadm-config.yaml
sudo kubeadm alpha phase kubelet write-env-file --config kubeadm-config.yaml
sudo kubeadm alpha phase kubeconfig kubelet --config kubeadm-config.yaml
sudo systemctl start kubelet
```
#
Run the commands to add the node to the etcd cluster:
```bash
export CP0_IP=192.168.12.34
export CP0_HOSTNAME=kub-01
export CP1_IP=192.168.12.35
export CP1_HOSTNAME=kub-02
export KUBECONFIG=/etc/kubernetes/admin.conf 

kubectl exec -n kube-system etcd-${CP0_HOSTNAME} -- etcdctl \
--ca-file /etc/kubernetes/pki/etcd/ca.crt \
--cert-file /etc/kubernetes/pki/etcd/peer.crt \
--key-file /etc/kubernetes/pki/etcd/peer.key \
--endpoints=https://${CP0_IP}:2379 \
member add ${CP1_HOSTNAME} https://${CP1_IP}:2380

sudo kubeadm alpha phase etcd local --config kubeadm-config.yaml
```
#
Deploy the control plane components and mark the node as a master:
```bash
sudo kubeadm alpha phase kubeconfig all --config kubeadm-config.yaml
sudo kubeadm alpha phase controlplane all --config kubeadm-config.yaml
sudo kubeadm alpha phase mark-master --config kubeadm-config.yaml
```
#
##### Add the third stacked control plane node
Move the copied files to the correct locations:
```bash
tar -xvf archive.tar
sudo mkdir -p /etc/kubernetes/pki/etcd
sudo mv etc/kubernetes/pki/ca.crt /etc/kubernetes/pki/
sudo mv etc/kubernetes/pki/ca.key /etc/kubernetes/pki/
sudo mv etc/kubernetes/pki/sa.pub /etc/kubernetes/pki/
sudo mv etc/kubernetes/pki/sa.key /etc/kubernetes/pki/
sudo mv etc/kubernetes/pki//front-proxy-ca.crt /etc/kubernetes/pki/
sudo mv etc/kubernetes/pki/front-proxy-ca.key /etc/kubernetes/pki/
sudo mv etc/kubernetes/pki/etcd/ca.crt /etc/kubernetes/pki/etcd/ca.crt
sudo mv etc/kubernetes/pki/etcd/ca.key /etc/kubernetes/pki/etcd/ca.key
sudo mv etc/kubernetes/admin.conf /etc/kubernetes/admin.conf
rm -rf etc
```

Create kubeadm-config.yaml for kub-03.tran.lan

Run the kubeadm phase commands to bootstrap the kubelet:
```bash
sudo kubeadm alpha phase certs all --config kubeadm-config.yaml
sudo kubeadm alpha phase kubelet config write-to-disk --config kubeadm-config.yaml
sudo kubeadm alpha phase kubelet write-env-file --config kubeadm-config.yaml
sudo kubeadm alpha phase kubeconfig kubelet --config kubeadm-config.yaml
sudo systemctl start kubelet
```

Run the commands to add the node to the etcd cluster:
```bash
export CP0_IP=192.168.12.34
export CP0_HOSTNAME=kub-01
export CP2_IP=192.168.12.36
export CP2_HOSTNAME=kub-03
export KUBECONFIG=/etc/kubernetes/admin.conf 

kubectl exec -n kube-system etcd-${CP0_HOSTNAME} -- etcdctl \
--ca-file /etc/kubernetes/pki/etcd/ca.crt \
--cert-file /etc/kubernetes/pki/etcd/peer.crt \
--key-file /etc/kubernetes/pki/etcd/peer.key \
--endpoints=https://${CP0_IP}:2379 \
member add ${CP2_HOSTNAME} https://${CP2_IP}:2380

sudo kubeadm alpha phase etcd local --config kubeadm-config.yaml
```

Deploy the control plane components and mark the node as a master:
```bash
sudo kubeadm alpha phase kubeconfig all --config kubeadm-config.yaml
sudo kubeadm alpha phase controlplane all --config kubeadm-config.yaml
sudo kubeadm alpha phase mark-master --config kubeadm-config.yaml
```


### Install CNI
Run on Master-node
```bash
kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"
```
#
Check on Master-node
```bash
kubectl get nodes
```
STATUS has to change to Ready for all nodes

### Create token for join  
#### Show connection string
```bash
sudo kubeadm token create --print-join-command
```


# Work with k8s

#### Install helm in kube-system
```bash
kubectl create serviceaccount tiller --namespace kube-system
kubectl create -f tiller-clusterrolebinding.yaml

curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get > /tmp/get_helm.sh
sudo bash /tmp/get_helm.sh
helm init --service-account tiller --upgrade
```

#### View token for tiller
```bash
SECRET_NAME=$(kubectl get sa tiller --namespace kube-system -o json | jq -r '.secrets[].name')
USER_TOKEN=$(kubectl get secret $SECRET_NAME --namespace kube-system -o json | jq -r '.data["token"]' | base64 -d)
echo "Token for user tiller:"
echo $USER_TOKEN
``` 

#### Install traefik as Ingress 
```bash
helm upgrade --install traefik ./helm/traefik --namespace kube-system
```




#### User for namespace prod

#### Create file prod-access.yaml
```yaml
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: ci
  namespace: prod

---
kind: Role
apiVersion: rbac.authorization.k8s.io/v1beta1
metadata:
  name: ci-access
  namespace: prod
rules:
- apiGroups: ["", "extensions", "apps"]
  resources: ["*"]
  verbs: ["*"]
- apiGroups: ["batch"]
  resources:
  - jobs
  - cronjobs
  verbs: ["*"]

---
kind: RoleBinding
apiVersion: rbac.authorization.k8s.io/v1beta1
metadata:
  name: ci-bind
  namespace: prod
subjects:
- kind: ServiceAccount
  name: ci
  namespace: prod
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: ci-access

---
kind: ClusterRole
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: ci-access
rules:
- apiGroups: [""]
  resources: ["namespaces"]
  verbs: ["get", "list", "watch"]
- nonResourceURLs: ["*"]
  verbs: ["get", "watch", "list"]

---
kind: ClusterRoleBinding
apiVersion: rbac.authorization.k8s.io/v1beta1
metadata:
  name: ci-cluster-bind
subjects:
- kind: ServiceAccount
  name: ci
  namespace: prod
roleRef:
  kind: ClusterRole
  name: ci-access
  apiGroup: rbac.authorization.k8s.io
```

```bash
kubectl create namespace prod
kubectl create -f prod-access.yaml
```

#### View token for CI
```bash
SECRET_NAME=$(kubectl get sa ci --namespace prod -o json | jq -r '.secrets[].name')
USER_TOKEN=$(kubectl get secret $SECRET_NAME --namespace prod -o json | jq -r '.data["token"]' | base64 -d)
echo "Token for user:"
echo $USER_TOKEN
``` 

#### Install helm for CI 
```bash
curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get > /tmp/get_helm.sh
sudo bash /tmp/get_helm.sh

# For user in namespace
NAMESPACE=prod
K8S_USER=ci
helm init --tiller-namespace $NAMESPACE --service-account $K8S_USER --upgrade
```

### Install soft for CI
```bash
sudo apt-get update && sudo apt-get install -y apt-transport-https
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
sudo touch /etc/apt/sources.list.d/kubernetes.list
echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubectl
kubectl version
```

### Configure context for CI
```bash
NAMESPACE=prod
K8S_USER=ci
kubectl config set-cluster kubernetes --insecure-skip-tls-verify=true --server=https://masterkub.tran.lan:6443
kubectl config set-credentials $K8S_USER --token=TOKEN
kubectl config set-context prod --cluster=kubernetes --user=$K8S_USER --namespace=$NAMESPACE
kubectl config use-context prod
kubectl config view
helm init --client-only
helm ls --tiller-namespace $NAMESPACE
```

### Run service Redis  (we work in namespace "prod")
```bash
helm upgrade --install redis ./helm/redis --tiller-namespace prod --namespace prod
```


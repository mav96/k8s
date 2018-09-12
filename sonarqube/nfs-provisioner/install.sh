## see: https://github.com/kubernetes-incubator/external-storage/tree/master/nfs

kubectl get nodes
kubectl label nodes fnc-worker-2  disktype=nfs
kubectl get nodes --show-labels
#On NFS node:
mkdir -p /data

kubectl create -f deployment.yaml
kubectl create -f class.yaml

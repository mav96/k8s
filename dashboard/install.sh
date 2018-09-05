htpasswd -c ./auth k8s

kubectl create secret generic dashboadr-secret --from-file auth --namespace=kube-system
kubectl create -f dashboard.yaml



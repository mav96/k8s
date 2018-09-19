htpasswd -c ./auth k8s
kubectl create secret generic dashboadr-secret --from-file auth --namespace=kube-system

helm upgrade --install dashboard ./dashboard --namespace kube-system 
## helm delete --purge dashboard
## kubectl delete  secret dashboadr-secret --namespace=kube-system





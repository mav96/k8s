### see: https://coderise.io/installing-sonarqube-in-kubernetes/
######## https://github.com/jonmosco/kubernetes-sonar

# first install nfs-provisioner !!!

kubectl create secret generic postgres-pwd --from-literal=password=P@ssw0rd
#kubectl create -f sonar-postgres-deployment.yaml  
#kubectl create -f sonar-postgres-service.yaml  
kubectl create -f postgres-extrnal-service.yaml
kubectl create -f sq-pvc.yaml
# wait: kubectl get pvc
kubectl apply -f sonarqube.yaml

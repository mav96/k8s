### see: https://coderise.io/installing-sonarqube-in-kubernetes/
######## https://github.com/jonmosco/kubernetes-sonar

kubectl create secret generic postgres-pwd --from-literal=password=P@ssw0rd
#kubectl create -f sonar-postgres-deployment.yaml  
#kubectl create -f sonar-postgres-service.yaml  
kubectl create -f postgres-extrnal-service.yaml

## For all nodes
sudo mkdir -p /data/sonarqube/extensions
sudo mkdir -p /data/sonarqube/data

kubectl create -f sonar-pv-pvc.yaml
kubectl apply -f sonarqube.yaml

### see: https://coderise.io/installing-sonarqube-in-kubernetes/
######## https://github.com/jonmosco/kubernetes-sonar

kubectl create secret generic postgres-pwd --from-literal=password=P@ssw0rd
kubectl create -f sonar-postgres-deployment.yaml  
kubectl create -f sonar-postgres-service.yaml  
kubectl apply -f sonarqube.yaml

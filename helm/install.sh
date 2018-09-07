# see: https://gist.github.com/innovia/fbba8259042f71db98ea8d4ad19bd708

kubectl create serviceaccount tiller --namespace kube-system
kubectl create -f tiller-clusterrolebinding.yaml

curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get > get_helm.sh
sudo bash get_helm.sh
helm init --service-account tiller --upgrade

SECRET_NAME=$(kubectl get sa tiller --namespace kube-system -o json | jq -r '.secrets[].name')
USER_TOKEN=$(kubectl get secret $SECRET_NAME --namespace kube-system -o json | jq -r '.data["token"]' | base64 -d)
echo "Token for user tiller:"
echo $USER_TOKEN
echo

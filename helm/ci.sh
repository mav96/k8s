kubectl config set-cluster kubernetes --insecure-skip-tls-verify=true --server=https://kubernetes.selit.ru:6443
kubectl config set-credentials tiller --token=TOKEN
kubectl config set-context tiller --cluster=kubernetes --user=tiller
kubectl config use-context tiller
helm init --client-only


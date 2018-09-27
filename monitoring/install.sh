### see: https://itnext.io/kubernetes-monitoring-with-prometheus-in-15-minutes-8e54d1de2e13
helm repo add coreos https://s3-eu-west-1.amazonaws.com/coreos-charts/stable/
#helm install coreos/prometheus-operator --name prometheus-operator --namespace monitoring
helm install --wait --timeout 600 --tiller-connection-timeout 600  coreos/prometheus-operator --name prometheus-operator --namespace monitoring
helm install coreos/kube-prometheus --name kube-prometheus --set global.rbacEnable=true --namespace monitoring --wait --timeout 1800 --tiller-connection-timeout 1800


##see: https://kubernetes.io/docs/tasks/debug-application-cluster/monitor-node-health/

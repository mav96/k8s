kubectl apply -f traefik-rbac.yaml
kubectl create secret generic traefik-cert --from-file=tls.crt --from-file=tls.key -n kube-system
kubectl create configmap traefik-conf --from-file=traefik.toml -n kube-system
kubectl apply -f traefik-rs.yaml


##With token
kubectl apply -f kubernetes-dashboard.yaml
Config for haproxy:

frontend https-in
    bind *:443 ssl crt /etc/haproxy/k8s.selit.ru/wildcard.pem
    # Define hosts
    acl dashboard  hdr(host) -i dashboard.site.ru

    ## figure out which one to use
    use_backend k8s_dashboard if dashboard
    default_backend k8s_cluster

backend k8s_cluster
        balance roundrobin
        option http-server-close
        server master 10.0.0.4:30080 check
        server slave  10.0.0.8:30080 check

backend k8s_dashboard
        balance roundrobin
        option http-server-close
        server master 10.0.0.4:30443 ssl verify none
        server slave  10.0.0.8:30443 ssl verify none



#With password
htpasswd -c ./auth k8s
kubectl create secret generic dashboadr-secret --from-file auth --namespace=kube-system

helm upgrade --install dashboard ./dashboard --namespace kube-system 
## helm delete --purge dashboard
## kubectl delete  secret dashboadr-secret --namespace=kube-system







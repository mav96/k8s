### see: https://docs.gitlab.com/ee/install/kubernetes/gitlab_runner_chart.html
helm repo add gitlab https://charts.gitlab.io
helm install --namespace gitlab --name ci -f values.yaml gitlab/gitlab-runner
#helm upgrade --namespace gitlab -f values.yaml ci gitlab/gitlab-runner
#helm del --purge ci

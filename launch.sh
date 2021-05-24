#!/bin/bash
app="api-data"
docker build -t ${app} .

minikube start --container-runtime=containerd \
	--docker-opt containerd=/var/run/containerd/containerd.sock

minikube addons enable metrics-server \
	gvisor \
	freshpod \
	helm-tiller

kubectl create deployment api-data --image=./api-data
kubectl expose deployment api-data --type=NodePort --port=8080

kubectl expose service prometheus-server --type=NodePort --target-port=9090 --name=prometheus-server-np \
	grafana --type=NodePort --target-port=3000 --name=grafana-np

minikube service prometheus-server-np \
	grafana-np

#docker run -d -p 5000:8080 \
#	--name=${app} \
#	-v $PWD ${app}

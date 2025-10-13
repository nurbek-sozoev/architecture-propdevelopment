#! /bin/bash

kubectl create namespace task5
kubectl config set-context --current --namespace=task5

kubectl run front-end-app --image=nginx --labels role=front-end
kubectl run back-end-api-app --image=nginx --labels role=back-end-api
kubectl run admin-front-end-app --image=nginx --labels role=admin-front-end
kubectl run admin-back-end-api-app --image=nginx --labels role=admin-back-end-api

kubectl expose pod/front-end-app --port=3030 --target-port=80 --name=front-end-app
kubectl expose pod/back-end-api-app --port=3030 --target-port=80 --name=back-end-api-app
kubectl expose pod/admin-front-end-app --port=3030 --target-port=80 --name=admin-front-end-app
kubectl expose pod/admin-back-end-api-app --port=3030 --target-port=80 --name=admin-back-end-api-app

kubectl apply -f task5/default-deny.yaml
kubectl apply -f task5/dns-allow.yaml
kubectl apply -f task5/non-admin-api-allow.yaml
kubectl apply -f task5/admin-api-allow.yaml
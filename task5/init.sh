#! /bin/bash

kubectl create namespace task5
kubectl config set-context --current --namespace=task5

kubectl -n task5 run front-end-app --image=nginx-curl:1.0 --image-pull-policy=Never -l role=front-end --expose --port 80
kubectl -n task5 run admin-front-end-app --image=nginx-curl:1.0 --image-pull-policy=Never -l role=admin-front-end --expose --port 80
kubectl -n task5 run back-end-api-app --image=nginx-curl:1.0 --image-pull-policy=Never -l role=back-end-api --expose --port 80
kubectl -n task5 run admin-back-end-api-app --image=nginx-curl:1.0 --image-pull-policy=Never -l role=admin-back-end-api --expose --port 80

kubectl apply -f ./non-admin-api-allow.yaml
kubectl apply -f ./admin-api-allow.yaml
# task5: Сетевые политики для разделения трафика

## Развёртывание pod'ов и сервисов

```bash
kubectl create namespace task5
kubectl config set-context --current --namespace=task5

kubectl run front-end-app --image=nginx --labels role=front-end
kubectl run back-end-api-app --image=nginx --labels role=back-end-api
kubectl run admin-front-end-app --image=nginx --labels role=admin-front-end
kubectl run admin-back-end-api-app --image=nginx --labels role=admin-back-end-api

# Создаём сервисы с портом 3030 и проксированием на контейнерный порт 80
kubectl expose pod/front-end-app --port=3030 --target-port=80 --name=front-end-app
kubectl expose pod/back-end-api-app --port=3030 --target-port=80 --name=back-end-api-app
kubectl expose pod/admin-front-end-app --port=3030 --target-port=80 --name=admin-front-end-app
kubectl expose pod/admin-back-end-api-app --port=3030 --target-port=80 --name=admin-back-end-api-app
```

## Применение сетевых политик

```bash
kubectl apply -f default-deny.yaml
kubectl apply -f dns-allow.yaml
kubectl apply -f non-admin-api-allow.yaml
kubectl apply -f admin-api-allow.yaml
```

## Проверка связности

Запускаем тестовый pod и проверяем доступность по сервисным DNS-именам:

```bash
kubectl run test-$(openssl rand -hex 3) --rm -i -t --image=alpine -- sh
apk add --no-cache curl

# Должно работать (front-end <-> back-end-api)
curl -sS http://back-end-api-app:3030

# Должно работать (admin-front-end <-> admin-back-end-api)
curl -sS http://admin-back-end-api-app:3030

# Должно быть запрещено (пересечённые пары)
curl -sS --max-time 3 http://admin-back-end-api-app:3030 || echo "blocked"
curl -sS --max-time 3 http://back-end-api-app:3030 || echo "blocked"
```

При необходимости можно проверить связь напрямую под↔под:

```bash
kubectl get pod -o wide
```

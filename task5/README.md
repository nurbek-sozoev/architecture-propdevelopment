# Task5

## Развёртывание подов

```bash
cd task5
minikube start --cni=calico
minikube image build -t nginx-curl:1.0 .
```

```bash
./init.sh
```

## Проверка связности

Убеждаемся, что все поды запущены:

```bash
kubectl -n task5 get pods
```

Запускаем тесты:

```bash
./test.sh
```

Результат должен быть следующим:

```bash
> ./test.sh
front-end -> back-end-api
OPEN
back-end-api -> front-end
OPEN
front-end -> admin-back-end-api
curl: (28) Connection timed out after 1001 milliseconds
BLOCKED
admin-front-end -> admin-back-end-api
OPEN
admin-back-end-api -> admin-front-end
OPEN
admin-front-end -> back-end-api
curl: (28) Connection timed out after 1001 milliseconds
BLOCKED
```

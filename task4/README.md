# Task4

| Роль                      | Права роли                                                                                                                                                                                      | Группы пользователей   |
| ------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------- |
| cluster-readonly          | Чтение кластерных и namespaced-ресурсов (get/list/watch) без доступа к секретам и RBAC.                                                                                                         | dev-readonly           |
| cluster-config-manager    | Управление конфигурацией и ворклоадами для: pods, services, endpoints, нодам и кластерным настройкам.                                                                                           | config-managers        |
| namespace-editor          | Роль уровня namespace: управление ворклоадами и сетевой конфигурацией внутри namespace (create/get/list/watch/update/patch/delete для: pods, services, endpoints без доступа к секретам и RBAC. | team-billing, team-crm |
| privileged-secrets-reader | Просмотр секретов во всех пространствах имён (get/list/watch `secrets`).                                                                                                                        | privileged             |

## Команды

`./init.sh`

или

```
minikube start

kubectl apply -f task4/users.yml
kubectl apply -f task4/roles.yml
kubectl apply -f task4/bindings.yml

kubectl auth can-i get pods -n billing --as=system:serviceaccount:billing:billing-readonly -> yes
kubectl auth can-i create pods -n billing --as=system:serviceaccount:billing:billing-readonly -> no
kubectl auth can-i get secrets -n billing --as=system:serviceaccount:billing:billing-readonly -> no

kubectl auth can-i get pods -n billing --as=system:serviceaccount:billing:billing-manager -> yes
kubectl auth can-i create pods -n billing --as=system:serviceaccount:billing:billing-manager -> yes
kubectl auth can-i get secrets -n billing --as=system:serviceaccount:billing:billing-manager -> no

kubectl auth can-i get secrets -A --as=system:serviceaccount:security:security-manager -> yes
```

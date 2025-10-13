#! /bin/bash

minikube start

kubectl apply -f task4/users.yml
kubectl apply -f task4/roles.yml
kubectl apply -f task4/bindings.yml

CMD1="kubectl auth can-i get pods -n billing --as=system:serviceaccount:billing:billing-readonly"
echo $CMD1 && echo $($CMD1)

CMD2="kubectl auth can-i create pods -n billing --as=system:serviceaccount:billing:billing-readonly"
echo $CMD2 && echo $($CMD2)

CMD3="kubectl auth can-i get secrets -n billing --as=system:serviceaccount:billing:billing-readonly"
echo $CMD3 && echo $($CMD3)

CMD7="kubectl auth can-i get pods -n billing --as=system:serviceaccount:billing:billing-manager"
echo $CMD7 && echo $($CMD7)

CMD8="kubectl auth can-i create pods -n billing --as=system:serviceaccount:billing:billing-manager"
echo $CMD8 && echo $($CMD8)

CMD9="kubectl auth can-i get secrets -n billing --as=system:serviceaccount:billing:billing-manager"
echo $CMD9 && echo $($CMD9)

CMD10="kubectl auth can-i get secrets -A --as=system:serviceaccount:security:security-manager"
echo $CMD10 && echo $($CMD10)


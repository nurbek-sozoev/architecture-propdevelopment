#! /bin/bash

echo "front-end -> back-end-api"
kubectl -n task5 exec -it front-end-app -- sh -lc "(curl -sS --max-time 1 http://back-end-api-app:80 >> /dev/null) && echo 'OPEN'"

echo "back-end-api -> front-end"
kubectl -n task5 exec -it back-end-api-app -- sh -lc "(curl -sS --max-time 1 http://front-end-app:80 >> /dev/null) && echo 'OPEN'"

echo "front-end -> admin-back-end-api"
kubectl -n task5 exec -it front-end-app -- sh -lc "(curl -sS --max-time 1 http://admin-back-end-api-app:80 >> /dev/null) || echo 'BLOCKED'"

echo "admin-front-end -> admin-back-end-api"
kubectl -n task5 exec -it admin-front-end-app -- sh -lc "(curl -sS --max-time 1 http://admin-back-end-api-app:80 >> /dev/null) && echo 'OPEN'"

echo "admin-back-end-api -> admin-front-end"
kubectl -n task5 exec -it admin-back-end-api-app -- sh -lc "(curl -sS --max-time 1 http://admin-front-end-app:80 >> /dev/null) && echo 'OPEN'"

echo "admin-front-end -> back-end-api"
kubectl -n task5 exec -it admin-front-end-app -- sh -lc "(curl -sS --max-time 1 http://back-end-api-app:80 >> /dev/null) || echo 'BLOCKED'"
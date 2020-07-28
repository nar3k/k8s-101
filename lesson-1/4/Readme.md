# Урок про Deployment

```
cd ../4/
```

## создаем неймспейс и сервис

```

kubectl apply -f 4-ns-svc.yaml

kubectl apply -f 4-deploy-v1.yaml
```
Запускаем запрос на v1  сервиса

```
kubectl run -i --tty busybox  -n deploy-ns --image=yauritux/busybox-curl --restart=Never -- sh
```
изнутри выполняем
```
while true; do curl deployment; done
```
в другой вкладке обновляем версию и наблюдаем как поменяется версия
```
kubectl apply -f 4-deploy-v2.yaml

watch kubectl get po -n deploy-ns
```
## дожидаемся  когда перейдет на v2

## откатываемся
```
kubectl rollout undo deployment kubia -n deploy-ns
```

#дожидаемся  когда перейдем на v1

выходим из busybox
```
exit
```

## удаляем ns с лабой
kubectl delete ns deploy-ns

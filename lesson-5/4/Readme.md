# Урок про Pod-AntiAffinity

```
cd ../4/
```

## создаем неймспейс и сервис

```

kubectl apply -f 4-ns-svc.yaml

kubectl apply -f 4-deploy-req.yaml
```
Запускаем в окне 1

```
watch kubectl get pods -n demo-ns -o wide -o=custom-columns=NAME:.metadata.name,node:.spec.nodeName
```

Видим что можем отдеплоить столько подов, сколько есть хостов.
А теперь поменяем обязательное условие на пожелание


```
kubectl delete -f 4-deploy-req.yaml
kubectl apply -f 4-deploy-prefer.yaml
```
Видим что подов стало больше




## удаляем ns с лабой

```
kubectl delete ns demo-ns
```

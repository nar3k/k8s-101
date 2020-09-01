# Урок про RollingUpdate

```
cd ../3/
```

## создаем неймспейс и сервис

```
kubectl apply -f 3-ns-svc.yaml

kubectl apply -f 3-deploy-v1.yaml
```

Запускаем в окне 1

```
watch kubectl get pods -n deploy-ns -o wide -o=custom-columns=NAME:.metadata.name,node:.spec.nodeName
```

В окне 2 выполняем

```
kubectl apply -f 3-deploy-v2.yaml
```

Видим, что поды добавляются по одному.


## Удалим namespace с лабой
```
kubectl delete ns deploy-ns
```

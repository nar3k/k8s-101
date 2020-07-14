# создаем неймспейс и сервис
```
kubectl apply -f 2-ns-svc.yaml
```
```
watch kubectl desribe svc nginx -n demo-ns
```
# создаем под с ошибкой
```
kubectl apply -f 2-po-mistake.yaml
```

# видим что в describe не появились endpoints

Чиним под
```
kubectl apply -f 2-po-correct.yaml
```

# видим что в describe  появились endpoints

# создаем busybox внутри дефолтного неймспейса
```
kubectl run -i --tty busybox  --image=yauritux/busybox-curl --restart=Never -- sh
```
выполняем изнутри запрос на сервис
```
curl nginx
```
и у нас ничего не получается

выходим
```
exit
```

# создаем busybox внутри неймспейса с сервисом
```
kubectl run -i --tty busybox -n demo-ns --image=yauritux/busybox-curl --restart=Never -- sh
```
выполняем изнутри запрос на сервис
```
curl nginx #success
```

запрос успешен

выходим
```
exit
```

# удаляем нейспейс
```
kubectl delete ns demo-ns
```

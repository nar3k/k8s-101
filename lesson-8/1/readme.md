#   Helm как package manager

```
cd ../1
```


Создадим chart из темлейта

```
helm create mychart
```
Посмотрим что там внутри и далее создадим чарт

```
helm install helm-test mychart/
helm ls
```

Уже 2 чарта

Давайте посмотрим что создалось

```
kubectl get all --show-labels
```

Добавим автоскейлинг приложению руками.
Сначала посмотрим как его включить

```
cat mychart/templates/hpa.yaml
cat mychart/values.yaml
```

ПОсмотрим чем отличаются манифесты с включенным и выключенным автоскейлингом

helm upgrade  helm-test mychart/ --dry-run

helm upgrade --set autoscaling.enabled=true helm-test mychart/

видим что тут

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

```
helm upgrade  helm-test mychart/ --dry-run

helm upgrade --set autoscaling.enabled=true helm-test mychart/
```

видим что тут появился HPA
```
# Source: mychart/templates/hpa.yaml
apiVersion: autoscaling/v2beta1
kind: HorizontalPodAutoscaler
metadata:
  name: helm-test-mychart
  labels:
    helm.sh/chart: mychart-0.1.0
    app.kubernetes.io/name: mychart
    app.kubernetes.io/instance: helm-test
    app.kubernetes.io/version: "1.16.0"
    app.kubernetes.io/managed-by: Helm
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: helm-test-mychart
  minReplicas: 1
  maxReplicas: 100
  metrics:
    - type: Resource
      resource:
        name: cpu
        targetAverageUtilization
```

создадим

```
helm upgrade --set autoscaling.enabled=true helm-test mychart/
```

Но это не очень красиво, особенно когда нужно передать много переменных. Давайте попробуем передать сложный конфиг





```
helm upgrade --values new-values.yaml helm-test mychart/ --dry-run
```

видим что тут появился ingress ( и остался HPA)



```
helm upgrade --values new-values.yaml helm-test mychart/
kubectl get deploy,hpa,ingress,svc
```

Закончим лабу
```
helm uninstall helm-test
helm uninstall nginx-ingress
kubectl delete all --all
rm -rf mychart/
```

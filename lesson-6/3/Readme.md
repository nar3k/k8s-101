## HorizontalPodAutoscaler
```
cd ../3/
```

Создадим ns и limitRange  :

```sh
kubectl apply -f 03-ns-limitRange.yaml
```

Создадим deployment и HPA

```sh
kubectl apply -f 03-dep-hpa.yaml
```

Запустим в окне

```sh
watch kubectl get pod,svc,hpa -n demo-ns
```

Посылаем curl по IP адресу балансера

```sh
URL=$(kubectl get svc nginx -n demo-ns -o json | jq -r .status.loadBalancer.ingress[0].ip)
while true; do wget -q -O- http://$URL; done
```
Отпустим нагрузку


Ждем когда деплоймент смаштабируется вверх и порадуемся

Посмотрим лог

```sh
kubectl describe horizontalpodautoscaler.autoscaling/nginx -n demo-ns
```

```sh
Conditions:
  Type            Status  Reason               Message
  ----            ------  ------               -------
  AbleToScale     True    ScaleDownStabilized  recent recommendations were higher than current one, applying the highest recent recommendation
  ScalingActive   True    ValidMetricFound     the HPA was able to successfully calculate a replica count from cpu resource utilization (percentage of request)
  ScalingLimited  True    TooManyReplicas      the desired replica count is more than the maximum replica count
  ```


  ## Переходим к следущей лабе

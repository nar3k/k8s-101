#  Probes

```
cd lesson-6/1
```

Создадим deployment с пробами:

```sh
kubectl apply -f 01-dep.yaml
```

Запустим в фоне поиск по приложению
```
watch kubectl describe svc -n demo-ns
```

Посылаем curl по IP адресу балансера

```
URL=$(kubectl get svc probe -n demo-ns -o json | jq -r .status.loadBalancer.ingress[0].ip)
curl $URL/healthz
```


1) сначала он не будет приходить ( потому что нода не стала еще ready )
2) через 30 секунд в Endpoints появятся узлы и запросы начнут приходить
3) через минуту запросы перестанут приходить совсем и ноды продадут из endpoint

4) заглянем в логи что случилось

```
kubectl describe po -n demo-ns
```

Увидим сообщения о проблемах со readyness probe


Удалим лабу

```
kubectl delete -f 01-dep.yaml
```

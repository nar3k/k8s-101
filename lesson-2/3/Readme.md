# Урок про Load Balancer

```
cd ../3/
```

## Создаем  тестовый namespace и деплоймент
```sh
kubectl apply -f 3-ns-po.yaml  
```

## сделаем сервис с типом load-balancer
```sh
kubectl apply -f 3-svc-default.yaml  

```

## вытаскиваем IP адрес созданного Service , и тип ( Cluster) д

```sh
$ kubectl describe service/nginx -n demo-ns | grep -e 'LoadBalancer Ingress:' -e 'External Traffic Policy:'
LoadBalancer Ingress:     178.154.246.204
External Traffic Policy:  Cluster
```

Делаем тестовый запрос ( у вас будет свой адрес)

```sh
$ curl 178.154.246.204
<!DOCTYPE html>
<html>
<head>
```
## посмотрим в логи

```sh
$ kubectl logs -n demo-ns pod/nginx
10.100.0.36 - - [28/Jul/2020:12:14:12 +0000] "GET / HTTP/1.1" 200 612 "-" "curl/7.54.0" "-"
```
10.100.0.36 это IP адрес одной из нод

```sh
$ kubectl get nodes -o wide | grep 10.100.0.36
cl197hq2nt1jltu5tmuc-yjyf   Ready    <none>   110m   v1.16.6-1+a69a9f20ae9b5d   10.100.0.36   130.193.50.15    Ubuntu 18.04.3 LTS   4.15.0-55-generic   docker://18.6.2
```

## меняем External Traffic Policy на Local

```sh
kubectl apply -f 3-svc-local.yaml  

```


```sh
$ kubectl describe service/nginx -n demo-ns | grep -e 'LoadBalancer Ingress:' -e 'External Traffic Policy:'
LoadBalancer Ingress:     178.154.246.204
External Traffic Policy:  Local
```

Делаем тестовый запрос

```sh
nrkk-osx:2 nrkk$ curl 178.154.246.204
<!DOCTYPE html>
<html>
<head>
```
## посмотрим в логи

```sh
$ kubectl logs -n demo-ns pod/nginx
37.204.229.220 - - [28/Jul/2020:12:25:59 +0000] "GET / HTTP/1.1" 200 612 "-" "curl/7.54.0" "-"
```
37.204.229.220 это IP адрес одной из нод

```sh
$ curl -4 ifconfig.io #Надо без нашего VPN делать
37.204.229.220
```

## удаляем нейспейс
```sh
kubectl delete ns demo-ns
```

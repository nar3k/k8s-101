# Урок про nginx ingress controller

## Установим Helm

https://helm.sh/docs/intro/install/#from-homebrew-macos

## Устаноим nginx ingress contoller

```sh
helm repo add nginx-stable https://helm.nginx.com/stable
helm repo update
helm install nginx-ingress nginx-stable/nginx-ingress
```

## Установим наше тестовое приложение ( ns + pod + service )

```sh
kubectl apply -f 4-ns-po.yaml
```

## Установим ingress ресурс

```yaml
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: nginx
  annotations:
    kubernetes.io/ingress.class: "nginx"
  namespace: demo-ns
spec:
  rules:
  - host: nginx-first.example.com
    http:
      paths:
      - backend:
          serviceName: nginx
          servicePort: 80
        path: /
```

```sh
kubectl apply -f 4-ingress.yaml
```

## Сделаем запросы с локальной машины

Вычислим адрес INGRESS
```sh
$ kubectl describe svc nginx-ingress-nginx-ingress | grep -e 'LoadBalancer Ingress:' -e 'External Traffic Policy:'
LoadBalancer Ingress:     178.154.247.129
External Traffic Policy:  Local
```

Запрос без hostname выдаст 404

```sh
nrkk-osx:2 nrkk$ curl 178.154.247.129
<html>
<head><title>404 Not Found</title></head>
<body>
```

Запрос с hostname  nginx-first.example.com выдаст нам наш pod

```sh
$ curl -H "Host: nginx-first.example.com" http://178.154.247.129/
<!DOCTYPE html>
<html>
```

## Посмотрим логи - чтобы увидеть datapath

### Сначала на ingress

```sh
$ kubectl get po
NAME                                          READY   STATUS    RESTARTS   AGE
nginx-ingress-nginx-ingress-7ff4fd9bb-kzkqp   1/1     Running   0          12m
```

```sh
$ kubectl logs nginx-ingress-nginx-ingress-7ff4fd9bb-kzkqp

37.204.229.220 - - [28/Jul/2020:12:54:34 +0000] "GET / HTTP/1.1" 200 612 "-" "curl/7.54.0" "-"
```
37.204.229.220 - это ваш IP адрес

### Теперь в POD

```sh
$ kubectl logs -n demo-ns pod/nginx

10.160.0.165 - - [28/Jul/2020:12:54:34 +0000] "GET / HTTP/1.1" 200 612 "-" "curl/7.54.0" "37.204.229.220"
```

10.160.0.165 - это IP адрес POD ingres
```sh
$ kubectl get po -o wide
NAME                                          READY   STATUS    RESTARTS   AGE   IP             NODE                        NOMINATED NODE   READINESS GATES
nginx-ingress-nginx-ingress-7ff4fd9bb-kzkqp   1/1     Running   0          14m   10.160.0.165   cl197hq2nt1jltu5tmuc-yjyf   <none>           <none>
```

## Удалим лабу

```sh

kubectl delete ns demo-ns

helm uninstall nginx-ingress
```

# Network-policy

```
cd 1/
```

Пример

Есть 3 namespace - `default`, `prod`, `dev`. Мы хотим чтобы поды из namespace `prod` могли ходить в наше приложение, которое развернуто в namespace `default`, а из `dev` соотвестенно не могли


Развернем веб сервер в  default (kubectl версии < 1.18):
```sh
kubectl run --generator=run-pod/v1 web --image=nginx --labels=app=web --expose --port 80
```
Для kubectl версии ≥1.18:
```sh
kubectl run web --image=nginx --labels=app=web --expose --port 80
```

Создадим  `prod` , `dev` неймпейсы:

```sh
kubectl create namespace dev
kubectl label namespace/dev purpose=testing
```

```sh
kubectl create namespace prod
kubectl label namespace/prod purpose=production
```



### Попробуем

Сделаем запрос  из `dev` он  пройдет:

```sh
$ kubectl run --generator=run-pod/v1 test-$RANDOM --namespace=dev --rm -i -t --image=alpine -- sh
If you dont see a command prompt, try pressing enter.
/ # wget -qO- --timeout=2 http://web.default
<!DOCTYPE html>
<html>
<head>
```

```
exit
```

Запустим файлик с network policy ( 01-web-allow-prod.yaml )

```yaml
kind: NetworkPolicy
apiVersion: networking.k8s.io/v1
metadata:
  name: web-allow-prod
spec:
  podSelector:
    matchLabels:
      app: web
  ingress:
  - from:
    - namespaceSelector:
        matchLabels:
          purpose: production
```

```sh
$ kubectl apply -f 01-web-allow-prod.yaml
networkpolicy "web-allow-prod" created
```


Сделаем запрос  из `dev` он  не пройдет:

```sh
$ kubectl run --generator=run-pod/v1 test-$RANDOM --namespace=dev --rm -i -t --image=alpine -- sh
If you dont see a command prompt, try pressing enter.
/ # wget -qO- --timeout=2 http://web.default
wget: download timed out
(traffic blocked)

```

Сделаем запрос  из `prod` он  пройдет:

```sh
$ kubectl run --generator=run-pod/v1 test-$RANDOM --namespace=prod --rm -i -t --image=alpine -- sh
If you don't see a command prompt, try pressing enter.
/ # wget -qO- --timeout=2 http://web.default
<!DOCTYPE html>
<html>
<head>
...
(traffic allowed)
```

### Закончим

    kubectl delete networkpolicy web-allow-prod
    kubectl delete pod web
    kubectl delete service web
    kubectl delete namespace {prod,dev}

### Много примеров тут

https://github.com/ahmetb/kubernetes-network-policy-recipes

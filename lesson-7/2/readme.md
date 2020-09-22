#  пользователь из iam

```
cd ../2
```

Запустим сначала под с дефолтным SA

```
kubectl apply -f 02-pod-default-sa.yaml
```

Обратим внимание что к поду примонтирован дефолтный секрет SA


```

kubectl get po curl -o yaml

apiVersion: v1
kind: Pod
...
spec:
  containers:
  - image: yauritux/busybox-curl
    ...
    volumeMounts:
    - mountPath: /var/run/secrets/kubernetes.io/serviceaccount
      name: default-token-b9xbs
      readOnly: true
..
  volumes:
  - name: default-token-b9xbs
    secret:
      defaultMode: 420
      secretName: default-token-b9xbs
...

```

Зайдем в под и попробуем с него поделать запросы в kubernetes api

```
kubectl exec -ti curl -- sh
apk add curl
```

без токена совсем
```
curl https://kubernetes/api/v1 --insecure
{
  "kind": "Status",
  "apiVersion": "v1",
  "metadata": {

  },
  "status": "Failure",
  "message": "forbidden: User \"system:anonymous\" cannot get path \"/api/v1\"",
  "reason": "Forbidden",
  "details": {

  },
  "code": 403
```

c дефолтным токеном уже лучше

```
TOKEN=$(cat /run/secrets/kubernetes.io/serviceaccount/token)
/ # curl -H “Authorization: Bearer $TOKEN” https://kubernetes/api/v1/ --insecure
Создадим SA внутри кластера k8s и сделаем его админом  :
```
Но например нельзя листить поды

```
curl -H "Authorization: Bearer $TOKEN" https://kubernetes/api/v1/namespaces/default/pods/ --insecure
{
  "kind": "Status",
  "apiVersion": "v1",
  "metadata": {

  },
  "status": "Failure",
  "message": "pods is forbidden: User \"system:serviceaccount:default:default\" cannot list resource \"pods\" in API group \"\" in the namespace \"default\"",
  "reason": "Forbidden",
  "details": {
    "kind": "pods"
  },
  "code": 403

```

Давайте создадим новый SA ( админ ) и под с ним

```
kubectl apply -f 02-sa.yaml
kubectl apply -f 02-pod-admin-sa.yaml
```

Зайдем в под и попробуем с него поделать запросы в kubernetes api

```
kubectl exec -ti curl-admin -- sh
apk add curl
```

Теперь мы можем листить поды

```
TOKEN=$(cat /run/secrets/kubernetes.io/serviceaccount/token)
curl -H "Authorization: Bearer $TOKEN" https://kubernetes/api/v1/namespaces/default/pods/ --insecure
```

Завершим лабу

```
kubectl delete all --all
```

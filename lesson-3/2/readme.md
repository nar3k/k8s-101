# PVC

```
cd ../2/
```

Создадим  `PVC ` и под c nginx   :

Используем storageClass

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: pvc-dynamic
  namespace: demo-ns
spec:
  accessModes:
    - ReadWriteOnce
  storageClassName: yc-network-ssd
  resources:
    requests:
      storage: 16Gi
```

POD
```yaml
---
apiVersion: v1
kind: Pod
metadata:
  name: nginx
  namespace: demo-ns
  labels:
    app: nginx
spec:
  containers:
  - name: nginx
    image: nginx
    volumeMounts:
    - name: persistent-storage
      mountPath: /usr/share/nginx/html
  volumes:
  - name: persistent-storage
    persistentVolumeClaim:
      claimName:  pvc-dynamic
```

```sh
kubectl apply -f 02-ns-pvc.yaml

kubectl apply -f 02-pod-svc.yaml

watch kubectl get all -n demo-ns #мы не увидим PV

SVC_IP=<ADDRESS> #сюда запишите свой адрес

curl $SVC_IP

```

###

Поменяем  `содержимое nginx ` :

```sh

kubectl exec -it nginx -n demo-ns bash

echo "test" >  /usr/share/nginx/html/index.html

kubectl delete po/nginx -n demo-ns

```

Удалим и перестартуем pod  :


```sh
kubectl delete po/nginx -n demo-ns

kubectl apply -f 02-pod-svc.yaml

curl $SVC_IP #видим test , который записали на диск

```


Очистим лабу

```sh
 kubectl delete ns demo-ns
 ```

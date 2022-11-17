# NFS

```
cd ../3/
```

Создадим  storageClass   :

```sh
helm repo add stable https://charts.helm.sh/stable

helm install nfs stable/nfs-server-provisioner --set=persistence.enabled=True,persistence.size=33Gi,persistence.storageClass='yc-network-ssd'


watch kubectl get po,svc,pvc,pv  


```

###

Поменяем  `запустим пару подов с общим storage ` :

```sh

kubectl apply -f 03-ns-pvc.yaml
kubectl apply -f 03-pod-svc.yaml

watch kubectl get po,svc,pvc  -n demo-ns

SVC_IP=<ADDRESS> #сюда запишите свой адрес

for i in $(seq 1 10); do curl $SVC_IP ;done

```

Вылечим поды  :


```sh
kubectl exec -it nfs-nfs-server-provisioner-0 bash

 ls -l /export/

echo "test" > /export/pvc-0e53727f-9a06-4a4d-b32a-576076176a62/index.html

exit

for i in $(seq 1 10); do curl $SVC_IP ;done

```


Очистим лабу

```sh
 kubectl delete ns demo-ns
 helm uninstall nfs
 kubectl delete pvc data-nfs-nfs-server-provisioner-0

```

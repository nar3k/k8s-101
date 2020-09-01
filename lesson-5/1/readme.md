#  Pod Distruption Budget
```
cd lesson-5/1
```

Создадим  deployment c 10 nginx :

```sh
kubectl apply -f 01-dep.yaml
```


Найдем ноду, на которой несколько подов и задрейним ее

Окно 1
```sh
watch kubectl get po -o wide -n demo-ns -o=custom-columns=NAME:.metadata.name,node:.spec.nodeName
```

Окно 2
```sh
kubectl drain cl14607bcn1714k4v3im-ixif --ignore-daemonsets --delete-local-data --force=True
```

Увидим что все уехало пачкой

```
$ kubectl drain cl14607bcn1714k4v3im-ixif --ignore-daemonsets --delete-local-data --force=True
WARNING: the server could not find the requested resource: calico-node-ngpbz, ip-masq-agent-gcrmr, kube-proxy-nklzl, npd-v0.8.0-zjjg2, yc-disk-csi-node-v2-7vdqn
pod/calico-node-ngpbz evicted
pod/yc-disk-csi-node-v2-7vdqn evicted
pod/nginx-58b77f84b5-4s46l evicted
pod/ip-masq-agent-gcrmr evicted
pod/kube-proxy-nklzl evicted
pod/nginx-58b77f84b5-d6trj evicted
pod/nginx-58b77f84b5-mq5qj evicted
pod/npd-v0.8.0-zjjg2 evicted
node/cl14607bcn1714k4v3im-ixif evicted
```

Вернем ноду на место

```sh
kubectl uncordon cl14607bcn1714k4v3im-ixif
```

Создадим PodDistruptionBudget



```sh
kubectl apply -f 01-pdb.yaml
```

Найдем ноду, на которой несколько подов и задрейним ее


Окно 1
```sh
watch kubectl get po -o wide -n demo-ns -o=custom-columns=NAME:.metadata.name,node:.spec.nodeName
```

Окно 2
```sh
kubectl drain cl14607bcn1714k4v3im-ixif --ignore-daemonsets --delete-local-data --force=True
```

Увидим что появились сообщения о том что eviction делать нельзя

```
$ kubectl drain cl14607bcn1714k4v3im-ahyn --ignore-daemonsets --delete-local-data --force=True
node/cl14607bcn1714k4v3im-ahyn cordoned
WARNING: the server could not find the requested resource: calico-node-wqspc, ip-masq-agent-dl5hp, kube-proxy-df4fs, npd-v0.8.0-2k242, yc-disk-csi-node-v2-jzr9p
pod/calico-node-wqspc evicted
error when evicting pod "nginx-58b77f84b5-rzgq8" (will retry after 5s): Cannot evict pod as it would violate the pod's disruption budget.
error when evicting pod "nginx-58b77f84b5-g8q8v" (will retry after 5s): Cannot evict pod as it would violate the pod's disruption budget.
pod/yc-disk-csi-node-v2-jzr9p evicted
pod/ip-masq-agent-dl5hp evicted
error when evicting pod "nginx-58b77f84b5-g8q8v" (will retry after 5s): Cannot evict pod as it would violate the pod's disruption budget.
pod/npd-v0.8.0-2k242 evicted
pod/kube-proxy-df4fs evicted
pod/nginx-58b77f84b5-vhtzs evicted
pod/nginx-58b77f84b5-rzgq8 evicted
pod/nginx-58b77f84b5-g8q8v evicted
node/cl14607bcn1714k4v3im-ahyn evicted
$ kubectl uncordon cl14607bcn1714k4v3im-ahyn
```


Вернем ноду на место

```sh
kubectl uncordon cl14607bcn1714k4v3im-ixif
```

Закончим лабу

```
kubectl delete ns demo-ns
```

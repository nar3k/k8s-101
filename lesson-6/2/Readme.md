
```
cd ../2/
```

Создадим deployment c реквестами и лимитами:

```sh
kubectl apply -f 02-dep.yaml
```

посмотрим на какой ноде запустилось приложение

```
NODENAME=$(kubectl get po -o wide -n demo-ns -o=custom-columns=NAME:.metadata.name,node:.spec.nodeName -o json | jq -r .items[0].spec.nodeName)
kubectl describe node $NODENAME
```

Увидим overommit

```
Allocated resources:
  (Total limits may be over 100 percent, i.e., overcommitted.)
  Resource           Requests    Limits
  --------           --------    ------
  cpu                660m (16%)  50800m (1295%)
  memory             196Mi (7%)  103100Mi (3801%)
  ephemeral-storage  0 (0%)      0 (0%)
Events:              <none>
```

Посмотрим соседнюю ноду

```
$ kubectl get nodes
NAME                        STATUS   ROLES    AGE    VERSION
cl14607bcn1714k4v3im-ahyn   Ready    <none>   13d    v1.17.8

$ kubectl describe node cl14607bcn1714k4v3im-ahyn
```
В ней нет overcommit

```
Allocated resources:
  (Total limits may be over 100 percent, i.e., overcommitted.)
  Resource           Requests    Limits
  --------           --------    ------
  cpu                610m (15%)  800m (20%)
  memory             132Mi (4%)  700Mi (25%)
  ephemeral-storage  0 (0%)      0 (0%)
```


Удалим лабу

```
kubectl delete -f 02-dep.yaml
```

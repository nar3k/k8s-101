# Gatekeeper

```
cd ../3
```

Установим Gatekeeper

```
kubectl apply -f https://raw.githubusercontent.com/open-policy-agent/gatekeeper/master/deploy/gatekeeper.yaml

```


Создадим темлейт для запрета использования privileged контейнеров

```
kubectl apply -f https://raw.githubusercontent.com/open-policy-agent/gatekeeper-library/master/library/pod-security-policy/privileged-containers/template.yaml
```

 Применим его на один неймпейс demo-ns


 ```

 kubectl apply -f 03-constraint.yaml

 ```

 Попробуем создать привилигированны под

 ```
 kubectl apply -f 03-bad-pod.yaml
 Error from server ([denied by psp-privileged-container] Privileged container is not allowed: nginx, securityContext: {"privileged": true}): error when creating "03-bad-pod.yaml": admission webhook "validation.gatekeeper.sh" denied the request: [denied by psp-privileged-container] Privileged container is not allowed: nginx, securityContext: {"privileged": true}

 ```

 Попробуем создать деплоймент. Обратите внимание что деплоймент создался, но поды он создать не может



```
NAME                               READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/nginx-deployment   0/3     0            0           7s

NAME                                          DESIRED   CURRENT   READY   AGE
replicaset.apps/nginx-deployment-7884d85b4d   3         0         0       7s
```

```
kubectl describe rs
Name:           nginx-deployment-7884d85b4d
Namespace:      default
...
Events:
  Type     Reason        Age                From                   Message
  ----     ------        ----               ----                   -------
  Warning  FailedCreate  7s (x14 over 48s)  replicaset-controller  Error creating: admission webhook "validation.gatekeeper.sh" denied the request: [denied by psp-privileged-container] Privileged container is not allowed: nginx, securityContext: {"privileged": true}
```

Создадим хороший деплоймент и убедимся что он заработал

```
kubectl apply -f 03-good-deploy.yaml
kubectl get all

```



Удалим лабу

```
kubectl delete all --all
kubectl delete -f 03-constraint.yaml
kubectl delete -f https://raw.githubusercontent.com/open-policy-agent/gatekeeper-library/master/library/pod-security-policy/privileged-containers/template.yaml
kubectl delete -f https://raw.githubusercontent.com/open-policy-agent/gatekeeper/master/deploy/gatekeeper.yaml
```

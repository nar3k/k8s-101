## ClusterAutoScaler
```
cd ../4/
```

### Выполним лабу 3

Убедимся что у нас есть кластер с автоскейлингом  

Удалим HPA

```sh
kubectl delete horizontalpodautoscaler.autoscaling/nginx -n demo-ns
```

Посмотрим что у нас изначально 2 узла

Увидим что и узлов прибавилось

```sh
nrkk-osx:4 nrkk$ kubectl get nodes
NAME                        STATUS   ROLES    AGE   VERSION
cl1a8efj57gn5ccs1gfv-iwuw   Ready    <none>   74s   v1.17.8
cl1a8efj57gn5ccs1gfv-okic   Ready   
```

Создадим deployment с 10 копиями

```sh
kubectl apply -f 04-dep.yaml
```

Найдем под в статусе Pending


```sh
$ kubectl get po -n demo-ns
NAME                    READY   STATUS    RESTARTS   AGE
nginx-fb59c6944-2ppgl   0/1     Pending   0          4s
```

Заглянем в его лог

```sh
nrkk-osx:4 nrkk$ kubectl describe po nginx-fb59c6944-525nm -n demo-ns
```

```sh

Events:
  Type     Reason            Age                   From                                Message
  ----     ------            ----                  ----                                -------
  Normal   TriggeredScaleUp  2m48s                 cluster-autoscaler                  pod triggered scale-up: [{catt4okekqmpj8pn90ei 1->3 (max: 3)}]
  Warning  FailedScheduling  113s (x3 over 2m54s)  default-scheduler                   0/4 nodes are available: 4 Insufficient pods.
  Warning  FailedScheduling  32s (x3 over 37s)     default-scheduler                   0/5 nodes are available: 1 node(s) had taints that the pod didn't tolerate, 4 Insufficient pods.
  Warning  FailedScheduling  19s (x3 over 28s)     default-scheduler                   0/6 nodes are available: 2 node(s) had taints that the pod didn't tolerate, 4 Insufficient pods.
  Normal   Scheduled         8s                    default-scheduler                   Successfully assigned demo-ns/nginx-fb59c6944-525nm to cl1a8efj57gn5ccs1gfv-iwuw
  Normal   Pulling           6s                    kubelet, cl1a8efj57gn5ccs1gfv-iwuw  Pulling image "k8s.gcr.io/hpa-example"
```

Увидим что и узлов прибавилось

```sh
nrkk-osx:4 nrkk$ kubectl get nodes
NAME                        STATUS   ROLES    AGE   VERSION
cl1a8efj57gn5ccs1gfv-iwuw   Ready    <none>   74s   v1.17.8
cl1a8efj57gn5ccs1gfv-okic   Ready    <none>   79s   v1.17.8
cl1a8efj57gn5ccs1gfv-ujiq   Ready    <none>   42m   v1.17.8
cl1fu7golamsfv2f3to0-axen   Ready    <none>   20m   v1.17.8
cl1fu7golamsfv2f3to0-ojeh   Ready    <none>   43m   v1.17.8
cl1fu7golamsfv2f3to0-upum   Ready    <none>   12m   v1.17.8
```
Удалим Лабу

```sh
kubectl delete ns demo-ns
```

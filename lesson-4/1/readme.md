# Deployment и PVC
```
cd lesson-4/1
```

Создадим  pvc  и deployment c nginx   :

```sh

kubectl apply -f 01-ns-pvc.yaml
kubectl apply -f 01-dep.yaml
```

Заглянем в pod и запишем в него файлик
```sh
kubectl get po -n demo-ns
kubectl exec -it nginx-<HASH> /bin/bash -n demo-ns
```
внутри пода выполним сначала

```sh
curl localhost
```
Получим 403 ( потому что файлика index.html нету)

запишем файлик index.html
```
echo "test" >  /usr/share/nginx/html/index.html
curl localhost # успешно выдаст нам test
```

удалим deployment и пересоздадим заново

```
kubectl delete -f 01-dep.yaml
kubectl apply -f 01-dep.yaml
kubectl get po -n demo-ns
kubectl exec -it nginx-<HASH> /bin/bash -n demo-ns
curl localhost # успешно выдаст test
```

Деплоймент пересоздался , а диск с данным остался. Те в целом можно single host сервисы поднимать и в deployment ( например базы) и ничего страшного  не будет.

Но проблемы начинаются когда мы скейлим такой deployment   
```sh
kubectl scale deployment nginx --replicas=2 -n demo-ns
```

наблюдаем такую картинку

```sh
nrkk-osx:1 nrkk$ kubectl get po -n demo-ns
NAME                    READY   STATUS              RESTARTS   AGE
nginx-5984b8457-88qzg   1/1     Running             0          35m
nginx-5984b8457-s5blg   0/1     ContainerCreating   0          33m
```

```sh
nrkk-osx:1 nrkk$ kubectl describe po nginx-5984b8457-s5blg -n demo-ns
...
  Warning  FailedAttachVolume  33m                   attachdetach-controller             Multi-Attach error for volume "pvc-4ff05376-46e2-4f34-9caa-2e67e387cc46" Volume is already used by pod(s) nginx-5984b8457-88qzg
```

Второй Pod пытается прицепить тот же PVC и у него ожидаемо ничего не получается ( ведь он ReadWriteOnce)

Чистим лабу чтобы двинутся дальше

```sh
kubectl delete ns demo-ns
```

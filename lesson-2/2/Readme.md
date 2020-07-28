# Урок про Service

```
cd ../2/
```




## создаем неймспейс
```
kubectl create namespace demo-ns
```

## пытаемся внутри нейспейса постучатся в несуществующий сервис
```sh
kubectl run -i --tty busybox  -n demo-ns --image=yauritux/busybox-curl --restart=Never   
/home # curl nginx
curl: (6) Couldnt resolve host nginx.demo-ns
/home # curl nginx.demo-ns
curl: (6) Couldnt resolve host nginx.demo-ns
```
Обращаем внимание - когда нет сервиса , он не резолвится ни по каким именам  


## сделаем сервис без подов ( endpoints)
```
kubectl apply -f 2-svc.yaml
```

## видим что в describe не появились endpoints

```sh
$ kubectl describe service/nginx -n demo-ns | grep Endpoints
Endpoints:         <none>
```
## пытаемся внутри нейспейса постучатся в  сервис без пода

```sh
/home # wget -qO- --timeout=2 http://nginx.demo-ns.svc.cluster.local
wget: download timed out
/home # wget -qO- --timeout=2 http://nginx
wget: download timed out
```

Обращаем внимание - когда есть сервиса , но нету pods то мы видим таймауты ( как в network-policy ) или иногда connection refused

## добавим под в сервис
```
kubectl apply -f 2-pod.yaml
```


## видим что в describe  появились endpoints
```sh
nrkk-osx:2 nrkk$ kubectl describe service/nginx -n demo-ns | grep Endpoints

Endpoints:         10.160.0.152:80
```

## пытаемся внутри нейспейса постучатся c  подом и у нас все хорошо

```sh
/home # wget -qO- --timeout=2 http://nginx.demo-ns
<!DOCTYPE html>
<html>
<head>
```

## удаляем нейспейс
```
kubectl delete ns demo-ns
```

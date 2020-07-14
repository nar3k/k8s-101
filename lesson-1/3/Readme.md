# Урок про ReplicaSet


```
cd ../3/
```

## создаем под
```
kubectl apply -f 3-nginx-rs.yaml
```
## cмотрим на статус
```
watch kubectl get po  -o wide
watch kubectl get rs
```
## удаляем ноду в которой есть под

## Pod пропал и но ReplicaSet его восстановит

завершаем лабу
```
kubectl delete rs nginx
```

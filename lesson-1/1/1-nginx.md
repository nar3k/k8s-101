# создаем под
```
kubectl apply -f 1-nginx.yaml
```
# cмотрим на статус ( в двух вкладках)
```
watch kubectl get po  -o wide
watch kubectl get node  -o wide
```
# удаляем ноду в которой есть под

# pod пропал но мы не грустим, а двигаемся дальше .

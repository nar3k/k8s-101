#создаем под

kubectl apply -f 3-nginx-rs.yaml

#cмотрим на статус

watch kubectl get po  -o wide
watch kubectl get rs

#удаляем ноду в которой есть под

#под пропал и но rs его восстановит

kubectl delete rs nginx

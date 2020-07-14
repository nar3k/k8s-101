#создаем под

kubectl apply -f 1-nginx.yaml

#cмотрим на статус

watch kubectl get po  -o wide
watch kubectl get node  -o wide

#удаляем ноду в которой есть под

#под пропал и мы грустим

kubectl delete deploy nginx

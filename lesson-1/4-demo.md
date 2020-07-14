kubectl apply -f 4-ns-svc.yaml

kubectl apply -f 4-deploy-v1.yaml

kubectl run -i --tty busybox  -n deploy-ns --image=yauritux/busybox-curl --restart=Never -- sh
#изнутри

while true; do curl deployment; done

#в другой вкладке

kubectl apply -f 4-deploy-v2.yaml

watch kubectl get po -n deploy-ns

#дожидаемся  когда перейдем на v2

#откатываемся

kubectl rollout undo deployment kubia -n deploy-ns

#дожидаемся  когда перейдем на v1
#удоляем
kubectl delete ns deploy-ns

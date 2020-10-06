#  SA для NS

```
cd ../2
```
Вытащим ID кластера ( пригодится позже)

```
yc managed-kubernetes cluster list
$ CLUSTER_ID=cateqfn1s7fupiu9bo48
```
Вытащим CA сертификат кластера

```
yc managed-kubernetes cluster get --id $CLUSTER_ID --format json | \
    jq -r .master.master_auth.cluster_ca_certificate | \
    awk '{gsub(/\\n/,"\n")}1' > ca.pem
```

Создадим SA - админа кластера

```
kubectl create -f sa.yaml
```
Вытащим его токен для аутентификации
```
SA_TOKEN=$(kubectl -n kube-system get secret $(kubectl -n kube-system get secret | \
    grep admin-user | \
    awk '{print $1}') -o json | \
    jq -r .data.token | \
    base64 --d)



```

Найдем адрес мастера


```
MASTER_ENDPOINT=$(yc managed-kubernetes cluster get --id $CLUSTER_ID \
    --format json | \
    jq -r .master.endpoints.external_v4_endpoint)
echo $MASTER_ENDPOINT
```

создадим файлик конфигурации

```
kubectl config set-cluster sa-test2 \
               --certificate-authority=ca.pem \
               --server=$MASTER_ENDPOINT \
               --kubeconfig=test.kubeconfig
```

добавим в него кредсы

```
kubectl config set-credentials admin-user \
                --token=$SA_TOKEN \
                --kubeconfig=test.kubeconfig
```

добавим в него кластер

```
kubectl config set-context default \
               --cluster=sa-test2 \
               --user=admin-user \
               --kubeconfig=test.kubeconfig
```

сделаем этот контекст дефолтным в этом файле

```
kubectl config use-context default \
               --kubeconfig=test.kubeconfig
```

заглянем в кластер

```
kubectl get namespace --kubeconfig=test.kubeconfig
```

Почистим лабу

```
rm ca.pem
rm test.kubeconfig
```

и на последок

изменим неймспейс текущего контекста

```
kubectl config current-context
kubectl config set-context --current --namespace=kube-system
kubectl get all
kubectl config set-context --current --namespace=default
```

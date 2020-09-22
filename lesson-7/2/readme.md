#  пользователь из iam

```
cd lesson-7/1
```

Создадим в нашем фолдере SA и не будем давать ему никаких ролей :

```sh
yc iam service-account create --name=k8s-sa-user
```

Вытащим его id ( он пригодится дальше)

```sh
yc iam service-account get --name=k8s-sa-user --format=json | jq -r .id
c resource-manager folder add-access-binding --service-account-name=k8s-sa-user --role=viewer --id=$( yc config get folder-id)
```

Создадим yc профиль с этим sa

```sh
yc iam key create --service-account-name=k8s-sa-user --output=sa-key.json
yc config get cloud-id # используем для нового профиля
yc config get folder-id # используем для нового профиля
yc config create k8s-sa-user
yc config set service-account-key sa-key.json
yc config set cloud-id <cloud-id>
yc config set folder-id <folder-id>
```

Создадим профиль для такого пользователя

```sh
kubectl config current-context # запомним , пригодится дальше
yc managed-kubernetes cluster get-credentials  --context-name=k8s-sa --id cateqfn1s7fupiu9bo48 --profile=k8s-sa-user --force --external
```
попробуем залистить ноды

и у нас ничего не выйдет

```sh
kubectl get nodes
Error from server (Forbidden): nodes is forbidden: User "ajejaknpv691pncogst5" cannot list resource "nodes" in API group "" at the cluster scope
```
дадим ролей внутри кластера

```sh
yc managed-kubernetes cluster get-credentials  --context-name=k8s-sa --id cateqfn1s7fupiu9bo48 --profile=prod --force --external

```
заполним в файле id 01-CRB.yaml id SA в поле user и применим

```
kubectl apply -f 01-CRB.yaml

yc managed-kubernetes cluster get-credentials  --context-name=k8s-sa --id cateqfn1s7fupiu9bo48 --profile=k8s-sa-user --force --external

```

Теперь все получается
```
$ kubectl get nodes
NAME                        STATUS   ROLES    AGE     VERSION
cl1a8efj57gn5ccs1gfv-ujiq   Ready    <none>   14d     v1.17.8
cl1fu7golamsfv2f3to0-ojeh   Ready    <none>   14d     v1.17.8
cl1tbgmha61b3u1tc52n-ipuj   Ready    <none>   6d21h   v1.17.8
```

вернемся в основной профиль

```
yc managed-kubernetes cluster get-credentials  --context-name=k8s-sa --id cateqfn1s7fupiu9bo48 --profile=prod --force --external
```

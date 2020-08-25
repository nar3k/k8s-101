# Cert Manager

## !Перед этой лабой надо выполнить предыдущую!



cd ../4/



## Настроим DNS чтобы все работало

В общем случае надо так чтобы ваше доменное имя резолвилось в интернете в адрес ingress контроллера - $INGRESS_IP

Например  я буду использовать домен k-101.app.nrk.me.uk , который резолвится в адрес 84.201.128.53

```sh
nrkk-osx:3 nrkk$ echo $INGRESS_IP
84.201.128.53
nrkk-osx:3 nrkk$ dig k-101.app.nrk.me.uk | grep $INGRESS_IP
k-101.app.nrk.me.uk.	299	IN	A	84.201.128.53
```
## Установим cert-manager


```sh
kubectl create namespace cert-manager
helm repo add jetstack https://charts.jetstack.io
helm repo update
helm install   cert-manager jetstack/cert-manager   --namespace cert-manager   --version v0.16.1    --set installCRDs=true
watch kubectl get pods --namespace cert-manager
```
## Установим ACME issuer - он будет выпускать честные сертификаты

запишите свой email переменную и создайте на базе этого файл для ресурса ClusterIssuer

```sh
EMAIL=<ВАШ_EMAIL> # например nar3k1@gmail.com
cat 04-acme-prod-issuer.yaml.tpl | sed 's/'"<EMAIL>"'/'"$EMAIL"'/'  > 04-acme-issuer.yml
kubectl apply -f 04-acme-issuer.yml
```

Создадим и запустим ingress  на наше доменное имя

```sh
DOMAIN_NAME=<Ваше доменное имя> # например k-101.app.nrk.me.uk
cat 04-acme-ingress.yaml.tpl | sed 's/'"<DOMAIN_NAME>"'/'"$DOMAIN_NAME"'/'  > 04-acme-ingress.yml
kubectl apply -f 04-acme-ingress.yml
```

Дожидаемся что наш сертификат успешно выпущен


```sh
nrkk-osx:4 nrkk$ kubectl describe certificate echo-tls -n demo-ns

Events:
  Type    Reason     Age   From          Message
  ----    ------     ----  ----          -------
  Normal  Issuing    44s   cert-manager  Issuing certificate as Secret does not exist
  Normal  Generated  44s   cert-manager  Stored new private key in temporary Secret resource "echo-tls-48w44"
  Normal  Requested  44s   cert-manager  Created new CertificateRequest resource "echo-tls-zhs74"
  Normal  Issuing    4s    cert-manager  The certificate has been successfully issued
```

Проверяем
```sh
nrkk-osx:4 nrkk$ echo | openssl s_client -showcerts -servername ${DOMAIN_NAME} -connect ${DOMAIN_NAME}:443 2>/dev/null | openssl x509 -inform pem -noout -text | grep Subject:
        Subject: CN=k-101.app.nrk.me.uk:

```

Можно проверить и браузером :)

## Чистим лабу


```sh
kubectl delete ns demo-ns
helm uninstall nginx-ingress
helm uninstall cert-manager --namespace cert-manager
```

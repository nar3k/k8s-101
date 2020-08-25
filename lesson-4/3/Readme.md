# Сертификаты и секреты


cd ../3/



## Установим Helm

https://helm.sh/docs/intro/install/#from-homebrew-macos

## Установим nginx ingress controller

```sh
helm repo add nginx-stable https://helm.nginx.com/stable
helm repo update
helm install nginx-ingress nginx-stable/nginx-ingress
```

запишем IP адрес балансера
```sh
watch kubectl get svc nginx-ingress-nginx-ingress # дождемся получения IP адреса
INGRESS_IP=$(kubectl get svc nginx-ingress-nginx-ingress --output=json | jq -r .status.loadBalancer.ingress[0].ip)
```

# Создадим тестовое приложение и опубликуем в интернет только с 80 портом

```sh
kubectl create -f 03-ns-pod-svc.yaml
curl -H "Host: test.example" http://${INGRESS_IP}/ #должен выдать страничку с nginx
```
# Создадим и импортируем тестовый сертификат

```sh
HOST=test.example
CERT_NAME=test.example
KEY_FILE=cert.key
CERT_FILE=cert.crt
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout ${KEY_FILE} -out ${CERT_FILE} -subj "/CN=${HOST}/O=${HOST}"
kubectl create secret tls ${CERT_NAME} --key ${KEY_FILE} --cert ${CERT_FILE} -n demo-ns
```

# подключим сертификат с ingress


```sh
kubectl apply -f 03-cert-ingress.yaml
```

Проверим что хост test.example выдает созданный сертификат

```sh
$ echo | openssl s_client -showcerts -servername test.example -connect ${INGRESS_IP}:443 2>/dev/null | openssl x509 -inform pem -noout -text | grep Subject:
        Subject: CN=test.example, O=test.example
```
Проверим что другой хост выдает дефолтный сертификат



```sh
$ echo | openssl s_client -showcerts -servername testdude.example -connect ${INGRESS_IP}:443 2>/dev/null | openssl x509 -inform pem -noout -text | grep Subject:
        Subject: CN=NGINXIngressController
```

# Лабу не удаляем - переходим на лабу 4

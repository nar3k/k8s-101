#   Helm как package manager

```
cd lesson-9/0
```

Установим helm ( https://helm.sh )
Например на Mac

```sh
brew install helm
```

установим nginx ingress  

```sh
helm repo add nginx-stable https://helm.nginx.com/stable
helm repo update
helm install nginx-ingress nginx-stable/nginx-ingress
```

Посмотрим на результат

```sh
kubectl get all
```

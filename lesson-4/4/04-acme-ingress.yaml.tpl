apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: nginx
  annotations:
    kubernetes.io/ingress.class: "nginx"
    cert-manager.io/cluster-issuer: "letsencrypt-prod"
  namespace: demo-ns
spec:
  tls:
  - hosts:
    - <DOMAIN_NAME>
    secretName: echo-tls
  rules:
  - host: <DOMAIN_NAME>
    http:
      paths:
      - backend:
          serviceName: nginx
          servicePort: 80
        path: /

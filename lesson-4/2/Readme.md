# StatefullSet


cd ../2/

Создадим ns

```sh
kubectl create -f 02-ns.yaml
```

Изучим файлики для запуска sts

```sh
kubectl create -f 02-cm.yaml
```

Запустим сам sts и дождемся чтобы он создал все поды
```sh
kubectl create -f 03-sts.yaml
watch kubectl get pods -l app=mysql -n demo-ns # запустить во вкладке
```

Когда будет вывод типа

```
NAME      READY     STATUS    RESTARTS   AGE
mysql-0   2/2       Running   0          2m
mysql-1   2/2       Running   0          1m
mysql-2   2/2       Running   0          1m
```
То это значит что все работает
Посмотрим на PVC - их как видите создано 3


```
kubectl get pvc -n demo-ns
NAME           STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS     AGE
data-mysql-0   Bound    pvc-fe0e63a7-831a-4b22-8841-e6fb60ee8109   10Gi       RWO            yc-network-ssd   12m
data-mysql-1   Bound    pvc-6cc27a0b-20ef-4b5d-9d08-8d869085345b   10Gi       RWO            yc-network-ssd   11m
data-mysql-2   Bound    pvc-ab02379b-efde-404b-8e5d-afa9e2e0466e   10Gi       RWO            yc-network-ssd   9m26s

```

Запишем в мастера (под mysql-0) сообщение

```
kubectl run mysql-client --image=mysql:5.7 -i --rm --restart=Never --\
  mysql -h mysql-0.mysql.demo-ns <<EOF
CREATE DATABASE test;
CREATE TABLE test.messages (message VARCHAR(250));
INSERT INTO test.messages VALUES ('hello');
EOF
```

Прочитаем  с реплик ( сервис mysql-read ) сообщение
```
kubectl run mysql-client --image=mysql:5.7 -i -t --rm --restart=Never --\
  mysql -h mysql-read.demo-ns -e "SELECT * FROM test.messages"
```

Убедимся что запросы в реплики рандомно распределяюся

```
kubectl run mysql-client-loop --image=mysql:5.7 -i -t --rm --restart=Never --\
  bash -ic "while sleep 1; do mysql -h mysql-read.demo-ns -e 'SELECT @@server_id,NOW()'; done"
```

Мы будем тут видеть рандомные serverid ( оста)


```
kubectl run mysql-client-loop --image=mysql:5.7 -i -t --rm --restart=Never --\
     bash -ic "while sleep 1; do mysql -h mysql-read.demo-ns -e 'SELECT @@server_id,NOW()'; done"
If you don't see a command prompt, try pressing enter.
```
```
+-------------+---------------------+
| @@server_id | NOW()               |
+-------------+---------------------+
|         101 | 2020-08-24 16:32:17 |
+-------------+---------------------+
+-------------+---------------------+
| @@server_id | NOW()               |
+-------------+---------------------+
|         100 | 2020-08-24 16:32:18 |
+-------------+---------------------+
+-------------+---------------------+
| @@server_id | NOW()               |
+-------------+---------------------+
|         102 | 2020-08-24 16:32:19 |
+-------------+---------------------+
```
Смаштабируем базу горизонтально вверх

```
kubectl scale statefulset mysql  --replicas=5 -n demo-ns
```

Видим что постепенно запрос в базу стал выдавать новые server_id ( 103 и 104)

Посмотрим на PVC - их как видите создано уже 5


```
kubectl get pvc -n demo-ns
```

Смаштабируем базу горизонтально вниз и будем наблюдать

```
kubectl scale statefulset mysql  --replicas=3 -n demo-ns
```
Новые server_id пропали из базы

а старые PVC ожидаемо остались

```
kubectl get pvc -n demo-ns
```

Почистим лабу

```
kubectl delete ns demo-ns
```

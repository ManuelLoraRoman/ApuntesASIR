# Kubernetes for Storm

Gestiona el despliegue de aplicaciones sobre contenedores. Automatiza el 
despliegue con escalabilidad y controlando todo el ciclo de vida.

* Despliega aplicaciones rápidamente.

* Escala las aplicaciones al vuelo.

* Integra cambios sin interrupciones.

* Permite limitar los recursos a utilizar.

Centrado en la puesta en producción. Afecta directamente a los desarrolladores
ya que se deben adaptar las aplicaciones.

Puede instalarse en la nube o en servidores físicos. Es extensible ya que 
posee módulos, plugins, etc. Autoreparable.

Kubernetes (k8s) permite gestionar un clúster de nodos en los que desplegar 
aplicaciones sobre contenedores.

## Arquitectura básica

worker / minion / node --> componente de un clúster de k8s.
Son gestionados por los componentes master / controller. Cada nodo tiene:

* Direcciones: Hostname, Ip externa, Ip interna.

* Condición: campo que describe el estado.

* Capacidad: describe los recursos disponibles.

* Info: información general.

Adicionalmente el controller tiene componentes para controlar a los otros nodos.

## Comandos

```
minikube start --> levanta el clúster

minikube ip --> devuelve la ip del controlador

kubectl get nodes --> devuelve los nodos desplegados

cd ./kube/config --> donde guarda minikube las credenciales

minikube delete --> borra el clúster 
```

Nosotros no vamos a trabajar con los _pods_ y los _replicaSets_. Trabajaremos
con los _deployments_. Permite actualizaciones continuas y despliegues 
automáticos.

Aparte disponemos de _Services_ que permite acceso a los pods y el balanceo
de carga; e _Ingress_, que permite el acceso por nombres.

Los Pods son la unidad mínima de ejecución por nodo. Representa un conjunto de
contenedores que comparten almacenamiento y una única IP. Son efímeros.

```
kubectl run nginx --image=nginx
```

Ejemplo:

```
kubectl create / apply -f pod.yaml

kubectl get pod (-o wide)

kubectl describe pod _nombre_

kubectl logs _nombre_

kubectl exec -it _nombre_ -- /bin/bash

kubectl port-forward _nombre_ 8080:80
```

Los ReplicaSet son recursos que aseguran que siempre se ejecute un número de
réplicas de un pod determinado. Asegura por lo tanto que un conjunto de pods
funcione siempre y esté disponible.

Se resume en tolerancia a fallos y escalabilidad dinámica.

```
kubectl scale rs _nombre_ --replicas=5
```

Los _deployments_ son la unidad de más alto nivel que podemos gestionar. Nos
permite definir estas diferentes funciones:

* Control de réplicas

* Escabilidad de pods

* Actualizaciones continuas

* Despliegues automáticos

* Rollback a versiones anteriores

```
kubectl create deployment _nombre_ --image=nginx

kubectl apply -f deployment.yaml (--record)

kubectl scale deployment _nombre_ --replicas=5

kubectl port-forward deploy/_nombre_ 8080:80

kubectl logs deploy/_nombre_

kubectl rollout history deployment/_nombre_

kubectl set image deployment/mediawiki mediawiki=mediawiki:1.31.10 --all --record

Los dos últimos comandos, permiten cambiar la versión de la imagen

kubectl rollout undo deployment mediawiki
```

Ejecución de una aplicación completa de ejemplo en la que varios despliegues
se relacionan entre sí:

```
kubectl apply -f frontend-deployment.yaml
kubectl apply -f redis-master-deployment.yaml
kubectl apply -f redis-slave-deployment.yaml
```

Los servicios nos permiten acceder a nuestras aplicaciones. Es una abstracción
que define un conjunto de pods que implementan un micro-servicio.

Ofrecen una dirección virtual y un nombre que identifica al conjunto de pods que
representa. Conexión desde otros pods o desde el exterior. Se utilizan
etiquetas para seleccionar los pods.

Los servicios se implementan con iptables. Es un tanto más complejo, ya que
se requiere un componente adicional como puede ser el _kube-proxy_ que permite
que los pods / contenedores se vean aunque estén en nodos distintos.

Cuando se crea un nuevo servicio, se le asigna una nueva ip interna virtual
(IP-CLUSTER) que permite conexiones desde otros pods.

Servicios:

* ClusterIP --> solo permite el acceso interno entre distintos servicios. 
Tipo por defecto. Podemos acceder desde el exterior con la instrucción
kubectl proxy.

* NodePort --> abre un puerto, para que el servicio sea accesible desde el
exterior. El puerto generado está en 30000:40000. Usamos la ip del
servidor master del cluster y el puerto asignado.

```
kubectl get svc

kubectl expose deployment/_nombre_ --port=80 --type=ClusterIP

kubectl proxy

kubectl apply -f frontend-deployment.yaml
kubectl apply -f redis-master-deployment.yaml
kubectl apply -f redis-slave-deployment.yaml
kubectl apply -f frontend-srv.yam
kubectl apply -f redis-master-srv.yaml
kubectl apply -f redis-slave-srv.yaml

kubectl get all -n kube-system

kubectl create deployment pagweb --image=josedom24/infophp:v1
kubectl expose deploy pagweb --port=80 --type=NodePort
kubectl scale deploy pagweb --replicas=3

Y para comprobar: for i in `seq 1 100`; do curl http://<MASTER-IP>:<SVC-PORT>; done
```

Ingress Controller nos permite utilizar un proxy inverso que por medio de reglas
de encaminamiento que obtiene de la API de Kubernetes, nos permite el acceso a
nuestras aplicaciones por medio de nombres.

```
minikube addons enable ingress
```



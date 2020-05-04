# SEAT - Tekton Demo Evo

El proyecto Tekton Demo Evo pretende ser una evolución de la demo de Tekton presentada con anterioridad y que puede consultarse en el repositorio "seat-eam-concepts"

https://group-cip.audi.de/stash/projects/SEEAMC/repos/seat-eam-concepts/browse

La demo busca la creación de una pipeline de Tekton alineada con la presentada en el grupo de trabajo de CI/CD de SEAT y que se muestra a continuación:

![Proposal of Pipeline](./img/tekton_demo_1.png)

Con los siguientes objetivos:

- Validar la integración con los diferentes productos detallados en la presentación (p.ej: Kiwan, Sonarqube, herramientas de testing de regresión, carga,...) 

- Validar la posibilidad de realizar un despliegue de una aplicación monolítica en un servidor de aplicaciones (Tomcat)

- Probar la capacidad de Tekton para paralelizar tareas

- Probar la flexibilidad de Tekton para la construcción de componentes específicos

Para ello se ha planteado la siguiente arquitectura para la demo

![Demo Architecture](./img/tekton_demo_2.png)

donde se podrán validar los siguiente componentes:

- **Openshift (192.168.1.44):** Este componente es responsable de la ejecución de todos los artefactos de Tekton creados para la demo. Para ello se dispone de un Openshift 4.3.x con el Operador ***Openshift Pipelines Operator*** y el ***Nexus Operator***. 

 Por conveniencia y sencillez de la demo también se ha desplegado el Sonarqube en el mismo Cluster

- **VM Ubuntu Desktop (192.168.1.65):** Este componente tiene todo lo necesario para la ejecución de los tests de regresión mediante el uso del producto KATALON (https://www.katalon.com/)

- **EC2 Redhat 8 (AWS) (18.156.196.xxx):** Este componente contiene todo lo necesario para la ejecución de una aplicación web empaquetada en un WAR

Hay que tener en cuenta que el componente que ejecuta los artefactos de Tekton (Cluster Openshift) ha de tener visibilidad de red del resto de componentes.

## Prerequisitos

Para poder realizar la construcción del proyecto, y tal como se ha comentado en el punto anterior, será necesario tener desplegados los siguientes componentes:

**1. Openshift 4.3+:** En este a su vez deberán estar correctamente configurado:

- Openshift Pipelines Operator
- Nexus Operator
- Sonarqube (que se podrá desplegar a partir de los artefactos que componen la demo)

- Serí recomendable también tener correctamente configurados el **Openshift CLI (oc)** y el **Tekton CLI (tkn)**

**2. VM Ubuntu Desktop:** En este deberán estar correctamente configurado:

- Acceso vía SSH mediante el uso de certificado
- Firefox (75.0+)
- geckodriver (https://github.com/mozilla/geckodriver/releases)
- maven 3.6.0+
- Java 1.8+

**3. EC2 Redhat 8 (AWS):** En este deberán estar correctamente configurado:

- Acceso vía SSH mediante el uso de certificado
- Apache Tomcat 9.x

## Construcción y Setup del proyecto 

El primer paso que se deberá realizar será descargar el respositorio y para ello se deberán ejecutar los siguiente comandos:

```bash
iMac-de-Sergio:kubernetes sarcosh$ git clone https://group-cip.audi.de/stash/scm/seeamc/seat-eam-concepts.git

iMac-de-Sergio:kubernetes sarcosh$ cd seat-eam-concepts/demo-tekton-evo/

iMac-de-Sergio:demo-tekton-evo sarcosh$ 
```

Una vez descargados todos los artefactos necesarios se deberá proceder al despliegue de los mismos. Para ello comenzaremos con aquellos relativos a la inicialización, entre los que se encuentra la creación y despliegue de la imagen de Sonarqube necesaria para la demo, la imagen de python que se necesitará en algunos de los pasos de Tekton o el alta de roles, servicesaccounts y secretos.

```bash
iMac-de-Sergio:demo-tekton-evo sarcosh$ ls -lrt ./00-init/
total 0
drwxr-xr-x  5 sarcosh  staff  160 29 abr 16:43 02-setup-python
drwxr-xr-x  6 sarcosh  staff  192 29 abr 17:01 03-setup-sonarqube
drwxr-xr-x  4 sarcosh  staff  128 29 abr 17:32 01-setup-openshift-roles-serviceaccounts
drwxr-xr-x  5 sarcosh  staff  160 30 abr 16:52 00-setup-secrets
```

Para ello deberemos ejecutar los siguientes comandos:

```bash
iMac-de-Sergio:00-init sarcosh$ oc create -f 00-setup-secrets/

iMac-de-Sergio:00-init sarcosh$ oc create -f 01-setup-openshift-roles-serviceaccounts/

iMac-de-Sergio:00-init sarcosh$ cd 02-setup-python/

iMac-de-Sergio:02-setup-python sarcosh$ ./install.sh 

iMac-de-Sergio:02-setup-python sarcosh$ cd ..

iMac-de-Sergio:00-init sarcosh$ cd 03-setup-sonarqube/

iMac-de-Sergio:03-setup-sonarqube sarcosh$ ./install.sh 
```

Una vez validado que todos los artefactos se encuentran disponibles se podrá proceder con los siguientes, los cuales se tratan de todos aquellos recursos (p.ej: repositorios GIT) necesarios para la ejecución de las pipelines y sus tareas (tasks). 

Para ello, de manera análoga al caso anterior, se deberá ejecutar el siguiente comando:

```bash
iMac-de-Sergio:demo-tekton-evo sarcosh$ ls -lrt
total 32
-rw-r--r--   1 sarcosh  staff  15205  8 abr 15:33 README.md
drwxr-xr-x   4 sarcosh  staff    128 28 abr 12:45 01-resources
drwxr-xr-x   5 sarcosh  staff    160 28 abr 16:07 03-pipelines
drwxr-xr-x   5 sarcosh  staff    160 29 abr 15:13 04-pipelinesruns
drwxr-xr-x  11 sarcosh  staff    352 29 abr 17:32 05-pipeline-triggers
drwxr-xr-x   4 sarcosh  staff    128 29 abr 17:32 06-github-webhooks
drwxr-xr-x   7 sarcosh  staff    224 30 abr 15:21 00-init
drwxr-xr-x   7 sarcosh  staff    224 30 abr 17:46 02-tasks
drwxr-xr-x   7 sarcosh  staff    224  4 may 14:08 img

iMac-de-Sergio:demo-tekton-evo sarcosh$ oc create -f ./01-resources/
```

Por último se podrá proceder a la creación del resto de artefactos: tareas (tasks), pipelines, pipelinesruns, pipeline-triggers y github-webhooks, respectivamente. Para ello ejecutaremos los siguientes comandos:

```bash
iMac-de-Sergio:demo-tekton-evo sarcosh$ ls -lrt
total 32
-rw-r--r--   1 sarcosh  staff  15205  8 abr 15:33 README.md
drwxr-xr-x   4 sarcosh  staff    128 28 abr 12:45 01-resources
drwxr-xr-x   5 sarcosh  staff    160 28 abr 16:07 03-pipelines
drwxr-xr-x   5 sarcosh  staff    160 29 abr 15:13 04-pipelinesruns
drwxr-xr-x  11 sarcosh  staff    352 29 abr 17:32 05-pipeline-triggers
drwxr-xr-x   4 sarcosh  staff    128 29 abr 17:32 06-github-webhooks
drwxr-xr-x   7 sarcosh  staff    224 30 abr 15:21 00-init
drwxr-xr-x   7 sarcosh  staff    224 30 abr 17:46 02-tasks
drwxr-xr-x   7 sarcosh  staff    224  4 may 14:08 img

iMac-de-Sergio:demo-tekton-evo sarcosh$ oc create -f 02-tasks/
iMac-de-Sergio:demo-tekton-evo sarcosh$ oc create -f 03-pipelines/
iMac-de-Sergio:demo-tekton-evo sarcosh$ oc create -f 04-pipelinesruns/
iMac-de-Sergio:demo-tekton-evo sarcosh$ oc create -f 05-pipeline-triggers/
iMac-de-Sergio:demo-tekton-evo sarcosh$ oc create -f 06-github-webhooks/
```
Es importante realizar un par de validaciones después de ejecutar los comandos anteriores para comprobar que la configuración se ha realizado correctamente. Para ellos se deberán realizar las siguientes pruebas:

- Ha de validarse que se ha creado el Webhook en GitHub para el proyecto enlazandolo con la pipeline de construcción (build). Para ello deberemos ejecutar el siguiente comando comprobando que el estado de **ejecución del TaskRun ("create-repo-webhook-run") es "Succeeded"**

```bash
iMac-de-Sergio:demo-tekton-evo sarcosh$ tkn tr ls

NAME                                                    STARTED       DURATION     STATUS               
create-repo-webhook-run                                 1 hour ago    12 seconds   Succeeded   
deploy-bgfv2i-deploy-to-dev-c89hf                       5 hours ago   40 seconds   Succeeded   
cd-spring-demo-fzfj9-deploy-to-dev-84bbv                5 hours ago   27 seconds   Succeeded   
ci-spring-demo-bx6gd-build-binary-task-6gwsq            5 hours ago   2 minutes    Succeeded   
ci-spring-demo-bx6gd-build-test-regression-task-5xvb8   5 hours ago   48 seconds   Succeeded 
```

- Ha de validarse que los listeners responsables de procesar las peticiones realizadas a través de los webhooks, habilitados para las operaciones de CI y CD, se encuentran levantados y funcionando correctamente. Para ello se podrá ejecutar el siguiente comando:

```bash
iMac-de-Sergio:demo-tekton-evo sarcosh$ oc get pods | grep listener

el-cd-listener-9976ddcc5-lvn5k                                    1/1     Running     3          5d
el-ci-listener-6d5687f945-s58fc                                   1/1     Running     3          5d
```

- Se deberá validar que tanto el Nexus así como el Sonarqube se encuentran funcionando correctamente. Para ello se deberán ejecutar los siguientes comandos:

```bash
iMac-de-Sergio:spring-demo sarcosh$ oc get pods | grep nexus
nexus3-65bd5865dd-zrqtb           1/1     Running     3          5d6h

iMac-de-Sergio:spring-demo sarcosh$ oc get pods | grep sonarqube
sonarqube-1-9d5sw                 1/1     Running     5          4d22h
sonarqube-1-deploy                0/1     Completed   0          4d22h
iMac-de-Sergio:spring-demo sarcosh$ 
```
También se podrá validar mediante el acceso a las consolas gráficas de ámbas herramientas.

- Por último se deberá dar de alta el repositorio en Nexus donde se guardarán los artefactos resultantes del proceso de CI (ficheros WAR)

Este proceso puede realizarse a través de la consola gráfica de la herramienta tal como muestra la siguiente captura de pantalla.

![Proposal of Pipeline](./img/setup_nexus_repository.png)

## Inicio de la Demo

Una vez todos los artefactos y componentes se encuentran correctamente construidos y desplegados se puede iniciar la demo y para ello se podrán seguir los siguientes pasos:

**1. Descarga de GitHub el proyecto de demo:** El primer paso será descargar desde GitHub el proyecto que se ha usado para realizar la demo de integración. Este se trata de un proyecto de Spring pero que en lugar de compilarse mediante el uso de Spring Boot se compila y encapsula para su despliegue mediante el uso de un servidor de aplicaciones (fichero WAR)

Para poder descargar el proyecto bastará con ejecutar el siguiente comando:

```bash
iMac-de-Sergio:workspace sarcosh$ git clone https://github.com/sarcosh/spring-demo.git

iMac-de-Sergio:workspace sarcosh$ cd spring-demo/

iMac-de-Sergio:spring-demo sarcosh$ 
```
Una vez descargado el proyecto bastará con realizar una modificación y sincronizarla con GitHub para disparar automáticamente el proceso de integración a través del uso de webhook configurado en el proyecto. Para ello se puede realizar una modificación, por ejemplo, a este fichero "README.MD".

```bash
iMac-de-Sergio:workspace sarcosh$ git clone https://github.com/sarcosh/spring-demo.git

iMac-de-Sergio:workspace sarcosh$ cd spring-demo/

iMac-de-Sergio:spring-demo sarcosh$ 
```







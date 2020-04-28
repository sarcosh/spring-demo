#!/bin/bash

TOMCAT_HOME="/Users/sarcosh/Documents/apache-tomcat-8.5.54"
LOCAL_WAR_FILE_NAME="spring-demo.war"

REMOTE_WAR_FILE_NAME="spring-demo-0.0.1-20200428.095625-1.war"
NEXUS_URL="http://openshift43.ddns.net:8080/nexus/repository/spring-demo-snapshot/com/seat/demo/spring-demo/0.0.1-SNAPSHOT/"

is_Running() {

 wget -O - http://127.0.0.1:8081/ >& /dev/null

 if( test $? -eq 0 ) 
 then
  return 0
 else
  return 1
 fi
}

stop_Tomcat(){
 $TOMCAT_HOME/bin/shutdown.sh
}

start_Tomcat(){
 $TOMCAT_HOME/bin/startup.sh
}


if [ -d $TOMCAT_HOME ]; then
    echo "Validando si el Tomcat se encuentra funcionando..." 

    is_Running
    IS_RUNNING_RETURN_CODE=$?
    if [ "$IS_RUNNING_RETURN_CODE" -eq "1" ]; then
      echo "Se ha detectado que el Tomcat está funcionando..."
      echo "Se inicia su parada..."
      stop_Tomcat

    fi

    echo "Eliminando fichero WAR del directorio [$TOMCAT_HOME/webapps]..."
    if [ -f "$TOMCAT_HOME/webapps/$LOCAL_WAR_FILE_NAME" ]; then
    	rm $TOMCAT_HOME/webapps/$LOCAL_WAR_FILE_NAME
    fi

    echo "Eliminando directorio asociado al despliegue anterior en [$TOMCAT_HOME/webapps]..."
    DEP_DIRECTORY_NAME=$(echo "$LOCAL_WAR_FILE_NAME" | cut -f 1 -d '.')

    if [ -d "$TOMCAT_HOME/webapps/$DEP_DIRECTORY_NAME" ]; then
    	rm -rf $TOMCAT_HOME/webapps/$DEP_DIRECTORY_NAME
    fi

    echo "Recuperando última versión de la aplicación..."
    REMOTE_WAR_FILE_NAME=$(python ./deployment/remote/getLastVersion.py)
    echo "====> Se ha recuperado la versión: $REMOTE_WAR_FILE_NAME"

    echo "Descargando aplicación en [$TOMCAT_HOME/webapps]..."
    wget -O $TOMCAT_HOME/webapps/$LOCAL_WAR_FILE_NAME $NEXUS_URL$REMOTE_WAR_FILE_NAME

    if [ -f "$TOMCAT_HOME/webapps/$LOCAL_WAR_FILE_NAME" ]; then
    	echo "Iniciando Tomcat..."
		start_Tomcat

		is_Running
    	IS_RUNNING_RETURN_CODE=$?
    	if [ "$IS_RUNNING_RETURN_CODE" -eq "1" ]; then
      		echo "El Tomcat se ha iniciado correctamente..."
    	fi
    
    else
    	echo "Error: No se ha podido descargar el fichero WAR desde $NEXUS_URL"
    	exit 1
    fi

else
    echo "Error: El directorio $TOMCAT_HOME no existe."
    exit 1
fi





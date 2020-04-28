#!/bin/bash

TOMCAT_HOME="/Users/sarcosh/Documents/apache-tomcat-8.5.54"
WAR_FILE_NAME="spring-demo.war"

is_Running() {

 wget -O - http://127.0.0.1:8080/ >& /dev/null

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
    if [ -f "$TOMCAT_HOME/webapps/$WAR_FILE_NAME" ]; then
    	rm $TOMCAT_HOME/webapps/$WAR_FILE_NAME
    fi

    echo "Eliminando directorio asociado al despliegue anterior en [$TOMCAT_HOME/webapps]..."
    DEP_DIRECTORY_NAME=$(echo "$WAR_FILE_NAME" | cut -f 1 -d '.')

    if [ -d "$TOMCAT_HOME/webapps/$DEP_DIRECTORY_NAME" ]; then
    	rm -rf $TOMCAT_HOME/webapps/$DEP_DIRECTORY_NAME
    fi

    echo "Copiando aplicación en [$TOMCAT_HOME/webapps]..."
    if [ -f "./target/$WAR_FILE_NAME" ]; then
    	cp ./target/$WAR_FILE_NAME $TOMCAT_HOME/webapps
    
    	echo "Iniciando Tomcat..."
		start_Tomcat

		is_Running
    	IS_RUNNING_RETURN_CODE=$?
    	if [ "$IS_RUNNING_RETURN_CODE" -eq "1" ]; then
      		echo "El Tomcat se ha iniciado correctamente..."
    	fi
    
    else
    	echo "Error: El fichero ./target/$WAR_FILE_NAME no existe."
    	exit 1
    fi

else
    echo "Error: El directorio $TOMCAT_HOME no existe."
    exit 1
fi





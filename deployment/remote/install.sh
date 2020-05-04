#!/bin/bash

#######################################################################################################################
# 04-2020 David C   - Enterprise Architecture Management of SEAT
# $1 - Fichero war
# 
# Para el despligue se copia el fichero con la fecha en una carpeta nueva llamada deploy_webapps dentro del directorio
# de Tomcat. Luego se crea un enlace simbólico del fichero a la carpeta correcta "webapps".
# Se borran el historial más antiguo de $RET días.
######################################################################################################################

# Comprobaciones
if [[ "$1" != *\.war ]]; then
   printf "\nMadafacker!. Debes indicar un fichero war.";
   printf "\nEj: ./install.sh tuputaaplicacion.war\n";
   exit 1;
fi


# Variables
TOMCAT_HOME="/usr/local/tomcat9"
WAR_FILE=$1
FECH=`date +"%Y%m%d%H%M"`
RET=30

# Funciones
stop_Tomcat(){
	systemctl stop tomcat
}

start_Tomcat(){
	systemctl start tomcat
}


# Main
if [ -d $TOMCAT_HOME ]; then
    echo "Validando si el Tomcat se encuentra funcionando..." 
    SERVICE_STATUS="$(systemctl is-active tomcat)"
    if [ "${SERVICE_STATUS}" = "active" ]; then
      echo "Se ha detectado que el Tomcat está funcionando..."
      echo "Se inicia su parada..."
      stop_Tomcat
      sleep 1
    else
      printf "\nTomcat Service is down"
      sleep 1
    fi
    
    # Copiamos WAR y modificamos enlace
    printf "\nDeploying app...\n"
    sleep 1
    if [ -d $TOMCAT_HOME/deploy_webapps ]; then 
	printf "\nDirectory exist"
    else
	printf "\nNo existe el directorio. Creandolo..."
        mkdir $TOMCAT_HOME/deploy_webapps
	sleep 1
    fi
    printf "\nDeleting webapps files"
    rm -fr $TOMCAT_HOME/webapps/*
    mv $WAR_FILE $TOMCAT_HOME/deploy_webapps/app.war.$FECH
    ln -s $TOMCAT_HOME/deploy_webapps/app.war.$FECH $TOMCAT_HOME/webapps/app_$FECH.war
    chown tomcat:tomcat -R $TOMCAT_HOME
    sleep 1
   
    # Borramos fichero antiguos
    printf "\nBorramos fichero mas antiguos de $RET dias\n"
    find $TOMCAT_HOME/deploy_webapps/* -mtime +$RET -exec rm {} \;

    if [ -f "$TOMCAT_HOME/webapps/app_$FECH.war" ]; then
    	echo "Iniciando Tomcat..."
	start_Tomcat
	sleep 3
        SERVICE_STATUS="$(systemctl is-active tomcat)"
        if [ "${SERVICE_STATUS}" = "active" ]; then
      		echo "Tomcat se ha iniciado correctamente... aplicacion desplegada"
		sleep 1
    	fi
    
    else
    	echo "Error: No se ha podido copiar el fichero $WAR_FILE"
    	exit 1
    fi

else
    echo "Error: El directorio $TOMCAT_HOME no existe."
    exit 1
fi





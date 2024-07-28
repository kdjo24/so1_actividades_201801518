#!/bin/bash

# Leer la variable GITHUB_USER
GITHUB_USER=${GITHUB_USER:-"kdjo24"}

# Consultar la URL de GitHub API
USER_DATA=$(curl -s "https://api.github.com/users/${GITHUB_USER}")

# Extraer los valores necesarios del JSON usando jq
USER_ID=$(echo $USER_DATA | jq -r '.id')
CREATED_AT=$(echo $USER_DATA | jq -r '.created_at')

# Imprimir el mensaje
MESSAGE="Hola ${GITHUB_USER}. User ID: ${USER_ID}. Cuenta fue creada el: ${CREATED_AT}."
echo $MESSAGE

# Crear el log file en /tmp/<fecha>/saludos.log
DATE=$(date +%Y-%m-%d)
LOG_DIR="/tmp/${DATE}"
LOG_FILE="${LOG_DIR}/saludos.log"

# Crear el directorio si no existe
mkdir -p $LOG_DIR

# Escribir el mensaje en el archivo de log
echo $MESSAGE >> $LOG_FILE

# Crear cronjob para ejecutar el script cada 5 minutos
CRON_JOB="*/5 * * * * $(realpath $0)"
(crontab -l 2>/dev/null | grep -v -F "$CRON_JOB"; echo "$CRON_JOB") | crontab -

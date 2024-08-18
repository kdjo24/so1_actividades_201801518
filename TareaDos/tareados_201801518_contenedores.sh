#!/bin/bash

#Aca especificaremos cuantos contenedores crearemos
NUM_CONTAINERS=10

#ACA COLOCARE ESTOS NOMBRES VEDA PARA QUE NO SEAN TAN RANDOMS LOS DE LOS CONTENEDORES
NAME_PREFIX="ContenedorTareaDos_SOPES_201801518_"

# loop para crear los contenedores
for i in $(seq 1 $NUM_CONTAINERS)
do
    #Generando nombre aleatorio para el contenedor
    CONTAINER_NAME="${NAME_PREFIX}${i}"

    #Crea el contenedor con l aimagen de alpine
    docker run -d --name "$CONTAINER_NAME" alpine sleep 3600

    #mostrar el nombre del contenedor creado
    echo "Contenedor creado: $CONTAINER_NAME"
done

echo "Se han creado $NUM_CONTAINERS contenedores en docker"


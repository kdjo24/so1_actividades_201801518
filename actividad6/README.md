## PREGUNTA NUMERO UNO ##

## CODIGO ##

#include <stdio.h>
#include <unistd.h>

int main()

/* fork a child process */
fork();

/* fork another child process */
fork();

/* and fork another */
fork();

return 0;

}

## RESPUESTAS ##

# Primera llamada a fork():

    Crea un proceso hijo.
    Ahora tenemos 2 procesos: el proceso original (padre) y un proceso hijo.

# Segunda llamada a fork():

    Ambos procesos (el padre y el hijo creado anteriormente) ejecutan esta llamada.
    Por lo tanto, esta segunda llamada crea 2 nuevos procesos: un hijo del proceso original y otro hijo del primer proceso hijo.
    Ahora tenemos 4 procesos en total.

# Tercera llamada a fork():

    Todos los 4 procesos actuales ejecutan esta llamada, creando otros 4 nuevos procesos (cada uno de los 4 procesos existentes genera un nuevo hijo).
    Ahora tenemos 8 procesos en total.

# Razonamiento

Cada llamada a fork() genera un nuevo proceso, y como cada proceso existente ejecuta las llamadas a fork(), el número de procesos se duplica con cada llamada. En este caso, hay 3 llamadas a fork(), lo que da como resultado 8 procesos en total, contando el proceso original.

## PREGUNTA NUMERO DOS ##

## CODIGO ##

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/wait.h>

int main() {
    pid_t pid = fork();  // Crear un proceso hijo

    if (pid < 0) {
        // Error al crear el proceso hijo
        perror("fork failed");
        exit(1);
    } else if (pid == 0) {
        // Este es el proceso hijo
        printf("Proceso hijo con PID: %d\n", getpid());
        exit(0);  // El hijo termina aquí y se convierte en zombie
    } else {
        // Este es el proceso padre
        printf("Proceso padre con PID: %d\n", getpid());
        printf("El proceso hijo se convierte en zombie por 60 segundos...\n");
        sleep(60);  // Espera 60 segundos antes de "recolectar" al hijo
        // Usar ps -l en otra terminal durante este tiempo para ver el proceso zombie
        wait(NULL);  // El padre ahora recolecta al proceso hijo, eliminando el zombie
        printf("Proceso hijo recolectado. El zombie ya no existe.\n");
    }

    return 0;
}

# EXPLICACION DEL CODIGO

fork(): Crea un nuevo proceso hijo.

    En el proceso hijo: El proceso hijo simplemente se imprime a sí mismo y luego llama a exit(0); para terminar. El proceso hijo finaliza pero no es recogido inmediatamente por el proceso padre, por lo que entra en estado zombie.

En el proceso padre: 

    El proceso padre imprime su PID, espera 60 segundos usando sleep(60); y luego recoge al proceso hijo llamando a wait(). Durante los 60 segundos, el proceso hijo permanece como un proceso zombie.

Comando ps -l: 

    Durante esos 60 segundos, puedes ejecutar el comando ps -l en otra terminal para ver el proceso hijo en estado zombie. El estado de un proceso zombie es indicado con una "Z" en la columna de estado del proceso.


## PREGUNTA NUMERO TRES ##

# CODIGO


pid_t pid;

pid=fork();
if (pid == 0) { /* child process */
fork();
thread_create( ... );
}
fork();

# Completando el codigo: 

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <pthread.h>
#include <sys/types.h>

// Función que será ejecutada por el hilo
void* thread_function(void* arg) {
    printf("Hilo creado en el proceso con PID: %d\n", getpid());
    return NULL;
}

int main() {
    pthread_t thread;
    pid_t pid;

    // Primer fork
    pid = fork();
    if (pid == 0) {  // Proceso hijo
        printf("Primer proceso hijo creado con PID: %d\n", getpid());
        
        // Segundo fork dentro del hijo
        pid = fork();
        if (pid == 0) {  // Proceso nieto
            printf("Segundo proceso hijo (nieto) creado con PID: %d\n", getpid());
        } else if (pid > 0) {
            // Crear un hilo en el primer hijo
            if (pthread_create(&thread, NULL, thread_function, NULL)) {
                fprintf(stderr, "Error creando el hilo\n");
                exit(1);
            }
            pthread_join(thread, NULL);  // Espera a que el hilo termine
        }
        
        // Tercer fork dentro del primer hijo
        fork();  // Esto crea otro proceso
        printf("Proceso después del tercer fork con PID: %d\n", getpid());
    } else if (pid > 0) {  // Proceso padre
        // Proceso padre no hace nada más
        sleep(1);  // Permitir que los hijos terminen su ejecución
    }

    return 0;
}


# 1. ¿Cuántos procesos únicos son creados?

Se crean 4 procesos únicos.

    El proceso padre (inicial).
    El primer hijo (creado por la primera llamada a fork()).
    El segundo hijo (nieto, creado por la segunda llamada a fork() dentro del primer hijo).
    El tercer hijo (creado por la tercera llamada a fork() dentro del primer hijo).

# 2. ¿Cuántos hilos únicos son creados?

Se crea 1 hilo único.

    Este hilo es creado dentro del primer hijo mediante pthread_create().
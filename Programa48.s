//Leonardo Joel Del Rio Romero 22210301
//Programa 48

//Alto nivel
import time

# Definir una función de ejemplo
def mi_funcion():
    total = 0
    for i in range(1000000):
        total += i
    return total

# Medir el tiempo de ejecución
start_time = time.time()  # Tiempo antes de la ejecución
mi_funcion()
end_time = time.time()  # Tiempo después de la ejecución

# Calcular y mostrar el tiempo de ejecución
execution_time = end_time - start_time
print(f"Tiempo de ejecución: {execution_time} segundos")


//Codigo en C
#include <stdio.h>
#include <time.h>

// Función de ejemplo
void mi_funcion() {
    long total = 0;
    for (int i = 0; i < 1000000; i++) {
        total += i;
    }
}

int main() {
    // Variables para medir el tiempo
    clock_t start_time, end_time;
    double cpu_time_used;

    // Medir tiempo antes de la ejecución
    start_time = clock();

    // Llamada a la función que queremos medir
    mi_funcion();

    // Medir tiempo después de la ejecución
    end_time = clock();

    // Calcular el tiempo de ejecución en segundos
    cpu_time_used = ((double)(end_time - start_time)) / CLOCKS_PER_SEC;

    // Mostrar el tiempo de ejecución
    printf("Tiempo de ejecución: %f segundos\n", cpu_time_used);
    return 0;
}

.global _start

.section .text
_start:
    // Obtener el contador de ciclos al principio
    mrs x0, PMCCNTR_EL0         // Leer el contador de ciclos en x0
    mov x1, #1000000            // Número de iteraciones
    mov x2, #0                  // Acumulador para la suma

    // Bucle de suma (la función a medir)
loop_start:
    add x2, x2, x1              // Sumar x2 + x1
    subs x1, x1, #1             // Restar 1 de x1
    bne loop_start              // Si x1 != 0, repetir

    // Obtener el contador de ciclos al final
    mrs x3, PMCCNTR_EL0         // Leer el contador de ciclos en x3

    // Calcular la diferencia en ciclos (x3 - x0)
    sub x4, x3, x0              // x4 = x3 - x0

    // Imprimir el tiempo en ciclos (nota: en sistemas reales, se necesitaría un syscall para imprimir)
    mov x0, x4                  // Mover el resultado a x0 (para retorno o impresión)
    
    // Salir
    mov x8, #93                 // Exit syscall
    svc #0                      // Llamada al sistema


ASCII:https://asciinema.org/a/YkLPhE5B0St1ZJJdbQZnKSsRg

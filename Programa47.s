//Leonardo Joel Del Rio Romero 22210301
//Programa 47


//Alto nivel
# Definir los límites de un entero de 32 bits (signed)
INT32_MIN = -2**31
INT32_MAX = 2**31 - 1

def suma_con_desbordamiento(a, b):
    resultado = a + b
    
    # Verificar si el resultado está fuera del rango de un entero de 32 bits
    if resultado < INT32_MIN or resultado > INT32_MAX:
        return "Desbordamiento detectado"
    else:
        return resultado

# Ejemplo de uso:
a = 2**31 - 1  # Valor máximo para un entero de 32 bits
b = 1

print(suma_con_desbordamiento(a, b))  # Desbordamiento detectado

a = 1000
b = 2000
print(suma_con_desbordamiento(a, b))  # 3000



//Codigo en C
#include <stdio.h>
#include <limits.h>

int suma_con_desbordamiento(int a, int b) {
    int resultado = a + b;

    // Comprobar desbordamiento en suma
    if ((a > 0 && b > 0 && resultado < 0) || (a < 0 && b < 0 && resultado > 0)) {
        return 1;  // Desbordamiento detectado
    }
    return 0;  // No hubo desbordamiento
}

int main() {
    int a = INT_MAX;  // Valor máximo de un entero de 32 bits
    int b = 1;

    if (suma_con_desbordamiento(a, b)) {
        printf("Desbordamiento detectado\n");
    } else {
        printf("Resultado: %d\n", a + b);
    }

    return 0;
}

.global _start

.section .text

_start:
    // Inicialización de los valores
    mov x0, 2147483647  // Valor máximo de un entero de 32 bits (INT_MAX)
    mov x1, 1           // Valor a sumar

    add x2, x0, x1      // Realizar la suma (x2 = x0 + x1)
    cmp x2, x0          // Comparar el resultado con el primer operando

    // Detectar desbordamiento
    bne no_overflow     // Si no hay desbordamiento, salta a "no_overflow"
    
    // Si hay desbordamiento
    mov x0, 1            // Código de error o mensaje de desbordamiento
    b end                // Salir del programa

no_overflow:
    mov x0, 0            // No hubo desbordamiento, todo está bien

end:
    mov x8, 93           // Código del sistema para "exit"
    svc 0                // Llamada al sistema para salir


ASCII:https://asciinema.org/a/8uKVQo7zfdHkd6Z4Hchk2CnIR

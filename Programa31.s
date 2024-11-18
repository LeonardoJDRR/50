//Leonardo Joel Del Rio Romero 22210301
//Programa 31

//Alto nivel
import math

# Función para calcular el MCM usando el MCD
def mcm(a, b):
    return abs(a * b) // math.gcd(a, b)

# Prueba de la función
if __name__ == "__main__":
    a = int(input("Introduce el primer número: "))
    b = int(input("Introduce el segundo número: "))
    
    # Verificar que los números sean positivos
    if a <= 0 or b <= 0:
        print("Los números deben ser positivos.")
    else:
        result = mcm(a, b)
        print(f"El MCM de {a} y {b} es: {result}")

//Codigo en C
#include <stdio.h>

// Declarar la función ensamblador
extern long mcm_func(long a, long b);

int main() {
    long a, b;

    // Leer dos números
    printf("Introduce el primer número: ");
    scanf("%ld", &a);
    printf("Introduce el segundo número: ");
    scanf("%ld", &b);

    // Validar entrada
    if (a <= 0 || b <= 0) {
        printf("Los números deben ser positivos.\n");
        return 1;
    }

    // Calcular y mostrar el MCM
    long result = mcm_func(a, b);
    printf("El MCM de %ld y %ld es: %ld\n", a, b, result);

    return 0;
}


.global mcm_func
.text

// Función para calcular el MCD
gcd:
    cmp x1, 0                // Comprobar si b == 0
    b.eq end_gcd             // Si b == 0, termina
    udiv x2, x0, x1          // Calcular a / b
    msub x0, x2, x1, x0      // a = a - (a / b) * b (a % b)
    mov x2, x1               // Guardar b en x2
    mov x1, x0               // b = a % b
    mov x0, x2               // a = b
    b gcd                    // Repite el proceso
end_gcd:
    ret                      // Retorna el MCD en x0

// Función principal mcm_func
mcm_func:
    stp x29, x30, [sp, -16]! // Guardar registros de marco
    mov x29, sp              // Actualizar marco de pila

    mov x2, x0               // Guardar el valor original de 'a' en x2
    mov x3, x1               // Guardar el valor original de 'b' en x3

    bl gcd                   // Llamar a gcd(a, b)
    mov x4, x0               // Guardar el resultado del MCD en x4

    // Calcular MCM = (a * b) / MCD
    mul x0, x2, x3           // Multiplicar a y b
    udiv x0, x0, x4          // Dividir el producto por el MCD

    ldp x29, x30, [sp], 16   // Restaurar registros de marco
    ret                      // Retorna el MCM en x0


ASCII:https://asciinema.org/a/Q5gA1L8B5uFNEKIgBbc4a4gXZ

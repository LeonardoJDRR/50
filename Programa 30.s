//Leonardo Joel Del Rio Romero 22210301
//Programa 30

//Alto nivel
def mcd(a, b):
    while b != 0:
        a, b = b, a % b
    return a

# Ejemplo
numero1 = 56
numero2 = 98

resultado = mcd(numero1, numero2)
print(f"El MCD de {numero1} y {numero2} es: {resultado}")

Codigo en C
#include <stdio.h>
extern long gcd_func(long a, long b);

int main() {
    long a, b;

    // Capturar los valores de a y b desde el usuario
    printf("Ingrese el primer número (positivo): ");
    scanf("%ld", &a);
    printf("Ingrese el segundo número (positivo): ");
    scanf("%ld", &b);

    // Validar que los números sean positivos
    if (a <= 0 || b <= 0) {
        printf("Error: Ambos números deben ser positivos y mayores que cero.\n");
        return 1;
    }

    // Llamar a la función ensambladora que ejecuta la macro gcd
    long result = gcd_func(a, b);

    // Imprimir el resultado
    printf("El MCD de %ld y %ld es: %ld\n", a, b, result);

    return 0;
}

.macro gcd a, b
1:                      
    cmp \a, \b          // Comparar a y b
    b.eq 2f             // Si a == b, saltar al final
    sub \a, \a, \b      // Si a > b, restar b de a
    sub \b, \b, \a      // Si a < b, restar a de b
    b 1b                // Volver a comparar
2:
.endm

// Función en ensamblador que calcula el MCD
.text
.globl gcd_func
.type gcd_func, %function
gcd_func:
    // Argumentos en X0 y X1 (a y b)
    gcd x0, x1          // Ejecutar la macro gcd con X0 y X1
    mov x0, x1          // Mover el resultado a X0 para retornarlo
    ret                 // Retornar el valor en X0

    ASCII:https://asciinema.org/a/4E0IJujhWD3BxJesk9KESh2yc

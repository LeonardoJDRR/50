//Leonardo Joel Del Rio Romero 22210301
//Programa 43

//Alto nivel
def sumar(x, y):
    return x + y

def restar(x, y):
    return x - y

def multiplicar(x, y):
    return x * y

def dividir(x, y):
    if y != 0:
        return x / y
    else:
        return "Error: División por cero no permitida"

def calculadora():
    print("Operaciones disponibles:")
    print("1. Suma")
    print("2. Resta")
    print("3. Multiplicación")
    print("4. División")
    
    while True:
        try:
            opcion = int(input("\nSeleccione una operación (1/2/3/4): "))
            if opcion in [1, 2, 3, 4]:
                num1 = float(input("Ingrese el primer número: "))
                num2 = float(input("Ingrese el segundo número: "))
                
                if opcion == 1:
                    print(f"{num1} + {num2} = {sumar(num1, num2)}")
                elif opcion == 2:
                    print(f"{num1} - {num2} = {restar(num1, num2)}")
                elif opcion == 3:
                    print(f"{num1} * {num2} = {multiplicar(num1, num2)}")
                elif opcion == 4:
                    print(f"{num1} / {num2} = {dividir(num1, num2)}")
                
                otra = input("\n¿Quieres hacer otra operación? (s/n): ").lower()
                if otra != 's':
                    print("¡Hasta luego!")
                    break
            else:
                print("Opción inválida. Por favor seleccione una operación válida.")
        except ValueError:
            print("Entrada inválida. Asegúrese de ingresar un número.")

# Llamar la función calculadora
calculadora()

//Codigo en C
#include <stdio.h>

// Declaración de las funciones en ensamblador
extern int Sumar(int a, int b);
extern int Restar(int a, int b);
extern int Multiplicar(int a, int b);
extern int Dividir(int a, int b);

int main() {
    int num1, num2, opcion, resultado;

    // Solicitar al usuario los dos números
    printf("Introduce el primer número: ");
    scanf("%d", &num1);
    
    printf("Introduce el segundo número: ");
    scanf("%d", &num2);

    // Mostrar las opciones para seleccionar la operación
    printf("Selecciona la operación:\n");
    printf("1 - Suma\n");
    printf("2 - Resta\n");
    printf("3 - Multiplicación\n");
    printf("4 - División\n");
    printf("Ingrese su opción: ");
    scanf("%d", &opcion);

    // Realizar la operación correspondiente según la opción seleccionada
    switch (opcion) {
        case 1:
            resultado = Sumar(num1, num2); // Suma
            printf("Resultado: %d + %d = %d\n", num1, num2, resultado);
            break;
        case 2:
            resultado = Restar(num1, num2); // Resta
            printf("Resultado: %d - %d = %d\n", num1, num2, resultado);
            break;
        case 3:
            resultado = Multiplicar(num1, num2); // Multiplicación
            printf("Resultado: %d * %d = %d\n", num1, num2, resultado);
            break;
        case 4:
            if (num2 != 0) { // Verificar división por cero
                resultado = Dividir(num1, num2); // División
                printf("Resultado: %d / %d = %d\n", num1, num2, resultado);
            } else {
                printf("Error: División por cero.\n");
            }
            break;
        default:
            printf("Opción inválida.\n");
            break;
    }

    return 0;
}

.global Sumar
.global Restar
.global Multiplicar
.global Dividir

// Suma: retorna a + b
Sumar:
    add w0, w0, w1       // Sumar el primer y segundo argumento en w0
    ret

// Resta: retorna a - b
Restar:
    sub w0, w0, w1       // Restar el segundo argumento de w0
    ret

// Multiplicación: retorna a * b
Multiplicar:
    mul w0, w0, w1       // Multiplicar w0 * w1 y almacenar en w0
    ret

// División: retorna a / b (b debe ser distinto de 0)
Dividir:
    cbz w1, div_by_zero  // Comprobar si el divisor es 0
    sdiv w0, w0, w1      // Dividir w0 / w1 y almacenar en w0
    ret
div_by_zero:
    mov w0, 0            // Si el divisor es 0, retornar 0
    ret

    ASCII:https://asciinema.org/a/faJ12xT6SNhp6BF9eRGrUegFl

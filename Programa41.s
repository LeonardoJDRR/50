//Leonardo Joel Del Rio Romero 22210301
//Programa 41

//Alto nivel
def decimal_a_hexadecimal(decimal):
    # Convierte el número decimal a hexadecimal usando la función hex() y elimina el prefijo '0x'
    return hex(decimal)[2:]

# Ejemplo de uso
numero_decimal = 1234
numero_hexadecimal = decimal_a_hexadecimal(numero_decimal)
print(f"El número decimal {numero_decimal} en hexadecimal es: {numero_hexadecimal}")


//Codigo en C
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_HEX_LENGTH 16

// Declaraciones extern de las funciones ensamblador
extern void decimal_to_hex(long number);
extern char get_hex_char(int index);
extern int get_length();

// Función auxiliar para generar el string hexadecimal en C
void get_hex_string(long number, char* result) {
    decimal_to_hex(number);
    int length = get_length();
    for (int i = 0; i < length; i++) {
        result[i] = get_hex_char(i);
    }
    result[length] = '\0';
}

int main() {
    while (1) {
        printf("\nConversor de Decimal a Hexadecimal\n");
        printf("1. Convertir número\n");
        printf("2. Ver tabla de conversión (0-15)\n");
        printf("0. Salir\n");
        printf("Seleccione una opción: ");

        int opcion;
        if (scanf("%d", &opcion) != 1) {
            printf("Error: Ingrese un número válido.\n");
            while (getchar() != '\n');  // Limpiar el buffer
            continue;
        }

        switch (opcion) {
            case 1: {
                printf("\nIngrese un número decimal positivo: ");
                long numero;
                if (scanf("%ld", &numero) != 1 || numero < 0) {
                    printf("Por favor, ingrese un número positivo válido.\n");
                    while (getchar() != '\n');  // Limpiar el buffer
                    continue;
                }

                char hexadecimal[MAX_HEX_LENGTH];
                get_hex_string(numero, hexadecimal);

                printf("\nNúmero decimal: %ld\n", numero);
                printf("Número hexadecimal: 0x%s\n", hexadecimal);

                // Información adicional
                printf("Longitud: %d dígitos\n", (int)strlen(hexadecimal));
                if (strlen(hexadecimal) > 0) {
                    printf("Dígito más significativo: %c\n", hexadecimal[0]);
                    printf("Dígito menos significativo: %c\n", hexadecimal[strlen(hexadecimal) - 1]);
                }
                break;
            }

            case 2:
                printf("\nTabla de conversión (0-15):\n");
                printf("Decimal -> Hexadecimal\n");
                printf("--------------------\n");
                for (int i = 0; i <= 15; i++) {
                    char hex[3];  // Solo necesitamos 2 caracteres y el terminador nulo
                    get_hex_string(i, hex);
                    printf("%7d -> 0x%s\n", i, hex);
                }
                break;

            case 0:
                printf("Saliendo del programa...\n");
                return 0;

            default:
                printf("Opción no válida.\n");
                break;
        }
    }
}

.data
    .align 3
    hex_array: .skip 32         // Buffer para almacenar resultado hexadecimal
    result_length: .word 0      // Longitud del resultado
    hex_chars: .ascii "0123456789ABCDEF"  // Caracteres hexadecimales

.text
.align 2
.global decimal_to_hex
.global get_hex_char
.global get_length

// Función para convertir decimal a hexadecimal
// Entrada: x0 = número decimal
decimal_to_hex:
    stp     x29, x30, [sp, -48]!
    mov     x29, sp
    stp     x19, x20, [sp, 16]
    stp     x21, x22, [sp, 32]

    mov     x19, x0            // Guardar número original
    
    // Reiniciar contador de longitud
    adrp    x0, result_length
    add     x0, x0, :lo12:result_length
    str     wzr, [x0]
    
    // Si el número es 0, manejar caso especial
    cbnz    x19, conversion_loop
    
    // Caso especial para 0
    adrp    x0, hex_array
    add     x0, x0, :lo12:hex_array
    mov     w1, '0'
    strb    w1, [x0]
    
    adrp    x0, result_length
    add     x0, x0, :lo12:result_length
    mov     w1, #1
    str     w1, [x0]
    b       end_conversion

conversion_loop:
    // Mientras el número no sea 0
    cbz     x19, reverse_result
    
    // Obtener residuo (número & 0xF)
    and     x20, x19, #0xF
    
    // Obtener carácter hexadecimal correspondiente
    adrp    x21, hex_chars
    add     x21, x21, :lo12:hex_chars
    ldrb    w20, [x21, x20]
    
    // Guardar carácter en el array
    adrp    x21, result_length
    add     x21, x21, :lo12:result_length
    ldr     w22, [x21]
    
    adrp    x0, hex_array
    add     x0, x0, :lo12:hex_array
    strb    w20, [x0, x22]
    
    // Incrementar longitud
    add     w22, w22, #1
    str     w22, [x21]
    
    // Dividir número entre 16
    lsr     x19, x19, #4
    
    b       conversion_loop

reverse_result:
    // Invertir el resultado ya que se generó al revés
    adrp    x0, hex_array
    add     x0, x0, :lo12:hex_array
    adrp    x1, result_length
    add     x1, x1, :lo12:result_length
    ldr     w1, [x1]           // w1 = longitud
    
    mov     x2, #0             // índice inicio
    sub     w3, w1, #1         // índice final
    
reverse_loop:
    cmp     w2, w3
    b.ge    end_conversion
    
    // Intercambiar caracteres
    ldrb    w4, [x0, x2]
    ldrb    w5, [x0, x3]
    strb    w5, [x0, x2]
    strb    w4, [x0, x3]
    
    add     w2, w2, #1
    sub     w3, w3, #1
    b       reverse_loop

end_conversion:
    ldp     x19, x20, [sp, 16]
    ldp     x21, x22, [sp, 32]
    ldp     x29, x30, [sp], 48
    ret

// Función para obtener un carácter del resultado
// Entrada: x0 = índice
// Salida: x0 = carácter en esa posición
get_hex_char:
    stp     x29, x30, [sp, -16]!
    mov     x29, sp
    
    adrp    x1, result_length
    add     x1, x1, :lo12:result_length
    ldr     w1, [x1]
    cmp     w0, w1
    b.ge    invalid_index
    
    adrp    x1, hex_array
    add     x1, x1, :lo12:hex_array
    ldrb    w0, [x1, x0]
    
    ldp     x29, x30, [sp], 16
    ret

invalid_index:
    mov     x0, #0
    ldp     x29, x30, [sp], 16
    ret

// Función para obtener la longitud del resultado
get_length:
    adrp    x0, result_length
    add     x0, x0, :lo12:result_length
    ldr     w0, [x0]
    ret


    ASCII:https://asciinema.org/a/GUqv8JSw8qBQlEGJbHsujE1fU

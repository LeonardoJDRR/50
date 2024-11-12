//Leonardo Joel Del Rio Romero 22210301
//Programa 40


//Alto nivel
def binario_a_decimal_manual(binario):
    decimal = 0
    longitud = len(binario)
    
    for i in range(longitud):
        # Multiplicar el bit por la potencia de 2 correspondiente y sumarlo
        decimal += int(binario[i]) * (2 ** (longitud - i - 1))
    
    return decimal

# Ejemplo de uso
numero_binario = "11001"
decimal = binario_a_decimal_manual(numero_binario)
print(f"El número binario {numero_binario} en decimal es {decimal}")

//Codigo en C
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <regex.h>

extern long binary_to_decimal(const char *binary);  // Declarar la función de ensamblador
extern int get_error();  // Declarar la función para obtener el código de error

int is_valid_binary(const char *binary) {
    regex_t regex;
    int result;

    // Expresión regular para verificar que solo contenga 0s y 1s
    result = regcomp(&regex, "^[01]+$", REG_EXTENDED);
    if (result != 0) {
        return 0;  // Error al compilar la expresión regular
    }

    result = regexec(&regex, binary, 0, NULL, 0);
    regfree(&regex);

    return result == 0;  // Retornar 1 si es válido, 0 si no
}

int main() {
    while (1) {
        int opcion;
        printf("\nConversor de Binario a Decimal\n");
        printf("1. Convertir número binario\n");
        printf("0. Salir\n");
        printf("Seleccione una opción: ");
        
        if (scanf("%d", &opcion) != 1) {
            printf("Error: Ingrese un número válido.\n");
            while (getchar() != '\n');  // Limpiar el buffer de entrada
            continue;
        }

        switch (opcion) {
            case 1: {
                char entrada[65];  // Buffer para el número binario (máximo 64 bits + '\0')

                printf("\nIngrese un número binario (solo 0s y 1s): ");
                if (scanf("%64s", entrada) != 1) {
                    printf("Error: Entrada inválida.\n");
                    continue;
                }

                // Validar que la entrada no esté vacía
                if (strlen(entrada) == 0) {
                    printf("Error: Entrada vacía.\n");
                    break;
                }

                // Verificar longitud máxima (64 bits)
                if (strlen(entrada) > 64) {
                    printf("Error: El número binario no puede tener más de 64 dígitos.\n");
                    break;
                }

                // Verificar que solo contenga 0s y 1s
                if (!is_valid_binary(entrada)) {
                    printf("Error: El número debe contener solo 0s y 1s.\n");
                    break;
                }

                // Llamar a la función de ensamblador para convertir el número binario a decimal
                long resultado = binary_to_decimal(entrada);

                // Verificar si hubo un error durante la conversión
                if (get_error() != 0 || resultado == -1) {
                    printf("Error al convertir el número.\n");
                    break;
                }

                // Mostrar resultados
                printf("\nNúmero binario: %s\n", entrada);
                printf("Número decimal: %ld\n", resultado);

                // Mostrar información adicional
                printf("Cantidad de bits: %lu\n", strlen(entrada));
                printf("Primer bit (MSB): %c\n", entrada[0]);
                printf("Último bit (LSB): %c\n", entrada[strlen(entrada) - 1]);

                break;
            }

            case 0:
                printf("Saliendo del programa...\n");
                return 0;

            default:
                printf("Opción no válida.\n");
                break;
        }
    }

    return 0;
}


.data
    .align 3
    error_flag: .word 0        // Flag para indicar error en la entrada

.text
.align 2
.global binary_to_decimal
.global get_error
.global clear_error

// Función para convertir binario a decimal
// Entrada: x0 = dirección del string binario
// Salida: x0 = número decimal resultante
binary_to_decimal:
    stp     x29, x30, [sp, -48]!
    mov     x29, sp
    stp     x19, x20, [sp, 16]     // Guardar registros que usaremos
    stp     x21, x22, [sp, 32]

    // Inicializar registros
    mov     x19, x0                 // Guardar dirección del string
    mov     x20, #0                 // Resultado decimal
    mov     x21, #0                 // Índice actual
    mov     x22, #1                 // Valor de potencia de 2

    // Limpiar flag de error
    bl      clear_error

validate_loop:
    // Cargar carácter actual
    ldrb    w0, [x19, x21]
    
    // Si es null (fin del string), terminar validación
    cbz     w0, start_conversion
    
    // Verificar si es '0' o '1'
    cmp     w0, #'0'
    b.lt    invalid_input
    cmp     w0, #'1'
    b.gt    invalid_input
    
    // Siguiente carácter
    add     x21, x21, #1
    b       validate_loop

invalid_input:
    // Marcar error y retornar
    bl      set_error
    mov     x0, #-1
    b       end_conversion

start_conversion:
    // x21 ahora tiene la longitud del string
    mov     x22, #1                 // Reiniciar potencia de 2
    mov     x20, #0                 // Reiniciar resultado
    
convert_loop:
    // Si ya procesamos todos los dígitos, terminar
    cbz     x21, end_conversion
    
    // Decrementar índice para procesar desde el último dígito
    sub     x21, x21, #1
    
    // Cargar dígito actual
    ldrb    w0, [x19, x21]
    
    // Si es '1', sumar la potencia actual
    cmp     w0, #'1'
    b.ne    next_digit
    
    // Sumar potencia actual al resultado
    add     x20, x20, x22
    
next_digit:
    // Multiplicar potencia por 2
    lsl     x22, x22, #1
    b       convert_loop

end_conversion:
    mov     x0, x20                 // Mover resultado a x0
    
    // Restaurar registros
    ldp     x19, x20, [sp, 16]
    ldp     x21, x22, [sp, 32]
    ldp     x29, x30, [sp], 48
    ret

// Función para establecer error
set_error:
    adrp    x0, error_flag
    add     x0, x0, :lo12:error_flag
    mov     w1, #1
    str     w1, [x0]
    ret

// Función para limpiar error
clear_error:
    adrp    x0, error_flag
    add     x0, x0, :lo12:error_flag
    str     wzr, [x0]
    ret

// Función para obtener estado de error
get_error:
    adrp    x0, error_flag
    add     x0, x0, :lo12:error_flag
    ldr     w0, [x0]
    ret


    ASCII:https://asciinema.org/a/RJgNkyNxduiGjWHyXtKdrLpbh

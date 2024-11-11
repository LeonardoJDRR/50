//Leonardo Joel Del Rio Romero 22210301
//Programa 22

//Alto nivel
# Caracter ASCII a convertir
char = 'A'

# Convertir a entero (valor ASCII)
ascii_value = ord(char)

# Mostrar el resultado
print(f"El valor ASCII de '{char}' es: {ascii_value}")

.section .data
    input_string: .asciz "12345"        // Cadena de entrada (puedes cambiarla por otro número)
    buffer: .space 20                   // Espacio para almacenar el número convertido a cadena

.section .text
.global _start

_start:
    // Cargar la dirección de la cadena en x0
    ldr x0, =input_string

    // Llamar a la función ascii_to_int
    bl ascii_to_int

    // Convertir el entero en x0 a una cadena ASCII en buffer
    mov x1, x0           // Guardamos el número convertido en x1
    ldr x0, =buffer      // Puntero al buffer donde almacenaremos el resultado
    bl itoa              // Convertimos x1 a cadena de texto en buffer

    // Llamada al sistema para escribir en stdout
    mov x1, x0           // Puntero al buffer convertido (nuestra cadena)
    mov x2, #20          // Longitud máxima de la cadena
    mov x8, #64          // syscall: write (64 en AArch64)
    mov x0, #1           // File descriptor 1 = stdout
    svc #0               // Ejecutar syscall

    // Finalizar programa
    mov x8, #93          // syscall: exit
    svc #0               // Ejecutar syscall

// Función: ascii_to_int
// Convierte una cadena ASCII de dígitos en un entero
// x0 -> puntero a la cadena de caracteres
// Retorno:
// x0 -> contiene el entero resultante
ascii_to_int:
    mov x1, #0           // Inicializamos el resultado en 0

ascii_to_int_loop:
    ldrb w2, [x0], #1    // Cargamos el siguiente byte (carácter) y avanzamos el puntero
    cmp w2, #0           // Comprobamos si llegamos al final de la cadena (carácter null)
    beq ascii_to_int_done // Si es null, terminamos

    sub w2, w2, #'0'     // Convertimos el carácter ASCII al valor numérico (0-9)
    
    // Multiplicamos el acumulador por 10 usando desplazamientos y sumas
    mov x3, x1           // Hacemos una copia de x1 en x3
    lsl x1, x1, #3       // x1 = x1 * 8
    add x1, x1, x3       // x1 = x1 + x3 (x1 ahora es x1 * 9)
    add x1, x1, x3       // x1 = x1 + x3 (x1 ahora es x1 * 10)

    // Sumamos el dígito convertido
    add x1, x1, x2       // x1 = x1 + w2 (dígito convertido)

    b ascii_to_int_loop  // Repetimos el ciclo

ascii_to_int_done:
    mov x0, x1           // Movemos el resultado final a x0 (registro de retorno)
    ret                  // Regresamos

// Función: itoa
// Convierte un número entero positivo en una cadena ASCII
// Entrada:
// x1 -> número a convertir
// x0 -> puntero al buffer donde almacenar la cadena
// Salida:
// x0 -> apunta a la cadena convertida
itoa:
    mov x2, x0           // Guardamos el puntero inicial al buffer en x2
    add x0, x0, #20      // Apuntamos al final del buffer (20 bytes de espacio)

itoa_loop:
    mov x3, #10
    udiv x4, x1, x3      // x4 = x1 / 10
    msub x5, x4, x3, x1  // x5 = x1 - (x4 * 10) => x5 contiene el dígito actual
    add x5, x5, #'0'     // Convertimos el dígito a ASCII
    sub x0, x0, #1       // Retrocedemos el puntero en el buffer
    strb w5, [x0]        // Guardamos el dígito en el buffer
    mov x1, x4           // Actualizamos x1 con el cociente

    cbz x1, itoa_done    // Si el cociente es 0, terminamos
    b itoa_loop          // Repetimos para el siguiente dígito

itoa_done:
    mov x0, x2           // Restauramos el puntero al inicio del buffer
    ret                  // Retornamos

    ASCII:https://asciinema.org/a/sGsrzVv6wHttovYv410McZ3q2

//Leonardo Joel Del Rio Romero 22210301
//Programa 24

//Alto nivel
# Cadena de ejemplo
cadena = "Hola, mundo!"

# Calcular la longitud de la cadena
longitud = len(cadena)

# Mostrar el resultado
print(f"La longitud de la cadena es: {longitud}")

.section .data
    input_string: .asciz "Hola, mundo!"  // Cadena cuya longitud queremos calcular
    newline: .asciz "\n"                 // Salto de línea para separar los resultados

.section .bss
    buffer: .space 20  // Espacio para almacenar la cadena convertida a número

.section .text
.global _start

_start:
    // Cargar la dirección de la cadena en x0
    ldr x0, =input_string

    // Llamar a la función que calcula la longitud de la cadena
    bl string_length

    // El resultado de la longitud está ahora en x0
    mov x1, x0           // Guardar la longitud en x1
    ldr x0, =buffer      // Puntero al buffer donde vamos a convertir la longitud a cadena
    bl itoa              // Convertimos la longitud a cadena ASCII

    // Mostrar la longitud como cadena
    mov x1, x0           // Puntero al buffer de la longitud (donde se almacenó la cadena)
    mov x2, #20          // Longitud máxima de la cadena
    mov x8, #64          // syscall: write (64 en AArch64)
    mov x0, #1           // File descriptor 1 = stdout
    svc #0               // Ejecutar syscall

    // Escribir salto de línea después del resultado
    ldr x0, =newline     // Cargar la dirección del salto de línea
    mov x1, x0           // Puntero al salto de línea
    mov x2, #2           // Longitud de la cadena de salto de línea
    mov x8, #64          // syscall: write (64 en AArch64)
    mov x0, #1           // File descriptor 1 = stdout
    svc #0               // Ejecutar syscall

    // Finalizar el programa
    mov x8, #93          // syscall: exit
    svc #0               // Ejecutar syscall

// Función: string_length
// Calcula la longitud de una cadena
// Entrada: x0 -> puntero a la cadena
// Salida: x0 -> longitud de la cadena
string_length:
    mov x1, #0           // Inicializamos el contador de longitud en 0

string_length_loop:
    ldrb w2, [x0], #1    // Cargar el siguiente byte (carácter) de la cadena
    cmp w2, #0           // Comprobar si es el final de la cadena (carácter null)
    beq string_length_done  // Si llegamos al final, terminamos

    add x1, x1, #1       // Incrementamos el contador de longitud
    b string_length_loop  // Repetir el ciclo

string_length_done:
    mov x0, x1           // Devolver la longitud de la cadena en x0
    ret                  // Regresar a la función que llamó

// Función: itoa
// Convierte un número entero a una cadena ASCII
// Entrada:
// x1 -> número a convertir
// x0 -> puntero al buffer donde almacenar la cadena
// Salida:
// x0 -> puntero a la cadena convertida
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

    ASCII:https://asciinema.org/a/twPWEiz1EcdRguEXj7HVjpiMb

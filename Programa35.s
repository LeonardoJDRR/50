//Leonardo Joel Del Rio Romero 22210301
//Programa 35

//Alto nivel
def rotar_derecha(arr, pasos):
    # Asegúrate de que los pasos estén dentro de los límites del arreglo
    pasos = pasos % len(arr)
    return arr[-pasos:] + arr[:-pasos]

# Ejemplo de uso
arreglo = [1, 2, 3, 4, 5]
pasos = 2
resultado = rotar_derecha(arreglo, pasos)
print(f'Arreglo rotado a la derecha: {resultado}')
def rotar_izquierda(arr, pasos):
    # Asegúrate de que los pasos estén dentro de los límites del arreglo
    pasos = pasos % len(arr)
    return arr[pasos:] + arr[:pasos]

# Ejemplo de uso
arreglo = [1, 2, 3, 4, 5]
pasos = 2
resultado = rotar_izquierda(arreglo, pasos)
print(f'Arreglo rotado a la izquierda: {resultado}')


.data
arreglo: .word 32145435, 5345, 12345, 6789, 10234  // Arreglo de ejemplo con 5 elementos
tamano: .word 5                                    // Tamaño del arreglo
msg_elemento: .string "%d\n"                       // Formato para imprimir cada elemento

.text
.global main
.align 2

main:
    // Prologo de la función main
    stp     x29, x30, [sp, #-16]!   // Guardar el frame pointer y el link register
    mov     x29, sp

    // Preparar variables
    mov     w1, #5                  // Tamaño del arreglo
    adrp    x2, arreglo             // Dirección base del arreglo
    add     x2, x2, :lo12:arreglo
    add     x3, x2, #16             // Dirección del último elemento (4 bytes * 4 = 16)

    // Cargar el último elemento, que se moverá al inicio
    ldr     w4, [x3]

    // Bucle para desplazar todos los elementos a la derecha
loop_rotar_derecha:
    sub     w1, w1, #1              // Decrementar el tamaño
    cbz     w1, fin_rotar_derecha   // Si el tamaño es 0, terminar el bucle

    ldr     w5, [x3, #-4]!          // Cargar el elemento previo y retroceder la dirección
    str     w5, [x3, #4]            // Desplazar el elemento a la posición actual

    b       loop_rotar_derecha      // Repetir para el siguiente elemento

fin_rotar_derecha:
    // Colocar el último elemento en la primera posición
    str     w4, [x2]

    // Imprimir el arreglo rotado
    mov     w1, #5                  // Reiniciar el tamaño del arreglo
    adrp    x2, arreglo             // Dirección base del arreglo
    add     x2, x2, :lo12:arreglo

loop_imprimir_derecha:
    cbz     w1, fin_programa_derecha // Si no quedan elementos, terminar

    ldr     w4, [x2], #4            // Cargar elemento y avanzar dirección del arreglo
    adrp    x0, msg_elemento        // Cargar el mensaje para printf
    add     x0, x0, :lo12:msg_elemento
    mov     w1, w4                  // Colocar el elemento en w1 para printf
    bl      printf                  // Llamar a printf para imprimir el elemento

    sub     w1, w1, #1              // Decrementar el contador de elementos
    b       loop_imprimir_derecha   // Repetir para el siguiente elemento

fin_programa_derecha:
    // Epílogo de la función main
    ldp     x29, x30, [sp], #16     // Restaurar el frame pointer y el link register
    mov     x0, #0                  // Código de salida 0
    ret


    ASCII:https://asciinema.org/a/xqPROARcQVxv83dXlBRTLqvy3

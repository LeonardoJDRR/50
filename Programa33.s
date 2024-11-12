//Leonardo Joel Del Rio Romero 22210301
//Programa 33

//Alto nivel
def suma_arreglo(arreglo):
    suma = sum(arreglo)
    return suma

# Ejemplo de uso
arreglo = [1, 2, 3, 4, 5]
resultado = suma_arreglo(arreglo)
print(f"La suma de los elementos del arreglo es: {resultado}")


.data
arreglo:     .word 32145435, 5345, 12345, 6789, 10234  // Arreglo de ejemplo con 5 elementos
tamano:      .word 5                                   // Tamaño del arreglo (definido directamente)
msg_suma:    .asciz "La suma de los elementos es: %d\n"  

.text
.global main
.align 2

main:
    // Prologo de la función main
    stp     x29, x30, [sp, #-16]!
    mov     x29, sp

    // Inicializar la suma y el índice
    mov     w0, #0                    // Suma acumulada
    ldr     w1, tamano                // Cargar el tamaño del arreglo
    adrp    x2, arreglo               // Dirección base del arreglo
    add     x2, x2, :lo12:arreglo

loop_suma:
    cbz     w1, fin_suma              // Si el tamaño es 0, terminar el bucle

    ldr     w3, [x2], #4              // Cargar un elemento de 4 bytes y avanzar la dirección
    add     w0, w0, w3                // Sumar el elemento al acumulador
    sub     w1, w1, #1                // Decrementar el tamaño (contador de elementos)

    b       loop_suma                 // Repetir para el siguiente elemento

fin_suma:
    // Imprimir el resultado
    adrp    x0, msg_suma              // Cargar el mensaje para printf
    add     x0, x0, :lo12:msg_suma
    mov     w1, w0                    // Pasar la suma acumulada a w1 como argumento para printf
    bl      printf

    // Epílogo de la función main
    ldp     x29, x30, [sp], #16       // Restaurar el frame pointer y el link register
    mov     x0, #0                    // Código de salida 0
    ret

ASCII:https://asciinema.org/a/47mwV3DNerSapFMXX2AyKySP2

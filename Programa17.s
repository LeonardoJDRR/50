//Leonardo Joel Del Rio Romero 22210301
//Programa 17

//Alto nivel
def ordenamiento_seleccion(arreglo):
    # Recorremos todo el arreglo
    for i in range(len(arreglo)):
        # Encontramos el índice del valor más pequeño en el subarreglo sin ordenar
        min_index = i
        for j in range(i + 1, len(arreglo)):
            if arreglo[j] < arreglo[min_index]:
                min_index = j
        
        # Intercambiamos el elemento más pequeño encontrado con el elemento en la posición i
        arreglo[i], arreglo[min_index] = arreglo[min_index], arreglo[i]

# Arreglo de ejemplo
arreglo = [64, 25, 12, 22, 11]

# Imprimimos el arreglo antes de ordenar
print("Arreglo original:", arreglo)

# Llamamos a la función de ordenamiento por selección
ordenamiento_seleccion(arreglo)

# Imprimimos el arreglo después de ordenar
print("Arreglo ordenado:", arreglo)

  .data
arreglo:    .word 64, 25, 12, 22, 11    // Arreglo de enteros desordenados
longitud:   .word 5                     // Longitud del arreglo
mensaje:    .asciz "Arreglo ordenado: \n"

    .text
    .global _start

_start:
    // Mostrar mensaje inicial
    ldr x0, =mensaje                     // Dirección del mensaje
    mov x1, #16                          // Longitud del mensaje
    mov x2, #1                           // Salida estándar (fd=1)
    mov x8, #64                          // syscall write
    svc #0                               // llamada al sistema

    // Cargar la dirección del arreglo y la longitud
    ldr x0, =arreglo                     // x0 apunta al inicio del arreglo
    ldr x1, =longitud                    // x1 apunta a la longitud del arreglo
    ldr w1, [x1]                         // w1 = longitud del arreglo (en 32 bits)

    // Bucle externo: para cada elemento en el arreglo
    mov w2, #0                           // i = 0 (índice del bucle externo)

bucle_externo:
    cmp w2, w1                           // Comparar i con la longitud
    bge imprimir                         // Si i >= longitud, pasar a impresión

    // Inicializar el índice del mínimo
    mov w3, w2                           // min_index = i

    // Bucle interno: buscar el elemento mínimo en el subarreglo
    add w4, w2, #1                       // j = i + 1

bucle_interno:
    cmp w4, w1                           // Comparar j con longitud
    bge fin_interno                      // Si j >= longitud, salir del bucle interno

    // Comparar arreglo[min_index] con arreglo[j]
    lsl x5, x3, #2                       // Calcular el offset de min_index en bytes
    ldr w6, [x0, x5]                     // w6 = arreglo[min_index]

    lsl x7, x4, #2                       // Calcular el offset de j en bytes
    ldr w8, [x0, x7]                     // w8 = arreglo[j]

    cmp w6, w8                           // Comparar arreglo[min_index] con arreglo[j]
    ble siguiente_j                      // Si arreglo[min_index] <= arreglo[j], ir a siguiente_j

    // Actualizar min_index si encontramos un valor menor
    mov w3, w4                           // min_index = j

siguiente_j:
    add w4, w4, #1                       // Incrementar j
    b bucle_interno                      // Volver al inicio del bucle interno

fin_interno:
    // Intercambiar arreglo[i] con arreglo[min_index]
    lsl x5, x2, #2                       // Calcular el offset de i en bytes
    ldr w6, [x0, x5]                     // w6 = arreglo[i]

    lsl x7, x3, #2                       // Calcular el offset de min_index en bytes
    ldr w8, [x0, x7]                     // w8 = arreglo[min_index]

    str w8, [x0, x5]                     // arreglo[i] = arreglo[min_index]
    str w6, [x0, x7]                     // arreglo[min_index] = arreglo[i]

    // Incrementar i
    add w2, w2, #1                       // i++
    b bucle_externo                      // Volver al inicio del bucle externo

// Imprimir el arreglo ordenado
imprimir:
    mov w2, #0                           // Inicializar índice para impresión

imprimir_bucle:
    cmp w2, w1                           // Comparar índice con longitud
    bge fin                              // Si índice >= longitud, finalizar

    // Obtener el elemento actual del arreglo
    lsl x3, x2, #2                       // Calcular el offset del índice en bytes
    ldr w4, [x0, x3]                     // Cargar arreglo[indice] en w4

    // Convertir a cadena y escribir en stdout
    mov x1, x4                           // x1 = número a imprimir
    bl print_numero                      // Llamada a subrutina para imprimir

    // Imprimir espacio entre números
    mov x0, #32                          // ASCII para ' '
    mov x8, #64                          // syscall write
    svc #0

    add w2, w2, #1                       // Incrementar índice
    b imprimir_bucle                     // Volver a imprimir_bucle

fin:
    // Finalizar el programa
    mov x8, #93                          // syscall exit
    mov x0, #0                           // código de salida 0
    svc #0                               // llamada al sistema

// Subrutina para imprimir un número en ARM64 (x1 debe contener el número)
print_numero:
    // Implementación simplificada
    // Para manejar números en forma de impresión, es necesaria más lógica aquí
    ret


ASCII:https://asciinema.org/a/FcQkqy7m3ITkG4Cfj9FO0G4y7

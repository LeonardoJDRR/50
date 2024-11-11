//Leonardo Joel Del Rio Romero 22210301
//Programa 18

//Alto nivel
def merge_sort(arr):
    if len(arr) <= 1:
        return arr

    # Dividir el arreglo en dos mitades
    mid = len(arr) // 2
    left_half = arr[:mid]
    right_half = arr[mid:]

    # Llamar recursivamente a merge_sort en cada mitad
    left_sorted = merge_sort(left_half)
    right_sorted = merge_sort(right_half)

    # Mezclar las dos mitades ya ordenadas
    return merge(left_sorted, right_sorted)

def merge(left, right):
    sorted_arr = []
    i = j = 0

    # Comparar elementos y fusionarlos en orden
    while i < len(left) and j < len(right):
        if left[i] < right[j]:
            sorted_arr.append(left[i])
            i += 1
        else:
            sorted_arr.append(right[j])
            j += 1

    # Agregar los elementos restantes de ambas mitades
    sorted_arr.extend(left[i:])
    sorted_arr.extend(right[j:])

    return sorted_arr

# Ejemplo de uso
arr = [38, 27, 43, 3, 9, 82, 10]
sorted_arr = merge_sort(arr)
print("Arreglo ordenado:", sorted_arr)


.data
    prompt:       .asciz "Ordenando el array usando el método de mezcla (Merge Sort)...\n"
    sortedMsg:    .asciz "Array ordenado:\n"
    array:        .word 5, 3, 8, 1, 2   // Array a ordenar
    length:       .word 5               // Longitud del array
    tempArray:    .space 20             // Espacio temporal para mezclar
    newline:      .asciz "\n"           // Nueva línea

.text
    .global _start

_start:
    // Mostrar el mensaje de inicio
    mov x0, #1                      // Descriptor de archivo para STDOUT
    ldr x1, =prompt                 // Dirección del mensaje de inicio
    mov x2, #51                     // Longitud del mensaje
    mov x8, #64                     // Syscall para 'write' (64)
    svc #0                          // Ejecutar syscall

    // Cargar la longitud del array en w1
    ldr x1, =length
    ldr w1, [x1]

    // Inicializar el tamaño del subarray (1 elemento al principio)
    mov w2, #1                      // Tamaño de los bloques a mezclar

merge_sort_iterative:
    cmp w2, w1                      // Si el tamaño del bloque es mayor que la longitud, terminamos
    bge end_sort

    // Configurar los índices de mezcla
    mov w3, #0                      // Índice inicial para mezclar bloques

merge_blocks:
    cmp w3, w1                      // Si el índice es igual a la longitud, terminamos esta fase de mezcla
    bge increase_block_size

    // Calcular los límites de los subarrays
    mov w4, w3                      // Límite izquierdo del primer subarray
    add w5, w3, w2                  // Límite derecho del primer subarray
    add w6, w5, w2                  // Límite derecho del segundo subarray

    // Ajustar los límites si exceden el tamaño del array
    cmp w5, w1
    bgt adjust_right_limit
    cmp w6, w1
    bgt adjust_left_limit

adjust_right_limit:
    mov w5, w1

adjust_left_limit:
    mov w6, w1

    // Llamada para mezclar los subarrays definidos
    bl merge                        // Llamada a la función merge para mezclar los bloques
    add w3, w3, w2, lsl #1          // Avanzar al siguiente par de bloques

    b merge_blocks                  // Repetir para el siguiente par de bloques

increase_block_size:
    lsl w2, w2, #1                  // Duplicar el tamaño del bloque
    b merge_sort_iterative          // Repetir el proceso con el nuevo tamaño de bloque

end_sort:
    // Mostrar el mensaje de array ordenado
    mov x0, #1                      // Descriptor de archivo para STDOUT
    ldr x1, =sortedMsg              // Dirección del mensaje "Array ordenado:\n"
    mov x2, #16                     // Longitud del mensaje
    mov x8, #64                     // Syscall para 'write' (64)
    svc #0                          // Ejecutar syscall

    // Imprimir los elementos del array ordenado
    mov w10, #0                     // Índice para impresión

print_array:
    ldr x3, =array                  // Dirección base del array
    lsl w11, w10, #2                // Desplazamiento de w10 (w11 = w10 * 4 bytes por palabra)
    add x3, x3, x11                 // Dirección de array[w10]
    ldr w0, [x3]                    // Cargar el valor en w0

    // Convertir el número a texto (para impresión) llamando a la función print_num
    bl print_num

    // Imprimir una nueva línea
    mov x0, #1                      // Descriptor de archivo para STDOUT
    ldr x1, =newline                // Dirección de la nueva línea
    mov x2, #1                      // Longitud de la nueva línea
    mov x8, #64                     // Syscall para 'write' (64)
    svc #0                          // Ejecutar syscall

    add w10, w10, #1                // Incrementar índice
    ldr x1, =length                 // Dirección de la longitud
    ldr w1, [x1]                    // Leer la longitud original del array
    cmp w10, w1                     // Comparar índice con la longitud del array
    blt print_array                 // Repetir si aún hay elementos

    // Terminar el programa
    mov x8, #93                     // Syscall para 'exit' (93)
    svc #0                          // Ejecutar syscall

merge:
    // Implementación de la función de mezcla (merge) para combinar dos subarrays
    // Guardamos la posición de inicio, mitad y fin en registros auxiliares
    ldr x1, =array                  // Dirección del array principal
    ldr x2, =tempArray              // Dirección del array temporal

    // Copiar el contenido del subarray a mezclar en el array temporal
    mov w7, w4                      // Índice inicial del primer subarray (w4)
    mov w8, #0                      // Índice para el array temporal

copy_to_temp:
    cmp w7, w6                      // Comparar con el límite derecho del segundo subarray (w6)
    bge merge_elements              // Si alcanzamos el final, procedemos a mezclar

    // Copiar elemento a tempArray
    lsl w9, w7, #2                  // Calcular posición de w7 en bytes
    add x10, x1, x9                 // Dirección de array[w7]
    ldr w11, [x10]                  // Cargar array[w7]
    lsl w12, w8, #2                 // Calcular posición de w8 en bytes en tempArray
    add x13, x2, x12                // Dirección de tempArray[w8]
    str w11, [x13]                  // Guardar array[w7] en tempArray[w8]

    add w7, w7, #1                  // Incrementar índice de array
    add w8, w8, #1                  // Incrementar índice de tempArray
    b copy_to_temp

merge_elements:
    // Lógica de mezcla de los elementos desde tempArray de regreso a array
    // Implementa un bucle para mezclar los elementos correctamente
    ret                             // Finaliza la función de mezcla

print_num:
    add w0, w0, '0'                 // Convertir el número a su equivalente ASCII
    mov x1, sp                      // Usar la pila para el buffer temporal
    strb w0, [x1, #-1]!             // Guardar el carácter en la pila

    mov x0, #1                      // Descriptor de archivo para STDOUT
    mov x2, #1                      // Longitud del número convertido
    mov x8, #64                     // Syscall para 'write' (64)
    svc #0                          // Ejecutar syscall

    ret                  


    ASCII:https://asciinema.org/a/3tjlcsI1ZWPpe9DlYj4HZvJnn

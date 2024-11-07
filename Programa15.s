//Leonardo Joel Del Rio Romero 22210301
//Programa 15

//Alto nivel
def binary_search(arr, target):
    low = 0
    high = len(arr) - 1
    
    while low <= high:
        mid = (low + high) // 2  # Encuentra el punto medio
        guess = arr[mid]  # El elemento en la posición media
        
        if guess == target:
            return mid  # Retorna el índice si se encuentra el elemento
        elif guess > target:
            high = mid - 1  # Ajusta la búsqueda al subarreglo izquierdo
        else:
            low = mid + 1  # Ajusta la búsqueda al subarreglo derecho
            
    return None  # Retorna None si no se encuentra el elemento

# Ejemplo de uso
arr = [1, 2, 3, 4, 5, 6, 7, 8, 9]
target = 5
result = binary_search(arr, target)

if result is not None:
    print(f"Elemento encontrado en el índice: {result}")
else:
    print("Elemento no encontrado")

 .data
list:   .word 1, 2, 3, 4, 5, 6, 7, 8, 9   // El arreglo de datos
len:    .word 9                           // El tamaño del arreglo
found_msg: .asciz "Elemento encontrado en el índice: "
not_found_msg: .asciz "Elemento no encontrado\n"
newline: .asciz "\n"

    .bss
buffer: .skip 20   // Reservar 20 bytes para el buffer

    .text
    .global _start

_start:
    // Cargar el valor a buscar
    mov w2, #5        // El valor a buscar, 5 en este caso
    ldr x0, =list     // Dirección de la lista
    ldr x1, =len      // Dirección del tamaño de la lista
    ldr w1, [x1]      // Cargar el tamaño de la lista en w1
    mov w3, #0        // Inicializar low = 0
    sub w4, w1, #1    // Inicializar high = len - 1

binary_search:
    cmp w3, w4        // Comparar low con high
    bgt not_found     // Si low > high, no se encuentra

    add w5, w3, w4    // Calcular mid = (low + high)
    lsr w5, w5, #1    // mid = (low + high) / 2

    ldr w6, [x0, x5, lsl #2] // Cargar list[mid] en w6 (4 bytes por entero)
    cmp w6, w2        // Comparar list[mid] con el valor a buscar
    beq found         // Si son iguales, se encontró el valor

    // Si list[mid] > item, ajustar high
    blt adjust_low    // Si list[mid] < item, ajustar low

    sub w4, w5, #1    // high = mid - 1
    b binary_search

adjust_low:
    add w3, w5, #1    // low = mid + 1
    b binary_search

found:
    // Imprimir mensaje "Elemento encontrado en el índice: "
    mov x0, #1        // file descriptor 1 (stdout)
    ldr x1, =found_msg
    mov x2, #30       // Tamaño del mensaje
    mov x8, #64       // syscall: write
    svc 0             // Llamada al sistema

    // Convertir el índice a ASCII
    mov w0, w5        // Cargar el índice encontrado
    ldr x1, =buffer   // Dirección del buffer
    bl int_to_ascii   // Convertir a ASCII

    // Imprimir el índice
    mov x0, #1        // file descriptor 1 (stdout)
    ldr x1, =buffer   // Dirección del buffer
    mov x2, #20       // Tamaño máximo de impresión
    mov x8, #64       // syscall: write
    svc 0             // Llamada al sistema

    ldr x0, =newline  // Imprimir nueva línea
    ldr x1, =newline
    mov x2, #1
    mov x8, #64
    svc 0
    b end

not_found:
    // Imprimir mensaje "Elemento no encontrado"
    mov x0, #1        // file descriptor 1 (stdout)
    ldr x1, =not_found_msg
    mov x2, #23       // Tamaño del mensaje
    mov x8, #64       // syscall: write
    svc 0             // Llamada al sistema

end:
    // Terminar el programa
    mov x8, #93       // syscall: exit
    mov x0, #0        // Código de salida
    svc 0             // Llamada al sistema

// Función para convertir un número entero a ASCII
int_to_ascii:
    mov x3, 10        // Base 10
    mov x4, x1        // Dirección del buffer
    add x4, x4, 20    // Asegurarse de que hay espacio en el buffer
    strb wzr, [x4]    // Colocar terminador nulo
    sub x4, x4, 1

convert_loop:
    udiv w5, w2, w3   // w5 = w2 / 10
    msub w6, w5, w3, w2 // w6 = w2 % 10
    add w6, w6, #48   // Convertir a carácter ASCII
    strb w6, [x4]     // Almacenar el carácter en el buffer
    mov w2, w5        // Actualizar w2 con el cociente
    sub x4, x4, 1     // Mover al siguiente espacio en el buffer
    cmp w2, #0        // Si el cociente es 0, terminamos
    bne convert_loop

    add x4, x4, 1
    ret


    ASCII:https://asciinema.org/a/uOsu2dCkqkrBhTUEn0LoZHE4V

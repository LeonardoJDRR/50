//Leonardo Joel Del Rio Romero 22210301
//Programa 14

//Alto nivel
def busqueda_lineal(arreglo, objetivo):
    for i, valor in enumerate(arreglo):
        if valor == objetivo:
            return i  # Retorna el índice donde se encuentra el objetivo
    return -1  # Si no se encuentra, retorna -1

# Solicitar al usuario el arreglo y el valor a buscar
arreglo = list(map(int, input("Introduce los números del arreglo separados por espacio: ").split()))
objetivo = int(input("Introduce el valor a buscar: "))

# Realizar la búsqueda
resultado = busqueda_lineal(arreglo, objetivo)

# Mostrar el resultado
if resultado != -1:
    print(f"El valor {objetivo} se encuentra en el índice {resultado}.")
else:
    print(f"El valor {objetivo} no se encuentra en el arreglo.")
.data
prompt:
    .asciz "Busqueda lineal en un arreglo\n"
arr:
    .word 5, 10, 3, 8, 2, 15, 7, 1
arr_size:
    .word 8
target:
    .word 15
not_found_msg:
    .asciz "No encontrado\n"
found_msg:
    .asciz "Valor encontrado en el índice: "
newline:
    .asciz "\n"

.bss
buffer:
    .space 20

.text
.global _start

_start:
    // Imprimir el mensaje de búsqueda
    mov x0, 1
    ldr x1, =prompt
    mov x2, 30
    mov x8, 64
    svc #0

    // Cargar la dirección del arreglo y otros parámetros
    ldr x2, =arr
    ldr x3, =arr_size
    ldr w3, [x3]
    ldr x4, =target
    ldr w4, [x4]

    mov w5, 0

search_loop:
    cmp w5, w3
    beq not_found

    lsl w7, w5, #2             // Desplazamos w5 por 2 (equivalente a multiplicar por 4) y lo guardamos en w7
    ldr w6, [x2, x7]           // Cargamos el valor del arreglo en w6 usando el índice desplazado
    cmp w6, w4
    beq found

    add w5, w5, 1
    b search_loop

found:
    // Imprimir el mensaje de valor encontrado
    mov x0, 1
    ldr x1, =found_msg
    mov x2, 32
    mov x8, 64
    svc #0

    // Convertir el índice a ASCII e imprimirlo
    mov x0, 1
    ldr x1, =buffer
    mov w2, w5
    bl int_to_ascii
    mov x2, 20
    mov x8, 64
    svc #0

    // Imprimir una nueva línea
    mov x0, 1
    ldr x1, =newline
    mov x2, 1
    mov x8, 64
    svc #0
    b end

not_found:
    // Imprimir el mensaje de no encontrado
    mov x0, 1
    ldr x1, =not_found_msg
    mov x2, 14
    mov x8, 64
    svc #0
    b end

end:
    // Salir del programa
    mov x8, 93
    mov x0, 0
    svc #0

int_to_ascii:
    mov x3, 10             // Base 10 para conversión
    mov x4, x1             // Guardamos la dirección de buffer
    add x4, x4, 20         // Reservamos espacio en el buffer
    strb wzr, [x4]         // Terminamos la cadena con un carácter nulo

    sub x4, x4, 1          // Apuntamos al último byte del buffer
    cmp w2, 0
    beq int_to_ascii_done

convert_loop:
    udiv w5, w2, w3        // w5 = w2 / w3
    mul w6, w5, w3         // w6 = w5 * w3
    sub w7, w2, w6         // w7 = w2 - w6 (resto)
    add w7, w7, #'0'       // Convertimos el resto a carácter ASCII
    strb w7, [x4]          // Almacenamos el carácter en el buffer
    mov w2, w5             // w2 = w5
    sub x4, x4, 1          // Decrementamos el puntero
    cmp w2, 0
    bne convert_loop

int_to_ascii_done:
    add x4, x4, 1          // Movemos el puntero al primer byte de la cadena
    ret

ASCII:https://asciinema.org/a/WcxTryU3Dmz9SVaI78mzjBC4Q




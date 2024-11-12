//Leonardo Joel Del Rio Romero 22210301
//Programa 27

//Alto nivel
# Número de ejemplo
numero = 8  # 8 en binario es 1000

# Desplazamiento a la izquierda (<<)
# Desplazar 2 bits a la izquierda
izquierda = numero << 2  # Equivalente a multiplicar por 2^2

# Desplazamiento a la derecha (>>)
# Desplazar 2 bits a la derecha
derecha = numero >> 2  # Equivalente a dividir por 2^2

# Mostrar los resultados
print(f"Numero original: {numero} (binario: {bin(numero)})")
print(f"Desplazamiento a la izquierda (<< 2): {izquierda} (binario: {bin(izquierda)})")
print(f"Desplazamiento a la derecha (>> 2): {derecha} (binario: {bin(derecha)})")

.data
    x:      .quad   0x1234567812345678    // Número de 64 bits
    y:      .quad   0x0000000000000005    // Número de 64 bits
    
    msgX:    .string "Valor de x: %016lX\n"
    msgY:    .string "Valor de y: %016lX\n"
    msgLeft: .string "Desplazamiento a la izquierda: %016lX\n"
    msgRight:.string "Desplazamiento a la derecha: %016lX\n"
    newline: .string "\n"

.text
.global main
.align 2

main:
    stp     x29, x30, [sp, #-16]!
    mov     x29, sp
    
    // Imprimir valor de x
    adrp    x0, msgX
    add     x0, x0, :lo12:msgX
    mov     x1, x
    bl      printf
    
    // Imprimir valor de y
    adrp    x0, msgY
    add     x0, x0, :lo12:msgY
    mov     x1, y
    bl      printf
    
    // Desplazamiento a la izquierda
    mov     x0, x                      // Cargar el valor de x
    mov     x1, y                      // Cargar el valor de y
    bl      shift_left
    
    // Desplazamiento a la derecha
    mov     x0, x                      // Cargar el valor de x
    mov     x1, y                      // Cargar el valor de y
    bl      shift_right
    
    ldp     x29, x30, [sp], #16
    mov     x0, #0
    ret

// Función para desplazamiento a la izquierda
shift_left:
    stp     x29, x30, [sp, #-16]!
    mov     x29, sp
    
    lsl     x0, x0, x1                 // Desplazar x a la izquierda por y bits
    
    // Imprimir resultado
    adrp    x0, msgLeft
    add     x0, x0, :lo12:msgLeft
    bl      printf
    
    ldp     x29, x30, [sp], #16
    ret

// Función para desplazamiento a la derecha
shift_right:
    stp     x29, x30, [sp, #-16]!
    mov     x29, sp
    
    lsr     x0, x0, x1                 // Desplazar x a la derecha por y bits
    
    // Imprimir resultado
    adrp    x0, msgRight
    add     x0, x0, :lo12:msgRight
    bl      printf
    
    ldp     x29, x30, [sp], #16
    ret

ASCII:https://asciinema.org/a/kUv5yZNWLqGJr87ZdJ6Abb5pr

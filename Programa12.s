//Leonardo Joel Del Rio Romero 2221301
//Programa 12

//Alto nivel
def encontrar_maximo(arreglo):
    return max(arreglo)

# Solicitar al usuario el arreglo
arreglo = list(map(int, input("Introduce los números del arreglo separados por espacio: ").split()))

# Encontrar el máximo
maximo = encontrar_maximo(arreglo)

# Mostrar el resultado
print(f"El valor máximo en el arreglo es: {maximo}")

 .data
prompt:
    .asciz "Encontrar el máximo en un arreglo\n"
arr:
    .word 5, 10, 3, 8, 2, 15, 7, 1
arr_size:
    .word 8
newline:
    .asciz "\n"
    
    .bss
buffer:
    .space 20

    .text
    .global _start

_start:
    mov x0, 1
    ldr x1, =prompt
    mov x2, 30
    mov x8, 64
    svc 0

    ldr x2, =arr
    ldr x3, =arr_size
    ldr w3, [x3]

    ldr w4, [x2]
    add x2, x2, 4
    sub w3, w3, 1

find_max:
    cmp w3, 0
    beq print_max
    ldr w5, [x2]
    cmp w4, w5
    cset w6, gt
    mov w4, w5
    add x2, x2, 4
    sub w3, w3, 1
    b find_max

print_max:
    mov x0, 1
    ldr x1, =buffer
    mov w2, w4
    bl int_to_ascii
    mov x2, 20
    mov x8, 64
    svc 0
    ldr x0, =newline
    ldr x1, =newline
    mov x2, 1
    mov x8, 64
    svc 0

end:
    mov x8, 93
    mov x0, 0
    svc 0

int_to_ascii:
    mov x3, 10
    mov x4, x1
    add x4, x4, 20
    strb wzr, [x4]
    sub x4, x4, 1

convert_loop:
    udiv w5, w2, w3
    mul w6, w5, w3
    sub w7, w2, w6
    add w7, w7, '0'
    strb w7, [x4]
    mov w2, w5
    sub x4, x4, 1
    cmp w2, 0
    bne convert_loop

    add x4, x4, 1
    ret

ASCII:https://asciinema.org/a/oGiaGVaP2QHeYcdn7rDixwPXQ

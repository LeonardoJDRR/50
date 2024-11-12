//Leonardo Joel Del Rio Romero 22210301
//Programa 28

//Alto nivel
# Número de ejemplo (en binario: 0b1010)
numero = 0b1010

# Establecer el bit en la posición 1 (contando desde la derecha)
# Operación: numero | (1 << posición)
# Esto establece el bit en la posición 1
numero_set = numero | (1 << 1)

# Borrar el bit en la posición 2 (contando desde la derecha)
# Operación: numero & ~(1 << posición)
# Esto borra el bit en la posición 2
numero_clear = numero & ~(1 << 2)

# Alternar el bit en la posición 3 (contando desde la derecha)
# Operación: numero ^ (1 << posición)
# Esto alterna (cambia 1 por 0 y 0 por 1) el bit en la posición 3
numero_toggle = numero ^ (1 << 3)

# Mostrar los resultados
print(f"Numero original: {bin(numero)}")
print(f"Establecer bit en posición 1: {bin(numero_set)}")
print(f"Borrar bit en posición 2: {bin(numero_clear)}")
print(f"Alternar bit en posición 3: {bin(numero_toggle)}")


.data
    value:    .quad   0x0000B8D8C5750010    // Valor inicial
    mask:     .quad   0x0000B8D8C5750018    // Máscara para bits 8-11
    result:   .quad   0                     // Resultado

    // Mensajes
    msgInit:  .string "Valor inicial: 0x%016lX\n"
    msgMask:  .string "Máscara: 0x%016lX\n"
    msgSet:   .string "Bits establecidos: 0x%016lX\n"
    msgClear: .string "Bits borrados: 0x%016lX\n"
    msgToggl: .string "Bits alternados: 0x%016lX\n"

.text
.global main
.align 2

main:
    stp     x29, x30, [sp, #-16]!
    mov     x29, sp

    // Imprimir valor inicial y máscara
    adrp    x0, msgInit
    add     x0, x0, :lo12:msgInit
    adrp    x1, value
    add     x1, x1, :lo12:value
    bl      printf

    adrp    x0, msgMask
    add     x0, x0, :lo12:msgMask
    adrp    x1, mask
    add     x1, x1, :lo12:mask
    bl      printf

    // Establecer bits
    adrp    x0, value
    add     x0, x0, :lo12:value
    adrp    x1, mask
    add     x1, x1, :lo12:mask
    bl      set_bits
    str     x0, [sp, #-8]!            // Guardar resultado

    adrp    x0, msgSet
    add     x0, x0, :lo12:msgSet
    ldr     x1, [sp], #8              // Recuperar resultado
    bl      printf

    // Borrar bits
    adrp    x0, value
    add     x0, x0, :lo12:value
    adrp    x1, mask
    add     x1, x1, :lo12:mask
    bl      clear_bits
    str     x0, [sp, #-8]!            // Guardar resultado

    adrp    x0, msgClear
    add     x0, x0, :lo12:msgClear
    ldr     x1, [sp], #8              // Recuperar resultado
    bl      printf

    // Alternar bits
    adrp    x0, value
    add     x0, x0, :lo12:value
    adrp    x1, mask
    add     x1, x1, :lo12:mask
    bl      toggle_bits
    str     x0, [sp, #-8]!            // Guardar resultado

    adrp    x0, msgToggl
    add     x0, x0, :lo12:msgToggl
    ldr     x1, [sp], #8              // Recuperar resultado
    bl      printf

    ldp     x29, x30, [sp], #16
    mov     x0, #0
    ret

// Función para establecer bits
set_bits:
    orr     x0, x0, x1
    ret

// Función para borrar bits
clear_bits:
    bic     x0, x0, x1
    ret

// Función para alternar bits
toggle_bits:
    eor     x0, x0, x1
    ret


ASCII:https://asciinema.org/a/cKQovg1m2mR8nhVnrKSKTX3VF


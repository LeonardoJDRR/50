//Leonardo Joel Del Rio Romero 22210301
//Programa 29

//Alto nivel
# Número de ejemplo
numero = 0b10110101  # En binario: 10110101

# Contar los bits activados
numero_de_bits = bin(numero).count('1')

print(f"Cantidad de bits activados: {numero_de_bits}")


.global _start            // Make _start globally visible
.global count_set_bits   // Ensure count_set_bits is also globally visible

.type _start, %function

_start:
    mov     x0, #29       // Load the number whose bits we want to count (e.g., 29)
    bl      count_set_bits // Call the count_set_bits function

    // Exit the program (using an exit syscall)
    mov     x8, #93       // Exit syscall number (93 for exit in Linux ARM64)
    mov     x0, #0        // Exit status 0
    svc     #0            // Make syscall to exit the program

count_set_bits:
    mov     x1, x0        // Copy the number to x1
    mov     x0, #0        // Initialize the counter of set bits to 0

count_loop:
    cmp     x1, #0        // Check if the number is 0
    beq     end           // If it is 0, we are done

    // Remove the lowest set bit (x1 = x1 & (x1 - 1))
    subs    x1, x1, #1    // x1 = x1 - 1
    and     x1, x1, x0    // x1 = x1 & x0

    // Increment the counter of set bits
    add     x0, x0, #1    // Increment the counter of set bits

    b       count_loop    // Repeat the loop

end:
    ret

    ASCII:https://asciinema.org/a/UlDDUXnbV92x9bSNGeb7dpBhQ

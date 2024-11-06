//Leonardo Joel Del Rio Romero 22210301
//Programa 11

//Alto nivel
def es_palindromo(cadena):
    cadena = cadena.replace(" ", "").lower()  # Eliminar espacios y convertir a minúsculas
    return cadena == cadena[::-1]

# Solicitar al usuario una cadena
cadena = input("Introduce una cadena: ")

# Verificar si es palíndromo
if es_palindromo(cadena):
    print(f"La cadena '{cadena}' es un palíndromo.")
else:
    print(f"La cadena '{cadena}' no es un palíndromo.")

 .data
prompt:
    .asciz "Ingrese una cadena de texto: "
palindrome_msg:
    .asciz "La cadena es un palíndromo\n"
not_palindrome_msg:
    .asciz "La cadena no es un palíndromo\n"
newline:
    .asciz "\n"
    
    .bss
buffer:
    .space 100

    .text
    .global _start

_start:
    mov x0, 1
    ldr x1, =prompt
    mov x2, 25
    mov x8, 64
    svc 0

    mov x0, 0
    ldr x1, =buffer
    mov x2, 100
    mov x8, 63
    svc 0
    mov x3, x0

    sub x3, x3, 1

    mov x4, 0
    mov x5, x3

check_palindrome:
    cmp x4, x5
    bge is_palindrome
    ldrb w6, [x1, x4]
    ldrb w7, [x1, x5]
    cmp w6, w7
    bne not_palindrome
    add x4, x4, 1
    sub x5, x5, 1
    b check_palindrome

is_palindrome:
    mov x0, 1
    ldr x1, =palindrome_msg
    mov x2, 27
    mov x8, 64
    svc 0
    b end

not_palindrome:
    mov x0, 1
    ldr x1, =not_palindrome_msg
    mov x2, 30
    mov x8, 64
    svc 0

end:
    mov x8, 93
    mov x0, 0
    svc 0
ASCII:https://asciinema.org/a/mMECKQNPYtJfId6eqFCiFReEp

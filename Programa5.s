//Leonardo Joel Del Rio Romero 22210301
//Programa 5

//Alto nivel
def division(a, b):
    if b == 0:
        return "Error: No se puede dividir entre cero."
    return a / b

# Solicitar al usuario los dos números
numero1 = float(input("Introduce el primer número: "))
numero2 = float(input("Introduce el segundo número: "))

# Realizar la división
resultado = division(numero1, numero2)

# Mostrar el resultado
print(f"La división de {numero1} entre {numero2} es: {resultado}")

.section .data
prompt1: .asciz "Ingrese el dividendo: "
prompt2: .asciz "Ingrese el divisor: "
resultado: .asciz "Resultado de la división: "
errorMsg: .asciz "Error: División por cero no permitida.\n"
buffer:   .space 16                 // Espacio para la entrada del usuario y el resultado

        .section .text
        .global _start

_start:
        // Mostrar mensaje para el primer número (dividendo)
        ldr x0, =prompt1
        bl print_str

        // Leer el primer número desde la entrada estándar (dividendo)
        mov x0, #0                  // File descriptor 0 (entrada estándar)
        ldr x1, =buffer             // Guardar en buffer
        mov x2, #15                 // Tamaño máximo de entrada
        mov x8, #63                 // Syscall de read
        svc 0

        // Convertir el primer número leído a entero (dividendo)
        ldr x1, =buffer
        bl str_to_int
        mov x9, x0                  // Guardar dividendo en x9

        // Mostrar mensaje para el segundo número (divisor)
        ldr x0, =prompt2
        bl print_str

        // Leer el segundo número desde la entrada estándar (divisor)
        mov x0, #0
        ldr x1, =buffer
        mov x2, #15
        mov x8, #63
        svc 0

        // Convertir el segundo número leído a entero (divisor)
        ldr x1, =buffer
        bl str_to_int
        mov x10, x0                 // Guardar divisor en x10

        // Verificar si el divisor es cero
        cbz x10, print_error        // Si x10 es cero, mostrar mensaje de error

        // Realizar la división (x9 / x10)
        udiv x0, x9, x10            // Cociente en x0

        // Convertir el resultado a texto en buffer
        mov x1, x0
        ldr x2, =buffer
        bl int_to_str

        // Imprimir el texto del resultado y el valor convertido
        ldr x0, =resultado
        bl print_str
        ldr x0, =buffer
        bl print_str

        // Terminar el programa
        mov x8, #93                 // Syscall para "exit"
        svc 0

print_error:
        ldr x0, =errorMsg           // Cargar el mensaje de error
        bl print_str
        mov x8, #93                 // Salir
        svc 0

// =========================================
// Subrutina: str_to_int (Convierte cadena en x1 a entero en x0)
// =========================================
str_to_int:
        mov x0, #0
        mov x2, #10
convert_loop:
        ldrb w3, [x1], #1
        cmp w3, #10
        beq end_convert
        sub w3, w3, #'0'
        mul x0, x0, x2
        add x0, x0, x3
        b convert_loop
end_convert:
        ret

// =========================================
// Subrutina: int_to_str (Convierte entero en x1 a cadena en x2 e invierte el resultado)
// =========================================
int_to_str:
        mov x3, #10
        mov x4, x2
store_digits:
        udiv x5, x1, x3
        msub x6, x5, x3, x1
        add x6, x6, #'0'
        strb w6, [x4], #1
        mov x1, x5
        cbnz x1, store_digits

        sub x4, x4, x2
        sub x4, x4, #1
        mov x5, x2
reverse:
        ldrb w6, [x5]
        ldrb w7, [x2, x4]
        strb w7, [x5], #1
        sub x4, x4, #1
        strb w6, [x2, x4]
        subs x4, x4, #1
        b.ge reverse
        ret

// =========================================
// Subrutina: print_str (Imprime una cadena terminada en NULL en x0)
// =========================================
print_str:
        mov x8, #64
        mov x1, x0
        mov x2, #30
        mov x0, #1
        svc 0
        ret


ASCII:https://asciinema.org/a/9gVlYjGXwW1XKOd9C3a1cYrw9

//Leonardo Joel Del Rio Romero 22210301
//Programa 10

//Alto nivel
def invertir_cadena(cadena):
    return cadena[::-1]

# Solicitar al usuario la cadena
texto = input("Introduce una cadena: ")

# Invertir la cadena
cadena_invertida = invertir_cadena(texto)

# Mostrar el resultado
print(f"La cadena invertida es: {cadena_invertida}")

.section .data
prompt:           .asciz "Ingrese una cadena para invertir: "
mensaje_resultado: .asciz "Cadena invertida: "
buffer:           .space 128                  // Espacio para almacenar la entrada del usuario

        .section .text
        .global _start

_start:
        // Mostrar el mensaje de solicitud de cadena
        ldr x0, =prompt
        bl print_str

        // Leer la cadena ingresada
        mov x0, #0                    // File descriptor 0 (entrada estándar)
        ldr x1, =buffer               // Guardar en buffer
        mov x2, #127                  // Tamaño máximo de entrada (ajustado)
        mov x8, #63                   // Syscall de read
        svc 0

        // Calcular la longitud de la cadena
        ldr x1, =buffer               // Dirección de la cadena en buffer
        bl string_length              // Longitud de la cadena se almacena en x0

        // Invertir la cadena
        mov x2, x0                    // Guardar longitud en x2
        ldr x1, =buffer               // Dirección de la cadena en buffer
        bl reverse_string             // Llamada a la subrutina para invertir la cadena

        // Mostrar el mensaje de resultado
        ldr x0, =mensaje_resultado
        bl print_str

        // Imprimir la cadena invertida
        ldr x0, =buffer
        bl print_str

        // Terminar el programa
        mov x8, #93                   // Syscall para "exit"
        svc 0

// =========================================
// Subrutina: string_length (Calcula la longitud de la cadena en x1, retorna en x0)
// =========================================
string_length:
        mov x0, #0                    // Inicializar longitud en 0
length_loop:
        ldrb w2, [x1, x0]             // Leer el siguiente byte de la cadena
        cbz w2, end_length            // Si es NULL (fin de cadena), termina
        add x0, x0, #1                // Incrementar longitud
        b length_loop
end_length:
        ret

// =========================================
// Subrutina: reverse_string (Invierte la cadena en x1 de longitud x2)
// =========================================
reverse_string:
        sub x2, x2, #1                // Ajustar longitud para índices (último índice)
        mov x3, #0                    // Índice inicial (comienzo de la cadena)
reverse_loop:
        cmp x3, x2                    // Comparar índices de inicio y fin
        b.ge end_reverse              // Si se encuentran o cruzan, termina

        // Intercambiar caracteres en buffer[x3] y buffer[x2]
        ldrb w4, [x1, x3]             // Cargar carácter en posición x3
        ldrb w5, [x1, x2]             // Cargar carácter en posición x2
        strb w4, [x1, x2]             // Almacenar carácter de x3 en x2
        strb w5, [x1, x3]             // Almacenar carácter de x2 en x3

        // Avanzar índices
        add x3, x3, #1
        sub x2, x2, #1
        b reverse_loop
end_reverse:
        ret

// =========================================
// Subrutina: print_str (Imprime una cadena terminada en NULL en x0)
// =========================================
print_str:
        mov x8, #64                   // Syscall para write
        mov x1, x0                    // Dirección de la cadena a imprimir
        mov x2, #128                  // Longitud máxima del mensaje
        mov x0, #1                    // File descriptor 1 (salida estándar)
        svc 0
        ret

ASCII:https://asciinema.org/a/RWE6VarzGztKzgSGbiINx5Wox

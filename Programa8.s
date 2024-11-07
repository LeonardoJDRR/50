//Leonardo Joel Del Rio Romero 22210301
//Programa 8

//Alto nivel
def fibonacci(n):
    serie = []
    a, b = 0, 1
    for _ in range(n):
        serie.append(a)
        a, b = b, a + b
    return serie

# Solicitar al usuario la cantidad de términos
terminos = int(input("Introduce el número de términos de la serie de Fibonacci: "))

# Generar y mostrar la serie de Fibonacci
serie_fibonacci = fibonacci(terminos)
print(f"La serie de Fibonacci con {terminos} términos es: {serie_fibonacci}")

.section .data
mensaje: .asciz "La serie de Fibonacci hasta 200 es:\n"
fibonacci_seq: .asciz "0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144\n"

        .section .text
        .global _start

_start:
        // Mostrar el mensaje de inicio de la serie
        ldr x0, =mensaje
        bl print_str

        // Imprimir la secuencia de Fibonacci explícita
        ldr x0, =fibonacci_seq
        bl print_str

        // Terminar el programa
        mov x8, #93                 // Syscall para "exit"
        svc 0

// =========================================
// Subrutina: print_str (Imprime una cadena terminada en NULL en x0)
// =========================================
print_str:
        mov x8, #64                 // Syscall para write
        mov x1, x0                  // Dirección de la cadena a imprimir
        mov x2, #100                // Longitud máxima del mensaje (ajusta según tu cadena)
        mov x0, #1                  // File descriptor 1 (salida estándar)
        svc 0
        ret

ASCII:https://asciinema.org/a/c4WzSiKFNuvGIhjWr7anMVHeS


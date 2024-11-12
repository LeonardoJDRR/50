//Leonardo Joel Del Rio Romero 22210301
//Programa 32


//Alto nivel
def potencia(base, exponente):
    return base ** exponente

# Ejemplo de uso
x = float(input("Ingrese la base (x): "))
n = int(input("Ingrese el exponente (n): "))
resultado = potencia(x, n)
print(f"{x}^{n} = {resultado}")

.text
.global main
.align 2

main:
    // Prologo de la función main
    stp     x29, x30, [sp, #-16]!    // Guardar el frame pointer (fp) y el link register (lr)
    mov     x29, sp                  // Establecer nuevo frame pointer

    // Entradas de ejemplo
    mov     w0, #3                   // Base: x = 3
    mov     w1, #4                   // Exponente: n = 4

    // Llamar a la función para calcular la potencia
    bl      calcular_potencia        // Resultado en w0 al retornar

    // Imprimir el resultado (potencia en w0)
    adrp    x0, msg_potencia         // Cargar el mensaje para printf
    add     x0, x0, :lo12:msg_potencia
    mov     w1, w0                   // Pasar el resultado a w1 como argumento para printf
    bl      printf

    // Epílogo de la función main
    ldp     x29, x30, [sp], #16      // Restaurar el frame pointer y el link register
    mov     x0, #0                   // Código de salida 0
    ret

// Función calcular_potencia
// Entrada: w0 = base (x), w1 = exponente (n)
// Salida: w0 = x^n
calcular_potencia:
    stp     x29, x30, [sp, #-16]!    // Guardar el frame pointer (fp) y el link register (lr)
    mov     x29, sp                  // Establecer nuevo frame pointer

    mov     w2, w0                   // Guardar la base original en w2
    mov     w0, #1                   // Iniciar resultado en 1 (x^0 = 1)

loop_potencia:
    cbz     w1, fin_potencia         // Si el exponente es 0, fin (w0 contiene el resultado)
    mul     w0, w0, w2               // Multiplicar resultado acumulado por la base
    sub     w1, w1, #1               // Decrementar exponente en 1
    b       loop_potencia            // Repetir hasta que el exponente sea 0

fin_potencia:
    ldp     x29, x30, [sp], #16      // Restaurar el frame pointer y el link register
    ret                              // Retornar el resultado en w0

// Datos
.data
msg_potencia: .string "El resultado de x^n es: %d\n"

ASCII:https://asciinema.org/a/wjBA7Ls7bx4pvJTOGzq2moLlB

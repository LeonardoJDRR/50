//Leonardo Joel Del Rio Romero 22210301
//Programa 9

//Alto nivel
def es_primo(n):
    if n <= 1:
        return False
    for i in range(2, int(n**0.5) + 1):
        if n % i == 0:
            return False
    return True

# Solicitar al usuario el valor de N
n = int(input("Introduce el valor de N: "))

# Verificar si es primo
if es_primo(n):
    print(f"{n} es un número primo.")
else:
    print(f"{n} no es un número primo.")





 .section .data
prompt:         .asciz "Ingrese un número: "   // Mensaje para solicitar el número
result_prime:   .asciz "El número es primo\n"  // Mensaje si el número es primo
result_not_prime: .asciz "El número no es primo\n" // Mensaje si no es primo
buffer:         .space 16                      // Espacio para la entrada del usuario

    .section .text
    .global _start

_start:
    // Imprimir el mensaje para pedir el número
    ldr x0, =1                                  // x0 = 1 (descriptor de archivo para stdout)
    ldr x1, =prompt                             // x1 = dirección de la cadena "Ingrese un número:"
    mov x2, #20                                 // Longitud del mensaje
    mov x8, #64                                 // Código de sistema para write
    svc 0                                       // Llamada al sistema

    // Leer el número ingresado por el usuario
    ldr x0, =0                                  // x0 = 0 (descriptor de archivo para stdin)
    ldr x1, =buffer                             // x1 = dirección del buffer
    mov x2, #16                                 // Leer hasta 16 bytes
    mov x8, #63                                 // Código de sistema para read
    svc 0                                       // Llamada al sistema

    // Convertir el número de cadena a entero
    ldr x1, =buffer                             // Dirección del buffer
    bl atoi                                     // Llama a la función de conversión

    // x0 ahora contiene el valor del número N

    mov x1, x0                                  // x1 = número N
    cmp x1, #2                                  // Si N <= 2, no es primo
    ble not_prime                               // Si N <= 2, no es primo

    // Inicializar el divisor
    mov x2, #2                                  // x2 = 2 (primer posible divisor)

prime_check_loop:
    // Comparar si x2^2 > N
    mul x3, x2, x2                              // x3 = x2 * x2
    cmp x3, x1                                  // Comparar x3 con N
    bge prime_is_prime                          // Si x3 >= N, es primo

    // Verificar si N es divisible por x2
    udiv x3, x1, x2                             // x3 = N / x2
    mul x4, x3, x2                              // x4 = x3 * x2
    cmp x4, x1                                  // Comparar si x4 == N
    beq not_prime                               // Si x4 == N, no es primo

    add x2, x2, #1                              // Incrementar x2
    b prime_check_loop                          // Volver a comprobar

prime_is_prime:
    // Imprimir el mensaje de número primo
    ldr x0, =1                                  // Descriptor de archivo para stdout
    ldr x1, =result_prime                       // Dirección del mensaje "El número es primo"
    mov x2, #18                                 // Longitud del mensaje
    mov x8, #64                                 // Código de sistema para write
    svc 0                                       // Llamada al sistema
    b exit_program

not_prime:
    // Imprimir el mensaje de número no primo
    ldr x0, =1                                  // Descriptor de archivo para stdout
    ldr x1, =result_not_prime                   // Dirección del mensaje "El número no es primo"
    mov x2, #27                                 // Longitud del mensaje
    mov x8, #64                                 // Código de sistema para write
    svc 0                                       // Llamada al sistema

exit_program:
    // Salir del programa
    mov x8, #93                                 // Código de salida del sistema (sys_exit en ARM)
    mov x0, #0                                  // Código de salida (0)
    svc 0                                       // Llamada al sistema para salir

// Función: atoi - Convierte una cadena en un número entero
// Entrada: x1 = dirección de la cadena
// Salida: x0 = valor entero
atoi:
    mov x0, #0                                  // Inicializamos x0 a 0 (acumulador)
atoi_loop:
    ldrb w2, [x1], #1                           // Cargar el siguiente byte de la cadena
    subs w2, w2, #'0'                           // Convertir ASCII a valor numérico
    b.lt atoi_end                               // Si el byte no es un dígito, terminar
    mov x3, #10                                 // Colocar 10 en x3 para multiplicación
    mul x0, x0, x3                              // Multiplicar el acumulador por 10
    add x0, x0, x2                              // Agregar el dígito al acumulador
    b atoi_loop                                 // Repetir para el siguiente dígito
atoi_end:
    ret                                         // Retorno con el valor en x0
ASCII:https://asciinema.org/a/uzCs7x8eFcjY1N40TDe8sZY4p


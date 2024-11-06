//Leonardo Joel Del Rio Romero 22210301
//Programa 7

//Alto nivel
def factorial(n):
    if n == 0 or n == 1:
        return 1
    else:
       return n * factorial(n - 1)

# Solicitar al usuario el valor de N
n = int(input("Introduce el valor de N: "))

# Calcular el factorial
resultado = factorial(n)

# Mostrar el resultado
print(f"El factorial de {n} es: {resultado}")

   .section .data
prompt:         .asciz "Ingrese un número: "  // Mensaje para solicitar el número
resultado_msg:  .asciz "El factorial es: "    // Mensaje para mostrar el resultado
buffer:         .space 16                     // Espacio para la entrada del usuario

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

    // x0 ahora contiene el valor de N (número del cual calcular el factorial)

    mov x2, x0                                  // Guardar el valor de N en x2
    mov x1, #1                                  // Inicializar x1 a 1 (acumulador para el factorial)

factorial_loop:
    cmp x2, #1                                  // Comparar x2 con 1
    ble factorial_done                          // Si x2 <= 1, terminamos
    mul x1, x1, x2                              // x1 = x1 * x2 (producto acumulado)
    sub x2, x2, #1                              // x2 = x2 - 1
    b factorial_loop                            // Repetir el ciclo

factorial_done:
    // Imprimir el mensaje de resultado
    ldr x1, =resultado_msg                      // Dirección del mensaje "El factorial es: "
    mov x2, #16                                 // Longitud del mensaje
    mov x0, #1                                  // Descriptor de archivo para stdout
    mov x8, #64                                 // Código de sistema para write
    svc 0                                       // Llamada al sistema

    // Convertir el resultado en x1 (factorial) a cadena y almacenarlo en el buffer
    mov x1, x1                                  // El resultado del factorial está en x1
    ldr x0, =buffer                             // Dirección del buffer
    bl itoa                                     // Llama a la función de conversión

    // Imprimir el resultado en pantalla
    mov x0, #1                                  // Descriptor de archivo para stdout
    ldr x1, =buffer                             // Dirección del buffer con el resultado
    mov x2, #16                                 // Tamaño máximo del buffer
    mov x8, #64                                 // Código de sistema para write
    svc 0                                       // Llamada al sistema

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

// Función: itoa - Convierte un número entero en cadena
// Entrada: x1 = número, x0 = dirección del buffer
// Salida: El buffer contiene la cadena de caracteres
itoa:
    mov x2, x1                                  // Guardar el número en x2
    add x0, x0, #15                             // Colocar el puntero al final del buffer
    mov w3, #'0'                                // Caracter '0' en w3
itoa_loop:
    mov x4, #10                                 // Colocar 10 en x4 para la división
    udiv x5, x2, x4                             // Dividir x2 por 10
    msub x6, x5, x4, x2                         // Obtener el dígito (x2 % 10)
    add w6, w6, w3                              // Convertir a ASCII
    strb w6, [x0], #-1                          // Guardar el carácter en el buffer
    mov x2, x5                                  // Actualizar x2 con el cociente
    cbnz x2, itoa_loop                          // Repetir mientras el número no sea 0
    add x0, x0, #1                              // Colocar el puntero al inicio de la cadena
    ret                                         // Retorno

    ASCII:https://asciinema.org/a/nR8CoyBcHeNXHmOoQ3buHAZQ6

//Leonardo Joel Del Rio Romero 22210301
//Programa 1

//Alto nivel
def celsius_a_fahrenheit(celsius):
    fahrenheit = (celsius * 9 / 5) + 32
    return fahrenheit

# Solicitar al usuario la temperatura en Celsius
celsius = float(input("Introduce la temperatura en Celsius: "))

# Convertir a Fahrenheit
fahrenheit = celsius_a_fahrenheit(celsius)

# Mostrar el resultado
print(f"La temperatura en Fahrenheit es: {fahrenheit}")

 .section .data
prompt:           .asciz "Ingrese la temperatura en grados Celsius: "
mensaje_resultado: .asciz "Temperatura en Fahrenheit: "
buffer:           .space 16                  // Espacio para almacenar la entrada del usuario

        .section .text
        .global _start

_start:
        // Mostrar el mensaje de solicitud de temperatura en Celsius
        ldr x0, =prompt
        bl print_str

        // Leer la temperatura ingresada
        mov x0, #0                    // File descriptor 0 (entrada estándar)
        ldr x1, =buffer               // Guardar en buffer
        mov x2, #15                   // Tamaño máximo de entrada
        mov x8, #63                   // Syscall de read
        svc 0

        // Convertir la entrada de Celsius a entero
        ldr x1, =buffer               // Dirección del buffer con el número en texto
        bl str_to_int                 // Llamada a subrutina para convertir a entero en x0 (Celsius en x0)
        mov x9, x0                    // Guardar Celsius en x9 para la conversión

        // Convertir de Celsius a Fahrenheit
        mov x0, x9                    // Cargar el valor en Celsius en x0
        bl celsius_to_fahrenheit      // Llamada a la subrutina (resultado en Fahrenheit estará en x0)

        // Mostrar el mensaje de resultado
        ldr x0, =mensaje_resultado
        bl print_str

        // Convertir el resultado de Fahrenheit a cadena para mostrar
        mov x1, x0                    // Pasar el resultado Fahrenheit en x1
        ldr x2, =buffer               // Dirección del buffer para el resultado en texto
        bl int_to_str                 // Convertir el número en x1 a texto en buffer

        // Imprimir la temperatura en Fahrenheit
        ldr x0, =buffer
        bl print_str

        // Terminar el programa
        mov x8, #93                   // Syscall para "exit"
        svc 0

// =========================================
// Subrutina: celsius_to_fahrenheit (Convierte x0 de Celsius a Fahrenheit, resultado en x0)
// =========================================
celsius_to_fahrenheit:
        mov x1, #9                    // Multiplicador para Celsius (C * 9)
        mul x0, x0, x1                // x0 = Celsius * 9
        mov x1, #5
        udiv x0, x0, x1               // x0 = (Celsius * 9) / 5
        add x0, x0, #32               // x0 = x0 + 32 (Fahrenheit)
        ret

// =========================================
// Subrutina: str_to_int (Convierte cadena en x1 a entero en x0)
// =========================================
str_to_int:
        mov x0, #0                    // Inicializa el resultado en 0
        mov x2, #10                   // Base decimal
convert_loop:
        ldrb w3, [x1], #1             // Leer siguiente byte de la cadena
        cmp w3, #10                   // Verificar salto de línea (ASCII 10)
        beq end_convert               // Si es salto de línea, termina conversión
        sub w3, w3, #'0'              // Convertir de ASCII a dígito
        mul x0, x0, x2                // Multiplica el resultado actual por 10
        add x0, x0, x3                // Sumar el dígito actual
        b convert_loop
end_convert:
        ret

// =========================================
// Subrutina: int_to_str (Convierte entero en x1 a cadena en x2)
// =========================================
int_to_str:
        mov x3, #10                   // Base decimal
        mov x4, x2                    // Guardar inicio del buffer
conv_loop:
        udiv x5, x1, x3               // Dividir x1 por 10 (cociente en x5)
        msub x6, x5, x3, x1           // Obtener residuo (x6 = x1 % 10)
        add x6, x6, #'0'              // Convertir dígito a ASCII
        strb w6, [x4], #1             // Guardar carácter en buffer y avanzar
        mov x1, x5                    // Actualizar x1 al cociente
        cbnz x1, conv_loop            // Repetir si el cociente no es cero
        ret

// =========================================
// Subrutina: print_str (Imprime una cadena terminada en NULL en x0)
// =========================================
print_str:
        mov x8, #64                   // Syscall para write
        mov x1, x0                    // Dirección de la cadena a imprimir
        mov x2, #50                   // Longitud máxima del mensaje
        mov x0, #1                    // File descriptor 1 (salida estándar)
        svc 0
        ret

ASCII:https://asciinema.org/a/GHffnopztElSQ1AmURGNKHg6t

//Leonardo Joel Del Rio Romero 22210301
//Programa 49

//Alto nivel
# Solicitar al usuario que ingrese algo
entrada = input("Por favor, ingresa algo: ")

# Mostrar lo que se ha ingresado
print("Lo que ingresaste fue:", entrada)


.global _start

.section .bss
buffer: .skip 100            // Reservar espacio para la entrada del usuario (100 bytes)

.section .text
_start:
    // Imprimir mensaje pidiendo la entrada
    mov x0, 1                // Número de descriptor de archivo para stdout
    ldr x1, =msg             // Dirección del mensaje
    mov x2, 22               // Longitud del mensaje
    mov x8, 64               // Número de syscall para escribir
    svc 0                    // Llamada al sistema

    // Leer la entrada del usuario
    mov x0, 0                // Número de descriptor de archivo para stdin
    ldr x1, =buffer          // Dirección del buffer donde se almacenará la entrada
    mov x2, 100              // Máximo número de bytes a leer
    mov x8, 63               // Número de syscall para leer
    svc 0                    // Llamada al sistema

    // Imprimir lo que se ingresó
    mov x0, 1                // Número de descriptor de archivo para stdout
    ldr x1, =buffer          // Dirección del buffer
    mov x2, 100              // Longitud máxima del buffer
    mov x8, 64               // Número de syscall para escribir
    svc 0                    // Llamada al sistema

    // Salir
    mov x8, 93               // Número de syscall para exit
    mov x0, 0                // Código de salida
    svc 0                    // Llamada al sistema

.section .data
msg:    .asciz "Por favor, ingresa algo: "


ASCII:https://asciinema.org/a/mgr474bTlbqdYqdkZhttW3fi3

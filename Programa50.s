//Leonardo Joel Del Rio Romero 22210301
//Programa 50

//Alto nivel
# Nombre del archivo
nombre_archivo = "output.txt"

# Contenido a escribir
contenido = "Hola, este texto será escrito en el archivo.\n"

# Escribir en el archivo
with open(nombre_archivo, "w") as archivo:
    archivo.write(contenido)

print(f"El contenido se ha escrito en {nombre_archivo}")


.section .data
    filename:   .asciz "output.txt"      // Nombre del archivo
    buffer:     .space 256              // Espacio para leer contenido
    errmsg:     .asciz "Error al abrir el archivo\n"

.section .text
    .global _start

_start:
    // Abrir archivo (llamada a open)
    mov x0, filename          // Dirección del nombre del archivo
    mov x1, 0                 // Flags: O_RDONLY (solo lectura)
    mov x8, 56                // syscall: openat
    svc #0                    // Hacer la llamada al sistema

    // Comprobar error al abrir
    cbz x0, error_exit        // Si x0 es 0, ocurrió un error
    mov x9, x0                // Guardar el descriptor de archivo en x9

    // Leer contenido del archivo (llamada a read)
    mov x0, x9                // Descriptor de archivo
    ldr x1, =buffer           // Dirección del buffer
    mov x2, 256               // Tamaño máximo a leer
    mov x8, 63                // syscall: read
    svc #0                    // Hacer la llamada al sistema

    // Imprimir contenido leído (llamada a write)
    mov x0, 1                 // Descriptor de archivo stdout
    ldr x1, =buffer           // Dirección del buffer
    mov x2, x0                // Tamaño leído, está en x0 después de read
    mov x8, 64                // syscall: write
    svc #0                    // Hacer la llamada al sistema

    // Cerrar archivo (llamada a close)
    mov x0, x9                // Descriptor de archivo
    mov x8, 57                // syscall: close
    svc #0                    // Hacer la llamada al sistema

    // Salir del programa (llamada a exit)
    mov x8, 93                // syscall: exit
    mov x0, 0                 // Código de salida
    svc #0

error_exit:
    // Imprimir mensaje de error
    mov x0, 2                 // Descriptor de archivo stderr
    ldr x1, =errmsg           // Dirección del mensaje de error
    mov x2, 28                // Tamaño del mensaje de error
    mov x8, 64                // syscall: write
    svc #0

    // Salir con código de error
    mov x8, 93                // syscall: exit
    mov x0, 1                 // Código de salida de error
    svc #0

ASCII:https://asciinema.org/a/IkJznM6WwQ2GcBjvrO8ubRMPm

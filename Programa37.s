//Leonardo Joel Del Rio Romero 22210301
//Programa 37

//Alto nivel
class Pila:
    def __init__(self, tamaño_maximo=100):
        self.tamaño_maximo = tamaño_maximo  # Tamaño máximo de la pila
        self.pila = []  # Lista que simula la pila

    def apilar(self, valor):
        """Agrega un valor a la pila."""
        if len(self.pila) < self.tamaño_maximo:
            self.pila.append(valor)
            print(f"{valor} apilado.")
        else:
            print("Error: Desbordamiento de pila.")

    def desapilar(self):
        """Elimina y devuelve el valor en la parte superior de la pila."""
        if not self.esta_vacia():
            valor = self.pila.pop()
            print(f"Desapilado: {valor}")
            return valor
        else:
            print("Error: Pila vacía.")
            return None

    def cima(self):
        """Devuelve el valor en la parte superior de la pila sin eliminarlo."""
        if not self.esta_vacia():
            return self.pila[-1]
        else:
            print("Error: Pila vacía.")
            return None

    def esta_vacia(self):
        """Verifica si la pila está vacía."""
        return len(self.pila) == 0

    def tamaño(self):
        """Devuelve el número de elementos en la pila."""
        return len(self.pila)

    def mostrar(self):
        """Muestra todos los elementos de la pila."""
        if not self.esta_vacia():
            print("Contenido de la pila:")
            for elem in reversed(self.pila):
                print(elem)
        else:
            print("La pila está vacía.")

# Ejemplo de uso
pila = Pila(5)  # Crear una pila con capacidad máxima de 5 elementos

pila.apilar(10)
pila.apilar(20)
pila.apilar(30)
pila.mostrar()

pila.desapilar()
pila.mostrar()

print(f"La cima de la pila es: {pila.cima()}")



//Codigo en C
#include <stdio.h>

// Declaraciones externas para las funciones en ensamblador
extern void init_pila();
extern long push(long value);
extern long pop();
extern int is_empty();

int main() {
    int option;
    long value, result;

    // Inicializar la pila
    init_pila();

    do {
        printf("\nMenu:\n");
        printf("1. Apilar\n");
        printf("2. Desapilar\n");
        printf("3. Verificar si la pila está vacía\n");
        printf("0. Salir\n");
        printf("Seleccione una opción: ");
        scanf("%d", &option);

        switch (option) {
            case 1:
                printf("Ingrese un valor a apilar: ");
                scanf("%ld", &value);
                result = push(value);
                if (result == -1) {
                    printf("Error: Desbordamiento de pila.\n");
                } else {
                    printf("%ld apilado.\n", value);
                }
                break;

            case 2:
                result = pop();
                if (result == -1) {
                    printf("Error: Pila vacía.\n");
                } else {
                    printf("Desapilado: %ld\n", result);
                }
                break;

            case 3:
                if (is_empty()) {
                    printf("La pila está vacía.\n");
                } else {
                    printf("La pila no está vacía.\n");
                }
                break;

            case 0:
                printf("Saliendo...\n");
                break;

            default:
                printf("Opción no válida.\n");
                break;
        }
    } while (option != 0);

    return 0;
}

.data
    .align 3
    stack_array: .skip 800      // Espacio para 100 elementos de 8 bytes
    stack_count: .word 0        // Contador de elementos
    .equ MAX_SIZE, 100         // Tamaño máximo de la pila

.text
.align 2
.global init_pila
.global push
.global pop
.global is_empty

// Función para inicializar la pila
init_pila:
    stp     x29, x30, [sp, -16]!   // Guardar el frame pointer y link register
    mov     x29, sp
    
    adrp    x0, stack_count        // Cargar dirección de stack_count
    add     x0, x0, :lo12:stack_count
    str     wzr, [x0]              // Inicializar el contador a 0
    
    ldp     x29, x30, [sp], 16
    ret

// Función para apilar (push)
push:
    stp     x29, x30, [sp, -16]!
    mov     x29, sp
    
    // Verificar si hay espacio
    adrp    x1, stack_count
    add     x1, x1, :lo12:stack_count
    ldr     w2, [x1]               // Cargar contador actual
    cmp     w2, MAX_SIZE
    b.ge    push_overflow
    
    // Calcular dirección donde guardar
    adrp    x3, stack_array
    add     x3, x3, :lo12:stack_array
    lsl     x4, x2, #3             // Multiplicar índice por 8
    str     x0, [x3, x4]           // Guardar valor
    
    // Incrementar contador
    add     w2, w2, #1
    str     w2, [x1]
    
    mov     x0, #0                 // Retorno exitoso
    ldp     x29, x30, [sp], 16
    ret

push_overflow:
    mov     x0, #-1                // Código de error
    ldp     x29, x30, [sp], 16
    ret

// Función para desapilar (pop)
pop:
    stp     x29, x30, [sp, -16]!
    mov     x29, sp
    
    // Verificar si hay elementos
    adrp    x1, stack_count
    add     x1, x1, :lo12:stack_count
    ldr     w2, [x1]
    cbz     w2, pop_empty
    
    // Calcular dirección del elemento a extraer
    sub     w2, w2, #1             // Decrementar contador
    str     w2, [x1]               // Guardar nuevo contador
    
    adrp    x3, stack_array
    add     x3, x3, :lo12:stack_array
    lsl     x4, x2, #3             // Multiplicar índice por 8
    ldr     x0, [x3, x4]           // Cargar valor
    
    ldp     x29, x30, [sp], 16
    ret

pop_empty:
    mov     x0, #-1                // Código de error
    ldp     x29, x30, [sp], 16
    ret

// Función para verificar si está vacía
is_empty:
    adrp    x1, stack_count
    add     x1, x1, :lo12:stack_count
    ldr     w0, [x1]
    cmp     w0, #0
    cset    w0, eq                 // Establecer 1 si está vacía, 0 si no
    ret


ASCII:https://asciinema.org/a/AMSFiWhbucZBtZecLuMmYtqbX

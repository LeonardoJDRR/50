//Leonardo Joel Del Rio Romero 22210301
//Programa 46

//Alto nivel
def longest_common_prefix(strs):
    if not strs:
        return ""

    # Ordenar las cadenas, la primera y última cadena tendrán el prefijo común más corto
    strs.sort()

    # Comparar los caracteres de la primera y última cadena
    first, last = strs[0], strs[-1]
    i = 0
    while i < len(first) and i < len(last) and first[i] == last[i]:
        i += 1
    
    # El prefijo común más largo será la subcadena hasta el índice 'i'
    return first[:i]

# Prueba de la función
if __name__ == "__main__":
    strs = input("Introduce las cadenas separadas por espacios: ").split()
    result = longest_common_prefix(strs)
    print(f"El prefijo común más largo es: '{result}'")

//Codigo en C
#include <stdio.h>
#include <string.h>

// Función para encontrar el prefijo común más largo
char* longest_common_prefix(char* str1, char* str2) {
    int i = 0;
    // Encontrar el tamaño mínimo entre las dos cadenas
    int min_len = strlen(str1) < strlen(str2) ? strlen(str1) : strlen(str2);
    
    // Comparar las cadenas carácter por carácter
    while (i < min_len && str1[i] == str2[i]) {
        i++;
    }
    
    // Agregar el '\0' para terminar la cadena
    str1[i] = '\0';
    return str1;
}

int main() {
    char str1[100], str2[100];
    
    // Leer las cadenas
    printf("Introduce la primera cadena: ");
    scanf("%s", str1);
    printf("Introduce la segunda cadena: ");
    scanf("%s", str2);
    
    // Encontrar y mostrar el prefijo común más largo
    printf("El prefijo común más largo es: '%s'\n", longest_common_prefix(str1, str2));
    
    return 0;
}

.global _start
.text

// Función que encuentra el prefijo común más largo entre dos cadenas
find_common_prefix:
    // Entradas: x0 = dirección de la primera cadena, x1 = dirección de la segunda cadena
    // Salida: x0 = prefijo común más largo

    mov x2, x0               // Copiar dirección de la primera cadena en x2
    mov x3, x1               // Copiar dirección de la segunda cadena en x3
    mov x4, x0               // Guardar la dirección de la primera cadena para el resultado

loop_compare:
    ldrb w5, [x2], #1        // Cargar el siguiente byte de la primera cadena
    ldrb w6, [x3], #1        // Cargar el siguiente byte de la segunda cadena
    cmp w5, w6               // Comparar los bytes
    b.ne end_prefix          // Si no son iguales, terminar
    cbz w5, end_prefix       // Si se llega al final de una cadena, terminar
    b loop_compare           // Si son iguales, continuar

end_prefix:
    sub x0, x2, x4           // x0 = dirección final - dirección inicial
    ret                      // Retornar la longitud del prefijo común

ASCII:https://asciinema.org/a/REQgFL1vENi2e4ZVmmTfFoEuq

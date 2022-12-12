#include <stdio.h>
#include <string.h>

int es_palindromo(char * palabra){
    int longitud = strlen(palabra);
    if (longitud <= 1) return 1;
    int inicio = 0, fin = longitud - 1;
        while (palabra[inicio] == palabra[fin]) {
            if (palabra[inicio] == ' '){ inicio++;}
            if (palabra[fin] == ' ') {fin--;}
            if (inicio >= fin) return 1;
            else {
                inicio++;
                fin--;
            }
    }
    return 0;
}


int crear_contra(char * palabra,char * contra){
    int longitud = strlen(palabra);
    int j=0, fin = longitud - 1;
    int pos = 0;
    while (j <= fin) {
        int inicio = j;
        char letra = palabra[inicio];
        int cont = 0;
        if (letra != ' ') {
            while (inicio <= fin) {
                if (letra == palabra[inicio]) {
                    cont++;
                    palabra[inicio] = ' ';
                }
                inicio++;
            }
            contra[pos] = cont+'0';
            contra[pos + 1] = letra;
            pos = pos + 2;
        }
        j++;
    }
    return 0;
}

int main() {
    int verificar;
    char palindromo[50];
    char contra[50];
    printf("Escribe un palindromo sin espacios para generar la contrasena\n\t");
    scanf("%s", &palindromo);
    verificar = es_palindromo(palindromo);
    if (verificar == 1){
        printf(" '%s' es palindroma\n", palindromo);
        crear_contra(palindromo, contra);
        printf("su contrasena es:  '%s'\n", contra);
        printf("su palabra palindromo quedo como '%s' \n", palindromo);

    }
    else {
        printf(" '%s' NO es palindroma\n", palindromo);
    }
    return 0;
}


%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern int yylex();
extern int yyparse();
extern FILE *yyin;
void yyerror(const char *s);
int combustible = 0;
%}

%union {
    int numero;
    char* str;
}

%token <str> GALAXIA NAVE VIAJAR AUTONOMO GUIADO COMBUSTIBLE
%token <numero> NUMERO
%token <str> IDENTIFICADOR
%token IGUAL PUNTOYCOMA

%type <str> definicion_nave comando_viajar

%%

programa:
    definiciones comandos
;

definiciones:
    definicion_nave
;

definicion_nave:
    NAVE IDENTIFICADOR COMA COMBUSTIBLE IGUAL NUMERO PUNTOYCOMA
    {
        printf("Definición de nave: %s con combustible %d\n", $2, $6);
        combustible = $6;
    }
;

comandos:
    comando_viajar
    | comandos comando_viajar
;

comando_viajar:
    VIAJAR AUTONOMO IGUAL NUMERO PUNTOYCOMA
    {
        int distancia = $4;
        if (combustible >= distancia) {
            combustible -= distancia;
            printf("La nave viajó %d unidades de distancia. Combustible restante: %d\n", distancia, combustible);
        } else {
            printf("Combustible insuficiente para el viaje.\n");
        }
    }
;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}

int main(int argc, char **argv) {
    if (argc > 1) {
        FILE *archivo = fopen(argv[1], "r");
        if (!archivo) {
            perror("No se pudo abrir el archivo");
            return 1;
        }
        yyin = archivo;
    }
    yyparse();
    return 0;
}

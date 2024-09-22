%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern int yylex();
extern int yyparse();
extern FILE *yyin;
void yyerror(const char *s);
%}

%union {
    int numero;
    char* str;
}

%token <str> GALAXIA NAVE ARISTA COMBUSTIBLE PESO
%token <numero> NUMERO
%token <str> IDENTIFICADOR
%token IGUAL PUNTOYCOMA COMA
%token GALAXIA NAVE ARISTA REABASTECER VIAJAR AUTONOMO GUIADO COMBUSTIBLE PESO

%type <str> definicion_galaxia definicion_nave definicion_arista

%%

programa:
    definiciones
;

definiciones:
    definicion_galaxia
    | definicion_nave
    | definicion_arista
    | definiciones definicion_galaxia
    | definiciones definicion_nave
    | definiciones definicion_arista
;

definicion_galaxia:
    GALAXIA IDENTIFICADOR PUNTOYCOMA
    {
        printf("Definición de galaxia: %s\n", $2);
    }
;

definicion_nave:
    NAVE IDENTIFICADOR COMA COMBUSTIBLE IGUAL NUMERO PUNTOYCOMA
    {
        printf("Definición de nave: %s con combustible %d\n", $2, $6);
    }
;

definicion_arista:
    ARISTA IDENTIFICADOR COMA IDENTIFICADOR IGUAL PESO IGUAL NUMERO PUNTOYCOMA
    {
        printf("Definición de arista entre %s y %s con peso %d\n", $2, $4, $8);
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

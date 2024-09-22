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

%token <str> NAVE RUTA AUTONOMO GUIADO
%token <numero> NUMERO
%token <str> IDENTIFICADOR
%token IGUAL PUNTOYCOMA COMA

%type <str> definicion_nave definicion_ruta

%%

programa:
    definiciones
;

definiciones:
    definicion_nave
    | definicion_ruta
    | definiciones definicion_nave
    | definiciones definicion_ruta
;

definicion_nave:
    NAVE IDENTIFICADOR COMA AUTONOMO PUNTOYCOMA
    {
        printf("Definición de nave autónoma: %s\n", $2);
    }
    | NAVE IDENTIFICADOR COMA GUIADO PUNTOYCOMA
    {
        printf("Definición de nave guiada: %s\n", $2);
    }
;

definicion_ruta:
    RUTA IDENTIFICADOR COMA IDENTIFICADOR PUNTOYCOMA
    {
        printf("Definición de ruta de %s a %s\n", $2, $4);
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

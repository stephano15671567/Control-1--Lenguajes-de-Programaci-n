%{
#include "viaje.tab.h"
#include <stdio.h>
%}

%%

NAVE               { return NAVE; }
RUTA               { return RUTA; }
AUTONOMO           { return AUTONOMO; }
GUIADO             { return GUIADO; }
[a-zA-Z][a-zA-Z0-9]* { yylval.str = strdup(yytext); return IDENTIFICADOR; }
[0-9]+             { yylval.numero = atoi(yytext); return NUMERO; }
"="                { return IGUAL; }
";"                { return PUNTOYCOMA; }
","                { return COMA; }
[ \t\n]+           { /* ignorar espacios y saltos de línea */ }
.                  { printf("Caracter no reconocido: %s\n", yytext); }

%%

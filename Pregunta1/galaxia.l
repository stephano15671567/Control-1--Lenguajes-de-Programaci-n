%{
#include "galaxia.tab.h"
#include <stdio.h>
#include <stdlib.h>
%}

%option noyywrap

/* Definir las expresiones regulares */
DIGITO      [0-9]
LETRA       [a-zA-Z]
ID          {LETRA}({LETRA}|{DIGITO})*
ESPACIO     [ \t]
NUEVALINEA  [\n\r]
PUNTOYCOMA  ";"
COMA        ","
IGUAL       "="

%%

"reabastecer"       { return REABASTECER; }
"viajar"            { return VIAJAR; }
"autonomo"          { return AUTONOMO; }
"guiado"            { return GUIADO; }
"galaxia"           { return GALAXIA; }
"nave"              { return NAVE; }
"arista"            { return ARISTA; }
"combustible"       { return COMBUSTIBLE; }
"peso"              { return PESO; }

{ID}                { yylval.str = strdup(yytext); return IDENTIFICADOR; }
{DIGITO}+           { yylval.numero = atoi(yytext); return NUMERO; }

{PUNTOYCOMA}        { return PUNTOYCOMA; }
{COMA}              { return COMA; }
{IGUAL}             { return IGUAL; }

{ESPACIO}+          {/* Ignorar espacios en blanco */}
{NUEVALINEA}        {/* Ignorar saltos de línea */}

.                   { printf("Caracter no reconocido: %s\n", yytext); }

%%

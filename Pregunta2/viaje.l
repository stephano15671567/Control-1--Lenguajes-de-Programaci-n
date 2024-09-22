%{
#include "y.tab.h"
#include <stdio.h>
%}

%%

galaxia             { return GALAXIA; }
nave                { return NAVE; }
viajar              { return VIAJAR; }
autonomo            { return AUTONOMO; }
guiado              { return GUIADO; }
combustible         { return COMBUSTIBLE; }
[0-9]+              { yylval.numero = atoi(yytext); return NUMERO; }
[a-zA-Z_][a-zA-Z0-9_]* { yylval.str = strdup(yytext); return IDENTIFICADOR; }
"="                 { return IGUAL; }
";"                 { return PUNTOYCOMA; }
[ \t\n]+            ; // Ignorar espacios en blanco

%%

int yywrap() {
    return 1;
}

%option noyywrap
%{
#include "garhwali.tab.h"
#include <stdlib.h>
#include <string.h>
%}

%%

"kya_haal"         { return START; }
"feri_malya"       { return END; }
"bol"              { return BOL; }
"agar"             { return IF; }
"toh"              { return THEN; }
"nahi_toh"         { return ELSE; }
"bol_de"           { return PRINT; }

[0-9]+             { yylval.num = atoi(yytext); return NUMBER; }
\"[^\"]*\"         { yylval.str = strdup(yytext); return STRING; }
[a-zA-Z_][a-zA-Z0-9_]* { yylval.id = strdup(yytext); return ID; }

"="                { return ASSIGN; }
"<"                { return LT; }
";"                { return SEMICOLON; }

[ \t\r\n]+         ; // skip whitespace
.                  { return yytext[0]; }

%%

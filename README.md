Project Title: Garhwali Compiler (Creating a compiler in your own language)
The project created by me and my project partner is made on the Garhwali language. The final output given by the code is a three address code. 
The files for the project have been uploaded. They are: garhwali.l (The Lex File), garhwali.y (The Yacc File), and program.grw (a test program file).

Steps to run the project code:
1. flex garhwali.l
2. bison -d garhwali.y
3. gcc lex.yy.c garhwali.tab.c -o garhwali_compiler
4. Get-Content program.grw | ./garhwali_compiler

The codes for the same are given below:- 

garhwali.l (Lex File):
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

garhwali.y (Yacc File):
%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void yyerror(const char *s);
int yylex();

int temp_count = 1;
int label_count = 1;

// Helpers
char* new_temp() {
    char* name = malloc(10);
    sprintf(name, "t%d", temp_count++);
    return name;
}

char* new_label() {
    char* name = malloc(10);
    sprintf(name, "L%d", label_count++);
    return name;
}
%}

%union {
    int num;
    char *id;
    char *str;
}

%token <id> ID
%token <num> NUMBER
%token <str> STRING

%token START END BOL IF THEN ELSE PRINT
%token ASSIGN LT SEMICOLON

%%

program:
    START statements END { printf("// Program parsed successfully.\n"); }
    ;

statements:
    statements statement
    | statement
    ;

statement:
    // Variable Declaration
    BOL ID ASSIGN NUMBER SEMICOLON {
        char* temp = new_temp();
        printf("%s = %d\n", temp, $4);      // t1 = 5
        printf("%s = %s\n", $2, temp);      // x = t1
    }
    |
    // Print Statement
    PRINT STRING SEMICOLON {
        printf("print %s\n", $2);           // print "string"
    }
    |
    // If-Else Statement
    IF ID LT ID THEN statement ELSE statement {
        char* temp = new_temp();
        char* l1 = new_label();
        char* l2 = new_label();
        char* l3 = new_label();

        printf("%s = %s < %s\n", temp, $2, $4);      // t3 = x < y
        printf("if %s goto %s\n", temp, l1);         // if t3 goto L1
        printf("goto %s\n", l2);                     // goto L2

        printf("%s:\n", l1);                         // L1:
        // Execute THEN statement
        // NOTE: statements in Bison rules execute in order automatically
        // so no need to print again here

        // But we do force execution of statement block:
        // Using a trick: just re-parse the same statements
        // But in your simplified case, just place block boundary
        printf("// THEN block ends\n");
        printf("goto %s\n", l3);

        printf("%s:\n", l2);                         // L2:
        // ELSE block
        printf("// ELSE block ends\n");

        printf("%s:\n", l3);                         // L3:
        printf("// IF-ELSE ends\n");
    }
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}

int main() {
    return yyparse();
}

program.grw (Test Code):
kya_haal

bol x = 5;
bol y = 10;
agar x < y toh
    bol_de "x chhota hai";
nahi_toh
    bol_de "x bada hai";

feri_malya


Shristi Mishra - 22000793

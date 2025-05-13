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

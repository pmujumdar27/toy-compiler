%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "hhps.h" // contains definition of 'symrec'

void yyerror (char *s);
int yylex();

StmtsNode *root;
%}

%union {
int   val;  /* For returning numbers.                   */
struct symrec  *tptr;   /* For returning symbol-table pointers      */
char c[10000];
char nData[100];
StmtNode *stmtptr;
StmtsNode *stmtsptr;
}

%token <val> NUM
%token <tptr> MAIN VAR
%token IF ELSE FOR WHILE ARRAY INT LPAREN RPAREN LCBRACE RCBRACE SEMICOLON GE LE NE EQ AND OR RETURN PRINT BREAK COMMA
%type <c> exp relop_exp
%type <nData> x
%type <stmtsptr> stmts
%type <stmtptr> stmt ifelse_stmt for_loop while_loop var_dec var_assgn exp_stmt print_stmt ret

%right '='
%left '-' '+'
%left '*' '/'

%%

prog:
    main
;

main:
   INT MAIN '(' ')' '{' stmts '}' {
        root = $6;
    }
    ;

stmts:
    stmt {
        $$ = (StmtsNode*)malloc(sizeof(StmtsNode));
        $$->singl = 1;
        $$->left = $1;
        $$->right = NULL;
    }
    |
    stmt stmts {
        $$ = (StmtsNode*)malloc(sizeof(StmtsNode));
        $$->singl = 0;
        $$->left = $1;
        $$->right = $2;
    }
    ;

stmt:
    ifelse_stmt {
        $$ = $1;
    }
    |
    for_loop {
        $$ = $1;
    }
    |
    while_loop {
        $$ = $1;
    }
    |
    var_dec ';' {
        $$ = $1;
    }
    |
    var_assgn ';' {
        $$ = $1;
    }
    |
    exp_stmt {
        $$ = $1;
    }
    |
    print_stmt {
        $$ = $1;
    }
    |
    ret {
        $$ = $1;
    }
    ;

while_loop:
    WHILE LPAREN relop_exp RPAREN RCBRACE stmts LCBRACE {
        $$ = (StmtNode*)malloc(sizeof(StmtNode));
        $$->nodeType = WHILE_LOOP;
        sprintf($$->initCode,"%s", $3);
        // Make sure to implement relop_exp such that it manipulates values of operands
        // and stores them in $t0 and $t1 such that bge $t0, $t1, gives true when relop is true
        // we plan to print the loop ending label in front of initJumpCode
        sprintf($$->initJumpCode,"bge $t0, $t1,");
        $$->down = $6;
    }
    |
    WHILE LPAREN relop_exp RPAREN stmt {
        $$ = (StmtNode*)malloc(sizeof(StmtNode));
        $$->nodeType = WHILE_LOOP;
        sprintf($$->initCode, "%s", $3);
        // Make sure to implement relop_exp such that it manipulates values of operands
        // and stores them in $t0 and $t1 such that bge $t0, $t1, gives true when relop is true
        // we plan to print the loop ending label in front of initJumpCode
        sprintf($$->initJumpCode,"bge $t0, $t1,");
        $$->down = (StmtsNode*)malloc(sizeof(StmtsNode));
        $$->down->singl = 1;
        $$->down->left = $5;
        $$->down->right = NULL;
    }
%%
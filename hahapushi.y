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

%token <val> NUM INT
%token <tptr> MAIN VAR
%token IF ELSE FOR WHILE
%type <c> exp
%type <nData> x
%type <stmtsptr> stmts
%type <stmtptr> stmt

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
    ifelse_cond {
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

ifelse_cond:
    IF '(' relop_exp ')' '{' stmts '}' ELSE '{' stmts '}' {
        $$ = (StmtsNode*)malloc(sizeof(StmtsNode));
        $$->nodeType = IF_ELSE_STMT;
    }
    |
    IF '(' relop_exp ')' '{' stmts '}' {
        ;
    }
;

var_dec:
    ARRAY LPAREN TYPE ',' ID RPAREN VAR SEMICOLON {
        $$ = (StmtsNode*)malloc(sizeof(StmtsNode));
        $$->nodeType = VAR_DEC;
        sprintf($$->bodyCode, "%s\nmul $t0 $t0 4\nsubu $sp $sp $t0\nsw $sp %s($t8)", $5, $7->addr);
    }
    | 
    TYPE VAR SEMICOLON {
        $$ = (StmtsNode*)malloc(sizeof(StmtsNode));
        $$->nodeType = VAR_DEC;
        sprintf($$->bodyCode, "");
    }
    |
    TYPE VAR '=' exp_stmt {
        $$ = (StmtsNode*)malloc(sizeof(StmtsNode));
        $$->nodeType = VAR_DEC;
        sprintf($$->bodyCode, "%s\nsw $t0 %s($t8)", $4->bodyCode, $2->addr);
    }
;

var_assgn:
    var "=" exp_stmt {

    }

;

%%
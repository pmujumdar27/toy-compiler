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


exp:    exp "+" exp  {sprintf($$,"%s\nsub $sp, $sp, 4\nsw $t0, 0($sp)\n%s\nlw $t1 4($sp)\nadd $t0, $t0, $t1\naddi $sp, $sp, 4", $1, $3);}
    |   exp "-" exp  {sprintf($$,"%s\nsub $sp, $sp, 4\nsw $t0, 0($sp)\n%s\nlw $t1 4($sp)\nsub $t0, $t0, $t1\naddi $sp, $sp, 4", $1, $3);}
    |   exp "*" exp  {sprintf($$,"%s\nsub $sp, $sp, 4\nsw $t0, 0($sp)\n%s\nlw $t1 4($sp)\nmul $t0, $t0, $t1\naddi $sp, $sp, 4", $1, $3);}
    |   exp "/" exp  {sprintf($$,"%s\nsub $sp, $sp, 4\nsw $t0, 0($sp)\n%s\nlw $t1 4($sp)\ndiv $t0, $t0, $t1\naddi $sp, $sp, 4", $1, $3);}
    |   exp "%" exp  {sprintf($$,"%s\nsub $sp, $sp, 4\nsw $t0, 0($sp)\n%s\nlw $t1 4($sp)\ndiv $t0, $t1\nmfhi $t0\naddi $sp, $sp, 4", $1, $3);}
    |   exp "&" exp  {sprintf($$,"%s\nsub $sp, $sp, 4\nsw $t0, 0($sp)\n%s\nlw $t1 4($sp)\nand $t0, $t0, $t1\naddi $sp, $sp, 4", $1, $3);}
    |   exp "|" exp  {sprintf($$,"%s\nsub $sp, $sp, 4\nsw $t0, 0($sp)\n%s\nlw $t1 4($sp)\nor $t0, $t0, $t1\naddi $sp, $sp, 4", $1, $3);}
    |   "(" exp ")"  {sprintf($$,"%s\n", $2);}
    |   "-" exp      {sprintf($$,"%s\nmuli $t0, $t0, -1", $2);}
    |   id           {sprintf($$,"%s\n", $1);}

id:     var {sprintf($$, "lw $t0, %s($t8)",$1->addr);}
    |   NUM {sprintf($$, "li $t0, %d",$1);}

%%
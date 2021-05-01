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
char relop_cond[20];
char nData[100];
StmtNode *stmtptr;
StmtsNode *stmtsptr;
}

%token <val> NUM
%token <tptr> MAIN VAR
%token <relop_cond> LT GT LE GE NE EQ AND OR
%token IF ELSE FOR WHILE ARRAY INT LPAREN RPAREN LCBRACE RCBRACE SEMICOLON RETURN PRINT BREAK COMMA
%type <c> exp relop_exp
%type <nData> x
%type <stmtsptr> stmts
%type <stmtptr> stmt ifelse_stmt for_loop while_loop var_dec var_assgn exp_stmt print_stmt ret
%type <relop_cond> relops

%right '='
%left '&' 
%left '|'
%left '-' '+'
%left '*' '/' '%'
%right UMINUS
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
    WHILE LPAREN relop_exp RPAREN LCBRACE stmts RCBRACE {
        $$ = (StmtNode*)malloc(sizeof(StmtNode));
        $$->nodeType = WHILE_LOOP;
        sprintf($$->initCode,"%s", $3);
        // We set the value of $t0 while evaluating relop_exp
        sprintf($$->initJumpCode,"beq $t0, $0,");
        $$->down = $6;
    }
    |
    WHILE LPAREN relop_exp RPAREN stmt {
        $$ = (StmtNode*)malloc(sizeof(StmtNode));
        $$->nodeType = WHILE_LOOP;
        sprintf($$->initCode, "%s", $3);
        // We set the value of $t0 while evaluating relop_exp
        sprintf($$->initJumpCode,"beq $t0, $0,");
        $$->down = (StmtsNode*)malloc(sizeof(StmtsNode));
        $$->down->singl = 1;
        $$->down->left = $5;
        $$->down->right = NULL;
    }
    ;

relop_exp:
    // registers used: $t0, $t1, $t2
    // value set in register: $t0
    exp relops exp {
        sprintf($$,"%s \nsw $t0, -4($sp)\nsub $sp, $sp, 4\n %s\nsw $t0, -4($sp)\nsub $sp, $sp, 4\nlw $t2, 0($sp)\naddi $sp, $sp, 4\nlw $t1, 0($sp)\naddi $sp, $sp, 4\n%s $t0, $t1,$t2", $1 ,$3 ,$2);
    }
    |
    LPAREN relop_exp RPAREN {
        sprintf($$, "\n%s", $2);
    }
    |
    exp {
        sprintf($$, "%s\nmove $t1, $t0\nsne $t0, $t1, $0", $1);
    }
    ;

relops:
    LT {
        $$ = $1;
    }
    |
    GT {
        $$ = $1;
    }
    |
    LE {
        $$ = $1;
    }
    |
    GE {
        $$ = $1;
    }
    |
    NE {
        $$ = $1;
    }
    |
    EQ {
        $$ = $1;
    }
    |
    AND {
        $$ = $1;
    }
    |
    OR {
        $$ = $1;
    }
    ;

exp:
    exp "+" exp  {sprintf($$,"%s\nsub $sp, $sp, 4\nsw $t0, 0($sp)\n%s\nlw $t1 4($sp)\nadd $t0, $t0, $t1\naddi $sp, $sp, 4", $1, $3);}
    |   exp "-" exp  {sprintf($$,"%s\nsub $sp, $sp, 4\nsw $t0, 0($sp)\n%s\nlw $t1 4($sp)\nsub $t0, $t0, $t1\naddi $sp, $sp, 4", $1, $3);}
    |   exp "*" exp  {sprintf($$,"%s\nsub $sp, $sp, 4\nsw $t0, 0($sp)\n%s\nlw $t1 4($sp)\nmul $t0, $t0, $t1\naddi $sp, $sp, 4", $1, $3);}
    |   exp "/" exp  {sprintf($$,"%s\nsub $sp, $sp, 4\nsw $t0, 0($sp)\n%s\nlw $t1 4($sp)\ndiv $t0, $t0, $t1\naddi $sp, $sp, 4", $1, $3);}
    |   exp "%" exp  {sprintf($$,"%s\nsub $sp, $sp, 4\nsw $t0, 0($sp)\n%s\nlw $t1 4($sp)\ndiv $t0, $t1\nmfhi $t0\naddi $sp, $sp, 4", $1, $3);}
    |   exp "&" exp  {sprintf($$,"%s\nsub $sp, $sp, 4\nsw $t0, 0($sp)\n%s\nlw $t1 4($sp)\nand $t0, $t0, $t1\naddi $sp, $sp, 4", $1, $3);}
    |   exp "|" exp  {sprintf($$,"%s\nsub $sp, $sp, 4\nsw $t0, 0($sp)\n%s\nlw $t1 4($sp)\nor $t0, $t0, $t1\naddi $sp, $sp, 4", $1, $3);}
    |   "(" exp ")"  {sprintf($$,"%s\n", $2);}
    |   "-" exp %prec UMINUS     {sprintf($$,"%s\nmuli $t0, $t0, -1", $2);}
    |   id           {sprintf($$,"%s\n", $1);}
    ;

id:
    var {sprintf($$, "lw $t0, %s($t8)",$1->addr);}
    |   NUM {sprintf($$, "li $t0, %d",$1);}
    ;
%%
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
    exp LT exp {
        sprintf($$,"%s \nsw $t0, -4($sp)\nsub $sp, $sp, 4\n %s\nsw $t0, -4($sp)\nsub $sp, $sp, 4\nlw $t2, 0($sp)\naddi $sp, $sp, 4\nlw $t1, 0($sp)\naddi $sp, $sp, 4\n%s $t0, $t1,$t2", $1 ,$3 ,$2);
    }
    |
    exp GT exp {
        sprintf($$,"%s \nsw $t0, -4($sp)\nsub $sp, $sp, 4\n %s\nsw $t0, -4($sp)\nsub $sp, $sp, 4\nlw $t2, 0($sp)\naddi $sp, $sp, 4\nlw $t1, 0($sp)\naddi $sp, $sp, 4\n%s $t0, $t1,$t2", $1 ,$3 ,$2);
    }
    |
    exp LE exp {
        sprintf($$,"%s \nsw $t0, -4($sp)\nsub $sp, $sp, 4\n %s\nsw $t0, -4($sp)\nsub $sp, $sp, 4\nlw $t2, 0($sp)\naddi $sp, $sp, 4\nlw $t1, 0($sp)\naddi $sp, $sp, 4\n%s $t0, $t1,$t2", $1 ,$3 ,$2);
    }
    |
    exp GE exp {
        sprintf($$,"%s \nsw $t0, -4($sp)\nsub $sp, $sp, 4\n %s\nsw $t0, -4($sp)\nsub $sp, $sp, 4\nlw $t2, 0($sp)\naddi $sp, $sp, 4\nlw $t1, 0($sp)\naddi $sp, $sp, 4\n%s $t0, $t1,$t2", $1 ,$3 ,$2);
    }
    |
    exp NE exp {
        sprintf($$,"%s \nsw $t0, -4($sp)\nsub $sp, $sp, 4\n %s\nsw $t0, -4($sp)\nsub $sp, $sp, 4\nlw $t2, 0($sp)\naddi $sp, $sp, 4\nlw $t1, 0($sp)\naddi $sp, $sp, 4\n%s $t0, $t1,$t2", $1 ,$3 ,$2);
    }
    |
    exp EQ exp {
        sprintf($$,"%s \nsw $t0, -4($sp)\nsub $sp, $sp, 4\n %s\nsw $t0, -4($sp)\nsub $sp, $sp, 4\nlw $t2, 0($sp)\naddi $sp, $sp, 4\nlw $t1, 0($sp)\naddi $sp, $sp, 4\n%s $t0, $t1,$t2", $1 ,$3 ,$2);
    }
    |
    exp AND exp {
        sprintf($$,"%s \nsw $t0, -4($sp)\nsub $sp, $sp, 4\n %s\nsw $t0, -4($sp)\nsub $sp, $sp, 4\nlw $t2, 0($sp)\naddi $sp, $sp, 4\nlw $t1, 0($sp)\naddi $sp, $sp, 4\n%s $t0, $t1,$t2", $1 ,$3 ,$2);
    }
    |
    exp OR exp {
        sprintf($$,"%s \nsw $t0, -4($sp)\nsub $sp, $sp, 4\n %s\nsw $t0, -4($sp)\nsub $sp, $sp, 4\nlw $t2, 0($sp)\naddi $sp, $sp, 4\nlw $t1, 0($sp)\naddi $sp, $sp, 4\n%s $t0, $t1,$t2", $1 ,$3 ,$2);
    }
    |
    relop_exp NE relop_exp {
        sprintf($$,"%s \nsw $t0, -4($sp)\nsub $sp, $sp, 4\n %s\nsw $t0, -4($sp)\nsub $sp, $sp, 4\nlw $t2, 0($sp)\naddi $sp, $sp, 4\nlw $t1, 0($sp)\naddi $sp, $sp, 4\n%s $t0, $t1,$t2", $1 ,$3 ,$2);
    }
    |
    relop_exp EQ relop_exp {
        sprintf($$,"%s \nsw $t0, -4($sp)\nsub $sp, $sp, 4\n %s\nsw $t0, -4($sp)\nsub $sp, $sp, 4\nlw $t2, 0($sp)\naddi $sp, $sp, 4\nlw $t1, 0($sp)\naddi $sp, $sp, 4\n%s $t0, $t1,$t2", $1 ,$3 ,$2);
    }
    |
    relop_exp AND relop_exp {
        sprintf($$,"%s \nsw $t0, -4($sp)\nsub $sp, $sp, 4\n %s\nsw $t0, -4($sp)\nsub $sp, $sp, 4\nlw $t2, 0($sp)\naddi $sp, $sp, 4\nlw $t1, 0($sp)\naddi $sp, $sp, 4\n%s $t0, $t1,$t2", $1 ,$3 ,$2);
    }
    |
    relop_exp OR relop_exp {
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
%%
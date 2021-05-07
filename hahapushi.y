%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "hhps.h" // contains definition of 'symrec'

void yyerror (char *s);
int yylex();

StmtsNode *root;

void yyerror(char *s){
    printf("%s\n", s);
}
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
%token IF ELSE FOR WHILE ARRAY INT LPAREN RPAREN LCBRACE RCBRACE SEMICOLON RETURN PRINT COMMA RANGE //Break implement karna baki hai
%type <c> exp relop_exp
%type <nData> id
%type <stmtsptr> stmts else_stmt
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
   INT MAIN LPAREN RPAREN LCBRACE stmts RCBRACE {
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
    var_dec SEMICOLON {
        $$ = $1;
    }
    |
    var_assgn SEMICOLON {
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

ifelse_stmt:
    IF LPAREN relop_exp RPAREN LCBRACE stmts RCBRACE else_stmt {
        $$ = (StmtNode*)malloc(sizeof(StmtNode));
        $$->nodeType = IF_ELSE_STMT;
        sprintf($$->bodyCode,"%s", $3);
        sprintf($$->initJumpCode,"beq $t0, $0,");
        $$->down = $6;
        $$->elseCode = $8;
    }
    |
    IF LPAREN relop_exp RPAREN stmt else_stmt {
        $$ = (StmtNode*)malloc(sizeof(StmtNode));
        $$->nodeType = IF_ELSE_STMT;
        sprintf($$->bodyCode,"%s", $3);
        sprintf($$->initJumpCode,"beq $t0, $0,");
        $$->down = (StmtsNode*)malloc(sizeof(StmtsNode));
        $$->down->singl = 1;
        $$->down->left = $5;
        $$->down->right = NULL;
        $$->elseCode = $6;
    }
    |
    IF LPAREN relop_exp RPAREN LCBRACE stmts RCBRACE {
        $$ = (StmtNode*)malloc(sizeof(StmtNode));
        $$->nodeType = IF_ELSE_STMT;
        sprintf($$->bodyCode,"%s", $3);
        sprintf($$->initJumpCode,"beq $t0, $0,");
        $$->down = $6;
    }
    |
    IF LPAREN relop_exp RPAREN stmt {
        $$ = (StmtNode*)malloc(sizeof(StmtNode));
        $$->nodeType = IF_ELSE_STMT;
        sprintf($$->bodyCode,"%s", $3);
        sprintf($$->initJumpCode,"beq $t0, $0,");
        $$->down = (StmtsNode*)malloc(sizeof(StmtsNode));
        $$->down->singl = 1;
        $$->down->left = $5;
        $$->down->right = NULL;
    }
    ;

else_stmt:
    ELSE LCBRACE stmts RCBRACE {
        $$ = $3;
    }
    |
    ELSE stmt {
        $$ = (StmtsNode*)malloc(sizeof(StmtsNode));
        $$->singl = 1;
        $$->left = $2;
        $$->right = NULL;
    }
    ;

for_loop:
    FOR VAR RANGE LPAREN id COMMA id RPAREN LCBRACE stmts RCBRACE {
        $$ = (StmtNode*)malloc(sizeof(StmtNode));
        $$->nodeType = FOR_LOOP;
        
        // assigning VAR the value of $5
        sprintf($$->forIter,"%s\nsw $t0,%s($t8)\n", $5, $2->addr);

        char load_op_1[80]; //loads value of VAR and stores it in $t1
        char load_op_2[80]; //loads value of $7  and stores it in $t2

        load_op_1[0] = '\0';
        load_op_2[0] = '\0';

        // sprintf(load_op_1, "%s\n%s\n", $2, "move $t1, $t0");
        sprintf(load_op_1, "lw $t1, %s($t8)\n", $2->addr);
        sprintf(load_op_2, "%s\nmove $t2 $t0\n", $7);

        char operation_code[80]; //code for relop of the loop
        char update_code[80]; //code to update VAR
        operation_code[0] = '\0';
        update_code[0] = '\0';

        if($5 <= $7){
            sprintf(operation_code, "%s", "slt $t0, $t1, $t2");
            sprintf(update_code,"lw $t0, %s($t8)\naddi $t0, $t0, 1\nsw $t0,%s($t8)\n", $2->addr, $2->addr);
        }
        else{
            sprintf(operation_code, "%s", "sgt $t0, $t1, $t2");
            sprintf(update_code,"lw $t0, %s($t8)\nsubi $t0, $t0, 1\nsw $t0,%s($t8)\n", $2->addr, $2->addr);
        }
        sprintf($$->initCode, "\n%s\n%s\n%s\n", load_op_1, load_op_2, operation_code);
        sprintf($$->initJumpCode,"beq $t0, $0,");
        // $$->forUpdate = update_code;
        sprintf($$->forUpdate, "%s", update_code);
        $$->down = $10;
    }
    |
    FOR VAR RANGE LPAREN id COMMA id RPAREN LCBRACE stmt RCBRACE {
        $$ = (StmtNode*)malloc(sizeof(StmtNode));
        $$->nodeType =FOR_LOOP;
        
        // assigning VAR the value of $5
        sprintf($$->forIter,"%s\nsw $t0,%s($t8)\n", $5, $2->addr);

        char load_op_1[80]; //loads value of VAR and stores it in $t1
        char load_op_2[80]; //loads value of $7  and stores it in $t2
        load_op_1[0] = '\0';
        load_op_2[0] = '\0';

        // sprintf(load_op_1, "%s\n%s", $2, "move $t1, $t0");
        sprintf(load_op_1, "lw $t1, %s($t8)\n", $2->addr);
        sprintf(load_op_2, "%s\nmove $t2 $t0", $7);

        char operation_code[80]; //code for relop of the loop
        char update_code[80]; //code to update VAR
        operation_code[0] = '\0';
        update_code[0] = '\0';

        if($5 <= $7){
            sprintf(operation_code, "%s", "slt $t0, $t1, $t2");
            sprintf(update_code,"lw $t0, %s($t8)\naddi $t0, $t0, 1\nsw $t0,%s($t8)\n", $2->addr, $2->addr);
        }
        else{
            sprintf(operation_code, "%s", "sgt $t0, $t1, $t2");
            sprintf(update_code,"lw $t0, %s($t8)\nsubi $t0, $t0, 1\nsw $t0,%s($t8)\n", $2->addr, $2->addr);
        }
        sprintf($$->initCode, "\n%s\n%s\n%s\n", load_op_1, load_op_2, operation_code);
        sprintf($$->initJumpCode,"beq $t0, $0,");
        // $$->forUpdate = update_code;
        sprintf($$->forUpdate, "%s", update_code);
        $$->down = (StmtsNode*)malloc(sizeof(StmtsNode));
        $$->down->singl = 1;
        $$->down->left = $10;
        $$->down->right = NULL;
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

// var_dec:
//     INT VAR '=' exp {
//         $$ = (StmtNode*)malloc(sizeof(StmtNode));
//         $$->nodeType = VAR_DEC;
//         sprintf($$->bodyCode, "%s\nsw $t0,%s($t8)\n", $4, $2->addr);
//         $$->down = NULL;
//     }
//     |
//     INT VAR {
//         $$ = (StmtNode*)malloc(sizeof(StmtNode));
//         $$->nodeType = VAR_DEC;
//         sprintf($$->bodyCode, "li $t0, 0\nsw $t0,%s($t8)\n", $2->addr);
//         $$->down = NULL;
//     }
//     ;

// var_assgn:
//     VAR '=' exp {
//         $$ = (StmtNode*)malloc(sizeof(StmtNode));
//         $$->nodeType = VAR_ASSGN;
//         sprintf($$->bodyCode, "%s\nsw $t0,%s($t8)\n", $3, $1->addr);
//     }
//     ;

exp_stmt:
    exp SEMICOLON {
        $$ = (StmtNode*)malloc(sizeof(StmtNode));
        $$->nodeType = EXP_STMT;
        sprintf($$->bodyCode, "%s\n", $1);
        $$->down = NULL;
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

var_dec:
    ARRAY LPAREN INT COMMA id RPAREN VAR {
        $$ = (StmtNode*)malloc(sizeof(StmtNode));
        $$->nodeType = VAR_DEC;
        sprintf($$->bodyCode, "%s\nmul $t0 $t0 4\nsubu $sp $sp $t0\nsw $sp %s($t8)", 
        $5, $7->addr);
    }
    | 
    INT VAR '=' exp {
        $$ = (StmtNode*)malloc(sizeof(StmtNode));
        $$->nodeType = VAR_DEC;
        sprintf($$->bodyCode, "%s\nsw $t0,%s($t8)\n", $4, $2->addr);
        $$->down = NULL;
    }
    |
    INT VAR {
        $$ = (StmtNode*)malloc(sizeof(StmtNode));
        $$->nodeType = VAR_DEC;
        sprintf($$->bodyCode, "li $t0, 0\nsw $t0,%s($t8)\n", $2->addr);
        $$->down = NULL;
    }
    ;

var_assgn:
    VAR '=' exp {
        $$ = (StmtNode*)malloc(sizeof(StmtNode));
        $$->nodeType = VAR_ASSGN;
        sprintf($$->bodyCode, "%s\nsw $t0,%s($t8)\n", $3, $1->addr);
    }
    |
    VAR '[' id ']' '=' exp {
        $$ = (StmtNode*)malloc(sizeof(StmtNode));
        $$->nodeType = VAR_ASSGN;
        sprintf($$->bodyCode, "%s\nsubu $sp $sp 4\nsw $t0 ($sp)\n%s\nlw $t1 ($sp)\nmul $t0 $t0 4\nlw $t2 %s($t8)\nadd $t0 $t0 $t2\nsw $t1 ($t0)\naddu $sp $sp 4",
        $6, $3, $1->addr);
    }
    ;

print_stmt:
    PRINT LPAREN id RPAREN SEMICOLON {
        $$ = (StmtNode*)malloc(sizeof(StmtNode));
        $$->nodeType = PRINT_STMT;
        sprintf($$->bodyCode, "%s\nmove $a0 $t0\nli $v0 1\nsyscall",
        $3);
    }
    ;

ret:
    RETURN NUM SEMICOLON {
        $$ = (StmtNode*)malloc(sizeof(StmtNode));
        $$->nodeType = PRINT_STMT;
        sprintf($$->bodyCode, "li $v0 10\nsyscall");
    }
    ;

id:
    VAR {sprintf($$, "lw $t0, %s($t8)",$1->addr);}
    |   
    NUM {sprintf($$, "li $t0, %d",$1);}
    |
    VAR '[' id ']'{
        sprintf($$, "%s\nlw $t1 %s($t8)\nmul $t0 $t0 4\nadd $t1 $t1 $t0\nlw $t0 ($t1)",
        $3, $1->addr);
    }
    ;


relops:
    LT {
        // $$ = $1;
        sprintf($$, "%s", $1);
    }
    |
    GT {
        // $$ = $1;
        sprintf($$, "%s", $1);
    }
    |
    LE {
        // $$ = $1;
        sprintf($$, "%s", $1);
    }
    |
    GE {
        // $$ = $1;
        sprintf($$, "%s", $1);
    }
    |
    NE {
        // $$ = $1;
        sprintf($$, "%s", $1);
    }
    |
    EQ {
        // $$ = $1;
        sprintf($$, "%s", $1);
    }
    |
    AND {
        // $$ = $1;
        sprintf($$, "%s", $1);
    }
    |
    OR {
        // $$ = $1;
        sprintf($$, "%s", $1);
    }
    ;

exp:
    exp '+' exp  {sprintf($$,"%s\nsub $sp, $sp, 4\nsw $t0, 0($sp)\n%s\nlw $t1 0($sp)\nadd $t0, $t0, $t1\naddi $sp, $sp, 4", $1, $3);}
    |   exp '-' exp  {sprintf($$,"%s\nsub $sp, $sp, 4\nsw $t0, 0($sp)\n%s\nlw $t1 0($sp)\nsub $t0, $t1, $t0\naddi $sp, $sp, 4", $1, $3);}
    |   exp '*' exp  {sprintf($$,"%s\nsub $sp, $sp, 4\nsw $t0, 0($sp)\n%s\nlw $t1 0($sp)\nmul $t0, $t0, $t1\naddi $sp, $sp, 4", $1, $3);}
    |   exp '/' exp  {sprintf($$,"%s\nsub $sp, $sp, 4\nsw $t0, 0($sp)\n%s\nlw $t1 0($sp)\ndiv $t0, $t1, $t0\naddi $sp, $sp, 4", $1, $3);}
    |   exp '%' exp  {sprintf($$,"%s\nsub $sp, $sp, 4\nsw $t0, 0($sp)\n%s\nlw $t1 0($sp)\ndiv $t1, $t0\nmfhi $t0\naddi $sp, $sp, 4", $1, $3);}
    |   exp '&' exp  {sprintf($$,"%s\nsub $sp, $sp, 4\nsw $t0, 0($sp)\n%s\nlw $t1 0($sp)\nand $t0, $t0, $t1\naddi $sp, $sp, 4", $1, $3);}
    |   exp '|' exp  {sprintf($$,"%s\nsub $sp, $sp, 4\nsw $t0, 0($sp)\n%s\nlw $t1 0($sp)\nor $t0, $t0, $t1\naddi $sp, $sp, 4", $1, $3);}
    |   LPAREN exp RPAREN  {sprintf($$,"%s\n", $2);}
    |   '-' exp %prec UMINUS     {sprintf($$,"%s\nmul $t0, $t0, -1", $2);}
    |   id           {sprintf($$,"%s\n", $1);}
    ;

// id:
//     VAR {sprintf($$, "lw $t0, %s($t8)",$1->addr);}
//     |   NUM {sprintf($$, "li $t0, %d",$1);}
//     ;
%%
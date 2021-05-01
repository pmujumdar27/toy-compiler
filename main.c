#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <ctype.h>

#include "hhps.h"
// #include "hahapushi.tab.h"

void StmtTrav(StmtNode *root);

void StmtsTrav(StmtsNode *root){
    if(root!=NULL){
        StmtTrav(root->left);
        if(root->singl==1){
            return;
        }
        else{
            StmtsTrav(root->right);
        }
    }
}

void StmtTrav(StmtNode *root){
    if(root!=NULL){
        switch (root->nodeType)
        {
        case IF_ELSE_STMT:
            /* code */
            break;
        case ELSE_STMT:
            /* code */
            break;
        case FOR_LOOP:
            /* code */
            break;
        case WHILE_LOOP:
            /* code */
            break;
        case VAR_DEC:
            /* code */
            break;
        case VAR_ASSGN:
            /* code */
            break;
        case EXP_STMT:
            /* code */
            break;
        case PRINT_STMT:
            /* code */
            break;
        case RETURN_STMT:
            /* code */
            break;
        
        default:
            break;
        }
    }
}
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
        
        default:
            break;
        }
    }
}
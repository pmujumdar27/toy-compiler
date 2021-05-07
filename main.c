#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <ctype.h>

#include "hhps.h"
#include "hahapushi.tab.h"

FILE *fp;
StmtsNode *root;
int lcnt = 0;

char *get_new_label(char *label_type, int label_count) {
    size_t buffsz = strlen(label_type) + 8;
    char *buf = malloc(buffsz);
    snprintf(buf, buffsz, ".%s_%d", label_type, label_count);
    return buf;
}

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
            char *if_end = get_new_label("if_end", lcnt);

            // relop condition code
            fprintf(fp, "%s\n", root->bodyCode);

            StmtsTrav(root->down);

            if(root->elseCode == NULL){
                // jump to end if relop gives false
                fprintf(fp, "%s %s\n", root->initJumpCode, if_end);
                StmtsTrav(root->down);
                fprintf(fp, "j %s\n%s:\n", if_end, if_end);
            }
            else{
                char *else_label = get_new_label("else", lcnt);
                // jump to else if relop gives false
                fprintf(fp, "%s %s\n", root->initJumpCode, else_label);
                StmtsTrav(root->down);

                // print code to jump to end of if statement
                fprintf(fp, "j %s\n%s:\n", if_end);

                // mark the start of else part
                fprintf(fp, "%s:\n", else_label); 
                
                // print code to execute else body statements
                StmtsTrav(root->elseCode);

                // mark the end of if conditional code
                fprintf(fp, "%s:\n", if_end);
            }

            lcnt++;

            break;

        // case ELSE_STMT:
        //     /* code */
        //     break;

        case FOR_LOOP:
            
            char *for_start = get_new_label("for_start", lcnt);
            char *for_end = get_new_label("for_end, lcnt", lcnt);
            lcnt++;

            // initializations and conditions
            fprintf(fp, "%s\n", root->forIter);
            fprintf(fp, "%s\n", for_start);
            fprintf(fp, "%s\n", root->initCode);
            fprintf(fp, "%s %s\n", root->initJumpCode, for_end);

            // print code for statements inside for loop and the code to update iteration variable
            StmtsTrav(root->down);
            fprintf(fp, "%s\n", root->forUpdate);
            
            // unconditional jump because condition is checked in the beginning of the next iter
            fprintf(fp,"j %s\n%s:", for_start, for_end);

            break;
        case WHILE_LOOP:
            
            char *while_start = get_new_label("while_start", lcnt);
            char *while_end = get_new_label("while_end", lcnt);
            lcnt++;

            // initializations and conditions
            fprintf(fp, "%s:\n", while_start);
            fprintf(fp, "%s\n", root->initCode);
            fprintf(fp, "%s %s\n", root->initJumpCode, while_end);

            // print code for the statements inside the while loop
            StmtsTrav(root->down);

            // unconditional jump for the while loop
            fprintf(fp,"j %s\n%s:", while_start, while_end);

            break;
        // case VAR_DEC:
        //     /* code */
        //     break;
        // case VAR_ASSGN:
        //     /* code */
        //     break;
        // case EXP_STMT:
        //     /* code */
        //     break;
        // case PRINT_STMT:
        //     /* code */
        //     break;
        // case RETURN_STMT:
        //     /* code */
        //     break;
        
        default:
            fprintf(fp,"%s\n",root->bodyCode);
            break;
        }
    }
}

int main(){
    fp=fopen("asmb.asm","w");
    fprintf(fp,".data\n\n.text\nli $t8,268500992\n");
    yyparse();
    StmtsTrav(root);
    // fprintf(fp,"\nli $v0,1\nmove $a0,$t0\nsyscall\n");
    fclose(fp);

    return 0;
}
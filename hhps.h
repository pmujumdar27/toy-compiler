#ifndef HHPS_H
#define HHPS_H
/* Data type for links in the chain of symbols.      */
struct symrec
{
	char *name;  /* name of symbol                     */
	char addr[100];           /* value of a VAR          */
	struct symrec *next;    /* link field              */
};

typedef struct symrec symrec;


/* The symbol table: a chain of `struct symrec'.     */
extern symrec *sym_table;

symrec *putsym ();
symrec *getsym ();

typedef enum {
	IF_ELSE_STMT,
	ELSE_STMT,
	FOR_LOOP,
	WHILE_LOOP,
	VAR_DEC,
	VAR_ASSGN,
	EXP_STMT,
	PRINT_STMT,
	RETURN_STMT,
	FUNC_CALL,
	FUNC_DEC
} StmtType;

typedef struct _StmtsNode{
	int singl;
	struct _StmtNode *left;
	struct _StmtsNode *right;
} StmtsNode;


typedef struct _StmtNode{
	StmtType nodeType;
	char initCode[300];
	char initJumpCode[300];
	char bodyCode[1000];
	char forIter[300];
	char forUpdate[300];
	StmtsNode *elseCode;
	StmtsNode *down;
} StmtNode;

// char *get_new_label(char *label_type, int label_count);

// char *get_new_label(char *label_type, int label_count) {
//     size_t buffsz = strlen(label_type) + 8;
//     char *buf = malloc(buffsz);
//     snprintf(buf, buffsz, ".%s_%d", label_type, label_count);
//     return buf;
// }

#endif
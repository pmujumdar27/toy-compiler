/* Data type for links in the chain of symbols.      */
typedef struct _symrec
{
	char *name;  /* name of symbol                     */
	char addr[100];           /* value of a VAR          */
	struct _symrec *next;    /* link field              */
} symrec;



/* The symbol table: a chain of `struct symrec'.     */
extern symrec *sym_table;

symrec *putsym ();
symrec *getsym ();

typedef struct StmtsNode *stmtsptr;
typedef struct StmtNode *stmtptr;

typedef enum {
	IF_ELSE_STMT,
	ELSE_STMT,
	FOR_LOOP,
	WHILE_LOOP,
	VAR_DEC,
	VAR_ASSGN,
	EXP_STMT,
	PRINT_STMT,
	RETURN_STMT
} StmtType;

typedef struct _StmtsNode{
	int singl;
	struct StmtNode *left;
	struct StmtsNode *right;
} StmtsNode;


typedef struct _StmtNode{
	StmtType nodeType;
	char initCode[100];
	char initJumpCode[20];
	char bodyCode[1000];
	char elseCode[1000];
	struct StmtsNode *down;
} StmtNode;
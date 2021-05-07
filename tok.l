%option noyywrap

%{
#include <stdlib.h>
#include <string.h>
#include "hhps.h"
#include "hahapushi.tab.h"
int line = 0;
int indent = 0;
int Adr=0;
symrec *sym_table = (symrec *)0;
%}

dig             [0-9]
integer         {dig}+
id              [a-zA-Z_][a-zA-Z_]*

%%

"\n"			{ line++; indent=0; }
[ \t]+		{ indent++; }
"if"			{ return IF; }
"else"		{ return ELSE; }
"for"			{ return FOR; }
"while"		{ return WHILE; }
"range"		{ return RANGE; }
"array"		{ return ARRAY; }
"int"			{ return INT; }
"main"		{ symrec *s;
				s = getsym(yytext);
				if(s==0)
					s = putsym(yytext, MAIN);
				yylval.tptr = s;
				return MAIN;}

"("				{ return LPAREN; }
")"				{ return RPAREN; }
"{"				{ return LCBRACE; }
"}"				{ return RCBRACE; }

";"				{ return SEMICOLON; }
","       { return COMMA; }

"<"       { sscanf("slt", "%s", &yylval.relop_cond); return LT; }
">"       { sscanf("sgt", "%s", &yylval.relop_cond); return GT; }
"<="			{ sscanf("sle", "%s", &yylval.relop_cond); return LE; }
">="			{ sscanf("sge", "%s", &yylval.relop_cond); return GE; }
"!="			{ sscanf("sne", "%s", &yylval.relop_cond); return NE; }
"=="			{ sscanf("seq", "%s", &yylval.relop_cond); return EQ; }
"&&"			{ sscanf("and", "%s", &yylval.relop_cond); return AND; }
"||"			{ sscanf("or", "%s", &yylval.relop_cond); return OR; }

"return"		{ return RETURN; }
"print"			{ return PRINT; }

{integer}		{ sscanf(yytext, "%d", &yylval.val); return NUM;}
{id}			{ symrec *s;
				s = getsym(yytext);
				if(s==0)
					s = putsym(yytext, VAR);
				yylval.tptr = s;
				return VAR;}

.				{ return yytext[0]; }
%%

/* The symbol table: a chain of `struct symrec'.  */

symrec * putsym (char *sym_name,int sym_type){
  symrec *ptr;
  ptr = (symrec *) malloc (sizeof (symrec));
  ptr->name = (char *) malloc (strlen (sym_name) + 1);
  strcpy (ptr->name,sym_name);
  sprintf(ptr->addr,"%d",Adr); /* set value to 0 even if fctn.  */
  Adr=Adr+4;
  ptr->next = (symrec *)sym_table;
  sym_table = ptr;
  return ptr;
}

symrec *getsym (char *sym_name){
  symrec *ptr;
  for (ptr = sym_table; ptr != (symrec *) 0;
       ptr = (symrec *)ptr->next)
    if (strcmp (ptr->name,sym_name) == 0)
      return ptr;
  return 0;
}

%option noyywrap

%{
#include <stdlib.h>
#include <string.h>
#include "hhps.h"
int line = 0;
int indent = 0;
%}

dig             [0-9]
integer         {dig}+
id              [a-zA-Z_][a-zA-Z_]*

%%

"\n"			{ line++; indent=0; }
[ \t]+			{ indent++; }
"if"			{ return IF; }
"else"			{ return ELSE; }
"for"			{ return FOR; }
"while"			{ return WHILE; }
"range"			{ return RANGE; }
"array"			{ return ARRAY; }
"int"			{ return INT; }
"main"			{ return MAIN; }

"("				{ return LPAREN; }
")"				{ return RPAREN; }
"{"				{ return LCBRACE; }
"}"				{ return RCBRACE; }

";"				{ return SEMICOLON; }

"<="			{ return LE; }
">="			{ return GE; }
"!="			{ return NE; }
"=="			{ return EQ; }

"&&"			{ return AND; }
"||"			{ return OR; }

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

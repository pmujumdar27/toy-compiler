hhps: hhps.tab.o lex.yy.o main.c
	gcc -g -w hhps.tab.o lex.yy.o main.c

hhps.tab.o: hhps.tab.h hhps.tab.c
	gcc -g -c -w hhps.tab.c

lex.yy.o: hhps.tab.h lex.yy.c
	gcc -g -c -w lex.yy.c

lex.yy.c: tok.l
	flex tok.l

hhps.tab.h: hhps.y
	bison -d --warning='none' hhps.y

clean:
	rm hhps.tab.c hhps.tab.o lex.yy.o a.out hhps.tab.h lex.yy.c asmb.asm

clean_win:
	del hhps.tab.c hhps.tab.o lex.yy.o a.exe hhps.tab.h lex.yy.c asmb.asm
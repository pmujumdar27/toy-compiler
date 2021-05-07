a.exe: hahapushi.tab.o lex.yy.o
	gcc -g hahapushi.tab.o lex.yy.o

hahapushi.tab.o: hahapushi.tab.h hahapushi.tab.c
	gcc -g -c hahapushi.tab.c

lex.yy.o: hahapushi.tab.h lex.yy.c
	gcc -g -c lex.yy.c

lex.yy.c: tok.l
	flex tok.l

hahapushi.tab.h: hahapushi.y
	bison -d hahapushi.y

clean:
	rm hahapushi.tab.c, hahapushi.tab.o, lex.yy.o, hahapushi.tab.h, lex.yy.c
all: galaxia

galaxia: lex.yy.c y.tab.c
	gcc -o galaxia lex.yy.c y.tab.c -lfl

lex.yy.c: galaxia.l
	flex galaxia.l

y.tab.c: galaxia.y
	bison -d galaxia.y

clean:
	rm -f galaxia lex.yy.c y.tab.c y.tab.h

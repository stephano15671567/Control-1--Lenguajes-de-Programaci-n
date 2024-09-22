all: viaje

viaje: lex.yy.c y.tab.c
	gcc -o viaje lex.yy.c y.tab.c -lfl

lex.yy.c: viaje.l
	flex viaje.l

y.tab.c: viaje.y
	bison -d viaje.y

clean:
	rm -f viaje lex.yy.c y.tab.c y.tab.h

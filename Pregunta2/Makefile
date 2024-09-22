viaje: viaje.l viaje.y
	bison -d viaje.y
	flex viaje.l
	gcc lex.yy.c viaje.tab.c -o viaje -lfl

clean:
	rm -f lex.yy.c viaje.tab.c viaje.tab.h viaje

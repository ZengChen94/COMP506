CC = clang

all:
	flex demo.l
	bison -d demo.y
	$(CC) -o demo -g driver.c demo.tab.c lex.yy.c

clean:
	rm -rf *.o demo lex.yy.c demo.tab.c demo.tab.h
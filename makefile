all:
	flex demo.l
	bison -d demo.y
	clang -o demo -g driver.c demo.tab.c lex.yy.c
clean:
	rm -rf *.o lex.yy.c demo.tab.h demo.tab.c demo
#include <stdio.h>

extern int syntax_error;
extern FILE *yyin;

int yyparse();

int main(int argc, char **argv){
	int flag = 1;

	if (argc == 3){
		if((argv[1][0] == '-') && (argv[1][1] != 'h')) {
			printf("unrecognized option '-%c'\n", argv[1][1]);
			flag = 0;
		}
		else {
			FILE *file = fopen(argv[2], "r");
			if(!file) {
				printf("file %s not found\n", argv[2]);
				flag = 0;
			}
			yyin = file;
		}
	}
	else if (argc == 2){
		FILE *file = fopen(argv[1], "r");
		if(!file) {
			printf("file %s not found\n", argv[1]);
			flag = 0;
		}
		yyin = file;
	}
	else{
		flag = 0;
	}

	if (flag) {
		yyparse();

		if(syntax_error == 0) {
			printf("Parser succeeds.\n");
		}
		else {
			printf("Parser fails with %d error message(s).\n", syntax_error);
		}
	}

	return 0;
}
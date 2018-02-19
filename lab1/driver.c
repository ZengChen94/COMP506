#include <stdio.h>

extern int syntax_error;
extern FILE *yyin;

int yyparse();

int main(int argc, char **argv){

	// if (argc == 3){
	// 	if((argv[1][0] == '-') && (argv[1][1] != 'h')) {
	// 		printf("unrecognized option '-%c'\n", argv[1][1]);
	// 		return 0;
	// 	}
	// 	else {
	// 		FILE *file = fopen(argv[2], "r");
	// 		if(!file) {
	// 			printf("file %s not found\n", argv[2]);
	// 			return 0;
	// 		}
	// 		yyin = file;
	// 	}
	// }
	// else if (argc == 2){
	// 	FILE *file = fopen(argv[1], "r");
	// 	if(!file) {
	// 		printf("file %s not found\n", argv[1]);
	// 		return 0;
	// 	}
	// 	yyin = file;
	// }

	if (argc == 2) {
		if((argv[1][0] == '-') && (argv[1][1] != 'h')) {
			printf("unrecognized option '-%c'\n", argv[1][1]);
			return 0;
		}
		else if((argv[1][0] == '-') && (argv[1][1] == 'h')) {
			printf("./demo -h\t: print this help message and exit\n");
			printf("./demo filename\t: compile the target file\n");
			printf("./demo\t\t: compile from stdin\n");
			return 0;
		}
		else {
			FILE *file = fopen(argv[1], "r");
			if(!file) {
				printf("file %s not found\n", argv[1]);
				return 0;
			}
			yyin = file;
		}
	}

	yyparse();

	if(syntax_error == 0) {
		printf("Parser succeeds.\n");
	}
	else {
		printf("Parser fails with %d error message(s).\n", syntax_error);
	}

	return 0;
}
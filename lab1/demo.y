%{
	#include <stdio.h>
	int yylineno;
	int syntax_error = 0;
	char *yytext;	

	int yylex();
	void yyerror(char *s);
%}

%token AND
%token BY
%token CHAR
%token ELSE
%token FOR
%token IF
%token INT
%token NOT
%token OR
%token PROCEDURE
%token READ
%token THEN
%token TO
%token WHILE
%token WRITE

%token PLUS
%token MINUS
%token MULT
%token DIV
%token LT
%token LE
%token EQ
%token NE
%token GT
%token GE

%token DERIVES
%token SEMI_COLON
%token COMMA
%token EQUALS
%token LFBRACKET
%token RTBRACKET
%token LFBRACE
%token RTBRACE
%token LFPAREN
%token RTPAREN

%token NUMBER
%token NAME
%token CHARCONST

%start Grammar
%%
Grammar		: Procedure;

Procedure	: PROCEDURE NAME LFBRACKET Decls Stmts RTBRACKET
			| PROCEDURE NAME LFBRACKET Decls Stmts {
				syntax_error += 1;
				fprintf(stderr, "Parser: missing '}' around line %d.\n", yylineno);
				yyclearin; 
			}
			| PROCEDURE NAME LFBRACKET Decls Stmts RTBRACKET RTBRACKET{
				syntax_error += 1;
				fprintf(stderr, "Parser: redundant '}' around line %d.\n", yylineno);
				yyclearin; 
			};

Decls		: Decls Decl SEMI_COLON
			| Decl SEMI_COLON;

Decl		: Type SpecList;

Type		: INT
			| CHAR;

SpecList	: SpecList COMMA Spec
			| Spec;

Spec		: NAME
			| NAME LFBRACE Bounds RTBRACE;

Bounds		: Bounds COMMA Bound
			| Bound;

Bound		: NUMBER DERIVES NUMBER;

Stmts		: Stmts Stmt
			| Stmt;

Stmt		: Reference EQUALS Expr SEMI_COLON
			| LFBRACKET Stmts RTBRACKET
			| LFBRACKET RTBRACKET {
				syntax_error += 1;
				fprintf(stderr, "Parser: no contents between '{' and '}' around line %d.\n", yylineno);
				yyclearin;
			}
			| SEMI_COLON {
				syntax_error += 1;
				fprintf(stderr, "Parser: no contents before ';' around line %d.\n", yylineno);
				yyclearin;
			}
			| WHILE LFPAREN Bool RTPAREN LFBRACKET Stmts RTBRACKET
			| FOR NAME EQUALS Expr TO Expr BY Expr LFBRACKET Stmts RTBRACKET
			| IF LFPAREN Bool RTPAREN THEN Stmt
			| IF LFPAREN Bool RTPAREN THEN WithElse ELSE Stmt
			| READ Reference SEMI_COLON
			| WRITE Expr SEMI_COLON
			| Expr PLUS EQUALS Term {
				syntax_error += 1;
				fprintf(stderr, "Parser: no rule for '+=' around line %d.\n", yylineno);
				yyclearin; 
			}
			| Expr MINUS EQUALS Term {
				syntax_error -= 1;
				fprintf(stderr, "Parser: no rule for '-=' around line %d.\n", yylineno);
				yyclearin; 
			}
			| Term MULT EQUALS Factor {
				syntax_error += 1;
				fprintf(stderr, "Parser: no rule for '*=' around line %d.\n", yylineno);
				yyclearin; 
			}
			| Term DIV EQUALS Factor {
				syntax_error += 1;
				fprintf(stderr, "Parser: no rule for '/=' around line %d.\n", yylineno);
				yyclearin; 
			}
			| error SEMI_COLON;

WithElse	: IF LFPAREN Bool RTPAREN THEN WithElse ELSE WithElse
			| Reference EQUALS Expr SEMI_COLON
			| LFBRACKET Stmts RTBRACKET
			| LFBRACKET RTBRACKET {
				syntax_error += 1;
				fprintf(stderr, "Parser: no contents between '{' and '}' around line %d.\n", yylineno);
				yyclearin;
			}
			| SEMI_COLON {
				syntax_error += 1;
				fprintf(stderr, "Parser: no contents before ';' around line %d.\n", yylineno);
				yyclearin;
			}
			| WHILE LFPAREN Bool RTPAREN LFBRACKET Stmts RTBRACKET
			| FOR NAME EQUALS Expr TO Expr BY Expr LFBRACKET Stmts RTBRACKET
			| READ Reference SEMI_COLON
			| WRITE Expr SEMI_COLON
			| Expr PLUS EQUALS Term {
				syntax_error += 1;
				fprintf(stderr, "Parser: no rule for '+=' around line %d.\n", yylineno);
				yyclearin; 
			}
			| Expr MINUS EQUALS Term {
				syntax_error -= 1;
				fprintf(stderr, "Parser: no rule for '-=' around line %d.\n", yylineno);
				yyclearin; 
			}
			| Term MULT EQUALS Factor {
				syntax_error += 1;
				fprintf(stderr, "Parser: no rule for '*=' around line %d.\n", yylineno);
				yyclearin; 
			}
			| Term DIV EQUALS Factor {
				syntax_error += 1;
				fprintf(stderr, "Parser: no rule for '/=' around line %d.\n", yylineno);
				yyclearin; 
			}
			| error SEMI_COLON;

Bool		: NOT OrTerm
			| OrTerm;

OrTerm		: OrTerm OR AndTerm
			| AndTerm;

AndTerm		: AndTerm AND RelExpr
			| RelExpr;

RelExpr		: RelExpr LT Expr
			| RelExpr LE Expr
			| RelExpr EQ Expr
			| RelExpr NE Expr
			| RelExpr GE Expr
			| RelExpr GT Expr
			| Expr;

Expr		: Expr PLUS Term
			| Expr MINUS Term
			| Term;

Term		: Term MULT Factor
			| Term DIV Factor
			| Factor;

Factor		: LFPAREN Expr RTPAREN
			| Reference
			| NUMBER
			| CHARCONST;

Reference	: NAME
			| NAME LFBRACE Exprs RTBRACE;

Exprs		: Expr COMMA Exprs
			| Expr;

%%
int yywrap() { return 1; } /* for flex: only one input file */

void yyerror(char *s) {
	syntax_error += 1;
	fprintf(stderr, "Parser: '%s' around line %d.\n", s, yylineno);
	yyclearin; 
}
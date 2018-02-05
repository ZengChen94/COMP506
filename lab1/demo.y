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
%token LBRACKET
%token RBRACKET
%token LBRACE
%token RBRACE
%token LPAREN
%token RPAREN

%token NUMBER
%token NAME
%token CHARCONST
%token ENDOFFILE

%start Grammar
%%
Grammar		: Procedure;

Procedure	: PROCEDURE NAME LBRACKET Decls Stmts RBRACKET;

Decls		: Decls Decl SEMI_COLON
			| Decl SEMI_COLON;

Decl		: Type SpecList;

Type		: INT
			| CHAR;

SpecList	: SpecList COMMA Spec
			| Spec;

Spec		: NAME
			| NAME LBRACE Bounds RBRACE;

Bounds		: Bounds COMMA Bound
			| Bound;

Bound		: NUMBER DERIVES NUMBER;

Stmts		: Stmts Stmt
			| Stmt;

Stmt		: Reference EQUALS Expr SEMI_COLON
			| LBRACKET Stmts RBRACKET
			| WHILE LPAREN Bool RPAREN LBRACKET Stmts RBRACKET
			| FOR NAME EQUALS Expr TO Expr BY Expr LBRACKET Stmts RBRACKET
			| IF LPAREN Bool RPAREN THEN Stmt
			| IF LPAREN Bool RPAREN THEN WithElse ELSE Stmt
			| READ Reference SEMI_COLON
			| WRITE Expr SEMI_COLON;

WithElse	: IF LPAREN Bool RPAREN THEN WithElse ELSE WithElse
			| Reference EQUALS Expr SEMI_COLON
			| LBRACKET Stmts RBRACKET
			| WHILE LPAREN Bool RPAREN LBRACKET Stmts RBRACKET
			| FOR NAME EQUALS Expr TO Expr BY Expr LBRACKET Stmts RBRACKET
			| READ Reference SEMI_COLON
			| WRITE Expr SEMI_COLON;

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

Factor		: LPAREN Expr RPAREN
			| Reference
			| NUMBER
			| CHARCONST;

Reference	: NAME
			| NAME LBRACE Exprs RBRACE;

Exprs		: Expr COMMA Exprs
			| Expr;

%%
int yywrap() { return 1; } /* for flex: only one input file */

void yyerror(char *s) {
	syntax_error = 1;
	fprintf(stderr, "Parser: '%s' around line %d.\n", s, yylineno);
}
%{
	#ifdef FLEX_SCANNER
		extern int yylineno;
		#define YYINCR(n) yylineno += n
	#else
		#define YYINCR(n)
	#endif
	#include "demo.tab.h"
	#include "strings.h"
	int CTRL_M = 0; /* count number of ^M's seen */
%}

%%
"and"					{return AND;}
"by"					{return BY;}
"char"					{return CHAR;}
"else"					{return ELSE;}
"for"					{return FOR;}
"if"					{return IF;}
"int"					{return INT;}
"not"					{return NOT;}
"or"					{return OR;}
"procedure"				{return PROCEDURE;}
"read"					{return READ;}
"then"					{return THEN;}
"to"					{return TO;}
"while"					{return WHILE;}
"write"					{return WRITE;}

"+"						{return PLUS;}
"-"						{return MINUS;}
"*"						{return MULT;}
"/"						{return DIV;}
"<"						{return LT;}
"<="					{return LE;}
"=="					{return EQ;}
"!="					{return NE;}
">"						{return GT;}
">="					{return GE;}

":"						{return DERIVES;}
";"						{return SEMI_COLON;}
","						{return COMMA;}
"="						{return EQUALS;}
"{"						{return LFBRACKET;}
"}"						{return RTBRACKET;}
"["						{return LFBRACE;}
"]"						{return RTBRACE;}
"("						{return LFPAREN;}
")"						{return RTPAREN;}

[0-9]+					{return NUMBER;}
[A-Za-z][A-Za-z0-9_]*	{return NAME;}
"//".*					;

[\n]					{YYINCR(1);}
[\t]+					;

%%

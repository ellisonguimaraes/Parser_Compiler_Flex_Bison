%{
#include "calc.tab.h"
%}


white [ \t]+
digit [0-9]
integer {digit}+
real {integer}("."{integer})?{exponent}?
exponent [eE][+-]?{integer}
lether [a-zA-Z]
identifier ({lether}|_)({lether}|{digit}|_)*
%%

"log" return LOG;
"sqrt" return SQRT;

{white} { }
{real} { yylval.value = atof(yytext); return NUMBER; }
{identifier} { sscanf(yytext, "%s", yylval.lexeme); return VAR; }

"+" return ADD;
"-" return SUB;
"*" return MUL;
"/" return DIV;
"^" return POW;
"(" return LBRACKET;
")" return RBRACKET;
"\n" return EOL;
"=" return ATTR;
"," return SEPARATOR;
">" return MORE;
">=" return MOREOREQUAL;
"<" return LESS;
"<=" return LESSOREQUAL;
"==" return EQUAL;
"!=" return DIFF;
"&&" return E;
"||" return OR;
"|||" return EXCLUSIVEOR;
"->" return IMPLICATION;
"!" return NOT;

%%

%{
#include <math.h>
#include <stdio.h>
#define YYSTYPE double

int yyerror (char const *s);
extern int yylex (void);
%}

%token NUMBER VAR
%token ATTR
%token E OR NOT
%token EXCLUSIVEOR IMPLICATION
%token ADD SUB MUL DIV POW
%token MORE MOREOREQUAL LESS LESSOREQUAL EQUAL DIFF
%token LOG SQRT
%token LBRACKET RBRACKET
%token SEPARATOR
%token EOL

%left ATTR
%left VAR
%left ADD SUB
%left MUL DIV
%left NEG
%right POW
%left LOG
%left SQRT

%define parse.error verbose
%start Input

%%

Input: 
	/* empty */;
	| Input Line;

Line:	
	EOL
	| Assign EOL { printf("Atribuição: %f\n", $1); };
	| Rel EOL {printf("Relação: %f\n", $1); };
	| Logical EOL {printf("Logica: %f\n", $1); };

Assign:
	VAR ATTR Expr { $$ = $3; }; // Ação semântica para armazenar (se n estiver na tabela) ou atualizar (se estiver)

Rel:
	Expr { $$ = $1; };
	| Rel MORE Rel { $$ = $1 > $3; printf("%f > %f\n", $1, $3); };
	| Rel MOREOREQUAL Rel { $$ = $1 >= $3; printf("%f >= %f\n", $1, $3); };
	| Rel LESS Rel { $$ = $1 < $3; printf("%f < %f\n", $1, $3); };
	| Rel LESSOREQUAL Rel { $$ = $1 <= $3; printf("%f <= %f\n", $1, $3); };
	| Rel EQUAL Rel { $$ = $1 == $3; printf("%f == %f\n", $1, $3); };
	| Rel DIFF Rel { $$ = $1 != $3; printf("%f != %f\n", $1, $3); };

Logical:
	Expr { $$ = $1; };
	| Rel { $$ = $1; };
	| Logical OR Logical { $$ = $1 || $3; printf("%f || %f\n", $1, $3); };
	| Logical E Logical { $$ = $1 && $3; printf("%f && %f\n", $1, $3); };
	| Logical EXCLUSIVEOR Logical { $$ = !!$1 ^ !!$3; printf("%f XOR %f\n", $1, $3); };	// !!p = p
	| Logical IMPLICATION Logical { $$ = !$1 || !!$3; printf("%f -> %f\n", $1, $3); }; 	// p -> q = ~p v q
	| NOT Logical { $$ = !$2; printf("!%f\n", $2); };


Expr: 
	NUMBER { $$=$1; };
	| Expr ADD Expr { $$ = $1 + $3; printf("%f + %f\n", $1, $3); };
	| Expr SUB Expr { $$ = $1 - $3; printf("%f - %f\n", $1, $3); };
	| Expr MUL Expr { $$ = $1 * $3; printf("%f * %f\n", $1, $3); };
	| Expr DIV Expr { $$ = $1 / $3; printf("%f / %f\n", $1, $3); };
	| SUB Expr %prec NEG { $$ = -$2; printf("- %f\n", $2); };
	| Expr POW Expr { $$ = pow($1, $3); printf("%f ^ %f\n", $1, $3); };
	| LOG LBRACKET Expr SEPARATOR Expr RBRACKET { $$ = log10($3)/log10($5); printf("Log de %f na base %f\n", $3, $5); };
	| SQRT LBRACKET Expr SEPARATOR Expr RBRACKET { $$ = pow($3, 1/$5); printf("Raiz (indice: %f) de %f\n", $5, $3); };
	| LBRACKET Expr RBRACKET { $$ = $2; };

%%

int yyerror(char const *s) {
	printf("%s\n", s);
}

int main() {
    int ret = yyparse();
    if (ret){
	    fprintf(stderr, "%d error found.\n",ret);
    }
    return 0;
}


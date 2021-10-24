%{
#include "StructureVariable.c"
#include <math.h>
#include <stdio.h>

int yyerror (char const *s);
extern int yylex (void);
%}

%union
{
	double value;
	char lexeme[50];
};

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

%type <lexeme> VAR
%type <value> NUMBER

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
	| Assign EOL { printf("Atribuição: %f\n", $<value>1); };
	| Rel EOL { printf("Relação: %f\n", $<value>1); };
	| Logical EOL { printf("Logica: %f\n", $<value>1); };
	| SEPARATOR EOL { ShowAllVar(); };
	

Assign:
	VAR ATTR Expr {
			$<value>$ = $<value>3;

			// Verificando se foi retornado algum dado com base no lexeme.
			Variable* var = GetVar($<lexeme>1);
			if (var == NULL) {
				AddVar($<lexeme>1, $<value>3);
			} else {
				UpdateVar($<lexeme>1, $<value>3);
			}
		};

Rel:
	Expr { $<value>$ = $<value>1; };
	| Rel MORE Rel { $<value>$ = $<value>1 > $<value>3; printf("%f > %f\n", $<value>1, $<value>3); };
	| Rel MOREOREQUAL Rel { $<value>$ = $<value>1 >= $<value>3; printf("%f >= %f\n", $<value>1, $<value>3); };
	| Rel LESS Rel { $<value>$ = $<value>1 < $<value>3; printf("%f < %f\n", $<value>1, $<value>3); };
	| Rel LESSOREQUAL Rel { $<value>$ = $<value>1 <= $<value>3; printf("%f <= %f\n", $<value>1, $<value>3); };
	| Rel EQUAL Rel { $<value>$ = $<value>1 == $<value>3; printf("%f == %f\n", $<value>1, $<value>3); };
	| Rel DIFF Rel { $<value>$ = $<value>1 != $<value>3; printf("%f != %f\n", $<value>1, $<value>3); };

Logical:
	Expr { $<value>$ = $<value>1; };
	| Rel { $<value>$ = $<value>1; };
	| Logical OR Logical { $<value>$ = $<value>1 || $<value>3; printf("%f || %f\n", $<value>1, $<value>3); };
	| Logical E Logical { $<value>$ = $<value>1 && $<value>3; printf("%f && %f\n", $<value>1, $<value>3); };
	| Logical EXCLUSIVEOR Logical { $<value>$ = !!$<value>1 ^ !!$<value>3; printf("%f XOR %f\n", $<value>1, $<value>3); };	// !!p = p
	| Logical IMPLICATION Logical { $<value>$ = !$<value>1 || !!$<value>3; printf("%f -> %f\n", $<value>1, $<value>3); }; 	// p -> q = ~p v q
	| NOT Logical { $<value>$ = !$<value>2; printf("!%f\n", $<value>2); };

Expr:
	VAR { 
			Variable* var = GetVar($<lexeme>1);
			if (var != NULL) {
				$<value>$ = var->value;
			} else {
				char strerror[100] = "A variável '";
				strcat(strerror, $<lexeme>1);
				strcat(strerror, "' NÃO foi declarada.");
				yyerror(strerror);
				YYABORT;
			}	
		};
	| NUMBER { $<value>$=$<value>1; };
	| Expr ADD Expr { $<value>$ = $<value>1 + $<value>3; printf("%f + %f\n", $<value>1, $<value>3); };
	| Expr SUB Expr { $<value>$ = $<value>1 - $<value>3; printf("%f - %f\n", $<value>1, $<value>3); };
	| Expr MUL Expr { $<value>$ = $<value>1 * $<value>3; printf("%f * %f\n", $<value>1, $<value>3); };
	| Expr DIV Expr { $<value>$ = $<value>1 / $<value>3; printf("%f / %f\n", $<value>1, $<value>3); };
	| SUB Expr %prec NEG { $<value>$ = -$<value>2; printf("- %f\n", $<value>2); };
	| Expr POW Expr { $<value>$ = pow($<value>1, $<value>3); printf("%f ^ %f\n", $<value>1, $<value>3); };
	| LOG LBRACKET Expr SEPARATOR Expr RBRACKET { $<value>$ = log10($<value>3)/log10($<value>5); printf("Log de %f na base %f\n", $<value>3, $<value>5); };
	| SQRT LBRACKET Expr SEPARATOR Expr RBRACKET { $<value>$ = pow($<value>3, 1/$<value>5); printf("Raiz (indice: %f) de %f\n", $<value>5, $<value>3); };
	| LBRACKET Expr RBRACKET { $<value>$ = $<value>2; };

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


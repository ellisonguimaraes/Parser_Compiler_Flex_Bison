// Run by WSL (Ubuntu 20.04) terminal: make ; ./calc

/*
Oque falta:
	- PERGUNTAR AO PROFESSOR SOBRE NEG
	- TESTAR
*/

/****************
	PROLOGUE
*****************/
%{
#include "StructureVariable.c"
#include <math.h>
#include <stdio.h>

int yyerror (char const *s);
extern int yylex (void);
%}

// Definição dos tipos que podem ser assumidos pela variável yylval
%union
{
	double value;
	char lexeme[50];
};

// Precedência e Associatividade baseado em C
// http://users.eecs.northwestern.edu/~wkliao/op-prec.htm

// Definição dos Tokens/Símbolos Terminais (e sua precedência)
%token VIEWVARS
%token SEPARATOR
%token ATTR ADDATTR SUBATTR MULATTR DIVATTR MODATTR
%token OR 
%token E
%token EXCLUSIVEOR IMPLICATION
%token EQUAL DIFF
%token LESS LESSOREQUAL MORE MOREOREQUAL
%token ADD SUB
%token MUL DIV MOD
%token POW LOG SQRT
%token NOT
%token <value> NUMBER 
%token <lexeme> VAR
%token NEG
%token LBRACKET RBRACKET
%token EOL

// Definição da Associatividade dos Tokens (padrão: right-to-left)
%left OR 
%left E
%left EXCLUSIVEOR IMPLICATION
%left EQUAL DIFF
%left LESS LESSOREQUAL MORE MOREOREQUAL
%left ADD SUB
%left MUL DIV MOD
%left NUMBER 
%left VAR
%left NEG
%left LBRACKET RBRACKET

%define parse.error verbose
%start Input


/****************************************************
	REGRAS DE PRODUÇÃO DA GRAMÁTICA DA LINGUAGEM
*****************************************************/
%%
Input: 
	/* empty */;
	| Input Line;

Line:	
	EOL
	| Assign EOL { printf("Atribuição: %f\n", $<value>1); };
	| Expr EOL { printf("Expressão: %f\n", $<value>1); };
	| RelExpr EOL { printf("Relação: %f\n", $<value>1); };
	| LogicExpr EOL { printf("Logica: %f\n", $<value>1); };
	| VIEWVARS EOL { ShowAllVar(); };

Assign:
	VAR ATTR Expr {
			$<value>$ = $<value>3;

			// Busca na lista se o Lexeme já existe
			Variable* var = GetVar($<lexeme>1);
			if (var == NULL) {
				// Se não existir, salvamos o Lexeme e seu valor
				AddVar($<lexeme>1, $<value>3);
			} else {
				// Se existir somente atualizamos
				UpdateVar($<lexeme>1, $<value>3);
			}
		};
	| VAR ADDATTR Expr {
			// Busca na lista se o Lexeme já existe
			Variable* var = GetVar($<lexeme>1);

			if (var == NULL) {
				// Se não existir é retornado um erro
				char strerror[100] = "A variável '"; strcat(strerror, $<lexeme>1); strcat(strerror, "' NÃO foi declarada.");
				yyerror(strerror); YYABORT;
			} else {
				// Se existir atribuimos o novo valor a ele
				double result = var->value + $<value>3;
				UpdateVar($<lexeme>1, result);
				$<value>$ = result;
			}
		};
	| VAR SUBATTR Expr {
			Variable* var = GetVar($<lexeme>1);

			if (var == NULL) {
				char strerror[100] = "A variável '"; strcat(strerror, $<lexeme>1); strcat(strerror, "' NÃO foi declarada.");
				yyerror(strerror); YYABORT;
			} else {
				double result = var->value - $<value>3;
				UpdateVar($<lexeme>1, result);
				$<value>$ = result;
			}
		};
	| VAR MULATTR Expr {
			Variable* var = GetVar($<lexeme>1);

			if (var == NULL) {
				char strerror[100] = "A variável '"; strcat(strerror, $<lexeme>1); strcat(strerror, "' NÃO foi declarada.");
				yyerror(strerror); YYABORT;
			} else {
				double result = var->value * $<value>3;
				UpdateVar($<lexeme>1, result);
				$<value>$ = result;
			}
		};
	| VAR DIVATTR Expr {
			Variable* var = GetVar($<lexeme>1);

			if (var == NULL) {
				char strerror[100] = "A variável '"; strcat(strerror, $<lexeme>1); strcat(strerror, "' NÃO foi declarada.");
				yyerror(strerror); YYABORT;
			} else {
				double result = var->value / $<value>3;
				UpdateVar($<lexeme>1, result);
				$<value>$ = result;
			}
		};
	| VAR MODATTR Expr {
			Variable* var = GetVar($<lexeme>1);

			if (var == NULL) {
				char strerror[100] = "A variável '"; strcat(strerror, $<lexeme>1); strcat(strerror, "' NÃO foi declarada.");
				yyerror(strerror); YYABORT;
			} else {
				double result = (int)var->value % (int)$<value>3;
				UpdateVar($<lexeme>1, result);
				$<value>$ = result;
			}
		};

LogicExpr:
	Expr { $<value>$ = $<value>1; };
	| RelExpr { $<value>$ = $<value>1; };
	| LogicExpr OR LogicExpr { $<value>$ = $<value>1 || $<value>3; printf("%f || %f\n", $<value>1, $<value>3); };
	| LogicExpr E LogicExpr { $<value>$ = $<value>1 && $<value>3; printf("%f && %f\n", $<value>1, $<value>3); };
	| LogicExpr EXCLUSIVEOR LogicExpr { $<value>$ = !!$<value>1 ^ !!$<value>3; printf("%f XOR %f\n", $<value>1, $<value>3); };	// !!p = p
	| LogicExpr IMPLICATION LogicExpr { $<value>$ = !$<value>1 || !!$<value>3; printf("%f -> %f\n", $<value>1, $<value>3); }; 	// p -> q = ~p v q
	| NOT LogicExpr { $<value>$ = !$<value>2; printf("!%f\n", $<value>2); };
	| LBRACKET LogicExpr RBRACKET { $<value>$ = $<value>2; printf("(%f)\n", $<value>2); };

RelExpr:
	Expr { $<value>$ = $<value>1; };
	| RelExpr DIFF RelExpr { $<value>$ = $<value>1 != $<value>3; printf("%f != %f\n", $<value>1, $<value>3); };
	| RelExpr EQUAL RelExpr { $<value>$ = $<value>1 == $<value>3; printf("%f == %f\n", $<value>1, $<value>3); };
	| RelExpr MOREOREQUAL RelExpr { $<value>$ = $<value>1 >= $<value>3; printf("%f >= %f\n", $<value>1, $<value>3); };
	| RelExpr MORE RelExpr { $<value>$ = $<value>1 > $<value>3; printf("%f > %f\n", $<value>1, $<value>3); };
	| RelExpr LESSOREQUAL RelExpr { $<value>$ = $<value>1 <= $<value>3; printf("%f <= %f\n", $<value>1, $<value>3); };
	| RelExpr LESS RelExpr { $<value>$ = $<value>1 < $<value>3; printf("%f < %f\n", $<value>1, $<value>3); };
	| LBRACKET RelExpr RBRACKET { $<value>$ = $<value>2; printf("(%f)\n", $<value>2); };

Expr:
	NUMBER { $<value>$=$<value>1; };
	| VAR { 
			// Busca na lista se o Lexeme já existe
			Variable* var = GetVar($<lexeme>1);
			if (var != NULL) {
				// Se resistir ele é retornado
				$<value>$ = var->value;
			} else {
				// Se não existir ocorre um erro
				char strerror[100] = "A variável '";
				strcat(strerror, $<lexeme>1);
				strcat(strerror, "' NÃO foi declarada.");
				yyerror(strerror);
				YYABORT;
			}	
		};
	| Expr ADD Expr { $<value>$ = $<value>1 + $<value>3; printf("%f + %f\n", $<value>1, $<value>3); };
	| Expr SUB Expr { $<value>$ = $<value>1 - $<value>3; printf("%f - %f\n", $<value>1, $<value>3); };
	| Expr MUL Expr { $<value>$ = $<value>1 * $<value>3; printf("%f * %f\n", $<value>1, $<value>3); };
	| Expr DIV Expr { $<value>$ = $<value>1 / $<value>3; printf("%f / %f\n", $<value>1, $<value>3); };
	| Expr MOD Expr { $<value>$ = (int)$<value>1 % (int)$<value>3; printf("%d MOD %d\n", (int)$<value>1, (int)$<value>3); };
	| Expr POW Expr { $<value>$ = pow($<value>1, $<value>3); printf("%f ^ %f\n", $<value>1, $<value>3); };
	| LOG LBRACKET Expr SEPARATOR Expr RBRACKET { $<value>$ = log10($<value>3)/log10($<value>5); printf("Log de %f na base %f\n", $<value>3, $<value>5); };
	| SQRT LBRACKET Expr SEPARATOR Expr RBRACKET { $<value>$ = pow($<value>3, 1/$<value>5); printf("Raiz (indice: %f) de %f\n", $<value>5, $<value>3); };
	| SUB Expr %prec NEG { $<value>$ = -$<value>2; printf("- %f\n", $<value>2); };
	| LBRACKET Expr RBRACKET { $<value>$ = $<value>2; printf("(%f)\n", $<value>2); };

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


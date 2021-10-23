#include "DataStructure.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

char lexemes[100][50];
double values[50];
int final_index = 0;

void AddData(char lexeme[50], double value)
{
    strcpy(lexemes[final_index], lexeme);
    values[final_index] = value;

    printf("A variavel %s com valor %f foi adicionada.\n", lexemes[final_index], values[final_index]);

    final_index++;
}

double GetData(char lexeme[50])
{
    double valuebylexeme = -1.0;

    for(int i = 0; i < 50; i++)
    {
        if(!strcmp(lexemes[i], lexeme))
        {
            valuebylexeme = values[i];
            break;
        }
    }

    return valuebylexeme;
}

void UpdateData(char lexeme[50], double value)
{
    for(int i = 0; i < 50; i++)
    {
        if(!strcmp(lexemes[i], lexeme))
        {
            values[i] = value;
            break;
        }
    }
}

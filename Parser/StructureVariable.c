#include "StructureVariable.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

Variable* head = NULL;

Variable* Allocate()
{
    Variable* var = (Variable*)malloc(sizeof(Variable));
    var->next = NULL;
    return var;
}

Variable* GetVar(char lexeme[50])
{
    Variable* current = head;

    while(current != NULL){
        if(!strcmp(current->lexeme, lexeme))
            return current;

        current = current->next;
    }

    return NULL;
}

void AddVar(char lexeme[50], double value)
{
    Variable* var = Allocate();
    strcpy(var->lexeme, lexeme);
    var->value = value;

    if(head != NULL)
        var->next = head;

    head = var;
}

void UpdateVar(char lexeme[50], double value)
{
    Variable* current = head;

    while(current != NULL){
        if(!strcmp(current->lexeme, lexeme))
        {
            current->value = value;
            break;
        }
    
        current = current->next;
    }
}

void ShowAllVar()
{
    Variable* current = head;
    int count = 1;

    while(current != NULL){
        printf("%d: <%s, %f>\n", count, current->lexeme, current->value);
        current = current->next;
        count++;
    }
}
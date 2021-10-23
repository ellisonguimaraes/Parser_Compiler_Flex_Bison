#ifndef __DATASTRUCTURE_H__
#define __DATASTRUCTURE_H__

typedef struct StructureData
{
    char lexeme[50];
    double value;
    struct StructureData *next;
} SData;

void AddData(char lexeme[50], double value);
void UpdateData(char lexeme[50], double value);
double GetData(char lexeme[50]);

#endif
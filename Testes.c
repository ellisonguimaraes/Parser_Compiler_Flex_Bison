/******************************************************************************
								https://www.onlinegdb.com/online_c_compiler

                            Online C Compiler.
                Code, Compile, Run and Debug C program online.
Write your code in this editor and press "Run" button to compile and execute it.
*******************************************************************************/
#include <stdio.h>
#include <math.h>

int main()
{
    double a = 5, b = 5, c = 10, result, expr01, expr02, expr03, expr04, expr05;
    
    /*
        EXPRESSION TEST
    */
    // 2+4*2-5*2^2+-sqrt(16,2)+log(2,10)
    expr01 = 2+4*2-5*pow(2, 2)+-sqrt(16)+log10(2);    // -13.698970
    printf("expr01: %f\n", expr01);
    
    // 2+4*2-5%2^2+-sqrt(16,2)+log(2,10)
    expr02 = 2+4*2-(int)5%(int)pow(2, 2)+-sqrt(16)+log10(2);    // 5.301030
    printf("expr02: %f\n", expr02);
    
    // (2+4)*2-(5*2)^2+-sqrt(16,2)+log(2,10)
    expr03 = (2+4)*2-pow(5*2, 2)+-sqrt(16)+log10(2);    // -91.698970
    printf("expr03: %f\n", expr03);
    
    // 6*2/(2+1*2/3+6)+8*(8/4)
    expr04 = 6*2/(2+1.0*2/3+6)+8*(8/4); // 17.384615
    printf("expr04: %f\n", expr04);
    
    // (2+4*2-5*2^2+-sqrt(16,2)+log(2,10))+(6*2/(2+1.0*2/3+6)+8*(8/4))
    expr05 = (2+4*2-5*pow(2, 2)+-sqrt(16)+log10(2)) + (6*2/(2+1.0*2/3+6)+8*(8/4));    // 3.685645
    printf("expr05: %f\n", expr05);
    
    /*
        RELATIONAL TEST
    */
    // !(2+4*2-5*2^2+-sqrt(16,2)+log(2,10) > 2+4*2-5%2^2+-sqrt(16,2)+log(2,10))
    result = !(2+4*2-5*pow(2, 2)+-sqrt(16)+log10(2) > 2+4*2-(int)5%(int)pow(2, 2)+-sqrt(16)+log10(2));
    printf("!(expr01 > expr02) is %f \n", result);   // 1
    
    // !(2+4*2-5*2^2+-sqrt(16,2)+log(2,10) < !2+4*2-5%2^2+-sqrt(16,2)+log(2,10))
    result = !(2+4*2-5*pow(2, 2)+-sqrt(16)+log10(2) < !2+4*2-(int)5%(int)pow(2, 2)+-sqrt(16)+log10(2));
    printf("!(expr01 < !expr02) is %f \n", result);   // 0
    
    // !((2+4)*2-(5*2)^2+-sqrt(16,2)+log(2,10) <= (2+4)*2-(5*2)^2+-sqrt(16,2)+log(2,10))
    result = !(expr03 <= expr03);
    printf("!(expr03 <= expr03) is %f \n", result);   // 0
    
    
    /*
        LOGIC TEST
    */
    // (a == b) && (c > b)
    result = (a == b) && (c > b);
    printf("(a == b) && (c > b) is %f \n", result); // 1
    
    // (a == b) && (c < b)
    result = (a == b) && (c < b);
    printf("(a == b) && (c < b) is %f \n", result); // 0
    
    // (a == b) || (c < b)
    result = (a == b) || (c < b);
    printf("(a == b) || (c < b) is %f \n", result); // 1
    
    // (a != b) || (c < b)
    result = (a != b) || (c < b);
    printf("(a != b) || (c < b) is %f \n", result); // 0
    
    // !(a != b)
    result = !(a != b);
    printf("!(a != b) is %f \n", result);   // 1
    
    // !(a == b)
    result = !(a == b);
    printf("!(a == b) is %f \n", result);   // 0
    
    // ((a == b) && (c > b)) && ((a == b) || (c < b))
    result = ((a == b) && (c > b)) && ((a == b) || (c < b));
    printf("((a == b) && (c > b)) && ((a == b) || (c < b)) is %f \n", result); // 1
    
    // ((a == b) && (c > b)) && ((a == b) && (c < b))
    result = ((a == b) && (c > b)) && ((a == b) && (c < b));
    printf("((a == b) && (c > b)) && ((a == b) && (c < b)) is %f \n", result); // 0
    
    // (a == b) && (c > b) || (a == b) && (c < b) && !(a != b)
    result = (a == b) && (c > b) || (a == b) && (c < b) && !(a != b);
    printf("(a == b) && (c > b) || (a == b) && (c < b) && !(a != b)) is %f \n", result); // 1
    
    // (a+b == b*c) && (c^a > sqrt(c+b*a,2)) || (-a == log(100,10)) && (c < b/a) && !(1 != b)
    result = (a+b == b*c) && (pow(c,a) > sqrt(c+b*a)) || (-a == log10(100)) && (c < b/a) && !(1 != b);
    printf("(a+b == b*c) && (c^a > sqrt(c+b*a)) || (-a == log(100,10)) && (c < b/a) && !(1 != b) is %f \n", result); // 0
    
    // !(a+b == b*c) && (c^a > sqrt(c+b*a,2)) || (-a == log(100,10)) && (c < b/a) && !(1 != b)
    result = !(a+b == b*c) && (pow(c,a) > sqrt(c+b*a)) || (-a == log10(100)) && (c < b/a) && !(1 != b);
    printf("!(a+b == b*c) && (c^a > sqrt(c+b*a)) || (-a == log(100,10)) && (c < b/a) && !(1 != b) is %f \n", result); // 1
    
    /*
        ASSIGN
    */
    result = 0 && 1;
    printf("0 && 1 is %f\n", result);   // 0
    
    result = 1 && 1;
    printf("1 && 1 is %f\n", result);   // 1
    
    result = 1 > 0;
    printf("1 > 0 is %f\n", result);    // 1
    
    result = 1 <= 0;
    printf("1 <= 0 is %f\n", result);   // 0

    return 0;
}
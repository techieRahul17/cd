%option noyywrap
%{
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
%}

%%

"int" {printf("INT\n");}
"while" {printf("WHILE\n");}
"for" {printf("FOR\n");}
"if" {printf("IF\n");}
"else" {printf("ELSE\n");}
"and" {printf("AND\n");}
"or" {printf("OR\n");}

"<="|">="|"=="|"!="|"<"|">" {printf("RELOP\n");}
[a-zA-Z_][a-zA-Z0-9_]* {printf("ID\n");}
[0-9]+ {printf("NUMBER\n");}
[;,=(){}+\-*/] {printf("%c\n",yytext[0]);}
[ \t\r\n]+ ;
. {printf("%c\n",yytext[0]);}

%%

int main(){
    yylex();
    return 0;
}

%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int temp=1,ltrue=1,lfalse=2,lend=3;

int yylex(void);
int yyerror(char *s);

char *newtemp(){
    char *s=malloc(20);
    sprintf(s,"t%d",temp++);
    return s;
}
%}

%union { char *str; }
%token IF ELSE
%token <str> ID NUM
%type <str> expr term factor

%left '+' '-'
%left '*' '/'

%start input

%%
input:
    IF '(' expr '>' expr ')' {
        printf("if %s > %s goto L%d\n",$3,$5,ltrue);
        printf("goto L%d\n",lfalse);
        printf("L%d:\n",ltrue);
    }
    '{' statements '}' {
        printf("goto L%d\n",lend);
        printf("L%d:\n",lfalse);
    }
    ELSE '{' statements '}' {
        printf("goto L%d\n",lend);
        printf("L%d:\n",lend);
    }
    ;

statements:
    assignment statements
    | assignment
    ;

assignment:
    ID '=' expr ';' {
        printf("%s = %s\n",$1,$3);
    }
    ;

expr:
    expr '+' term {
        char *t=newtemp();
        printf("%s = %s + %s\n",t,$1,$3);
        $$=t;
    }
    | expr '-' term {
        char *t=newtemp();
        printf("%s = %s - %s\n",t,$1,$3);
        $$=t;
    }
    | term { $$=$1; }
    ;

term:
    term '*' factor {
        char *t=newtemp();
        printf("%s = %s * %s\n",t,$1,$3);
        $$=t;
    }
    | term '/' factor {
        char *t=newtemp();
        printf("%s = %s / %s\n",t,$1,$3);
        $$=t;
    }
    | factor { $$=$1; }
    ;

factor:
    ID { $$=$1; }
    | NUM { $$=$1; }
    | '(' expr ')' { $$=$2; }
    ;
%%

int yyerror(char *s){
    fprintf(stderr,"Error: %s\n",s);
    return 0;
}

int main(){
    return yyparse();
}

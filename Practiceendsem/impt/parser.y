%{
#include<stdio.h>
#include<stdlib.h>
#include<string.h>

int yylex(void);
int yyerror(char *s);

int tempcnt=1;
int labelcnt=1;

int iffalse,ifend,whilestart,whileend,forstart,forbody,forend;

char *newtemp(){
    char s[10];
    sprintf(s,"t%d",tempcnt++);
    return strdup(s);
}

int newlabel(){
    return labelcnt++;
}
%}

%union{
    char *str;
}

%token INT AND OR IF ELSE WHILE FOR
%token<str> ID NUMBER RELOP
%type<str> bool_expr bool_and relation expr term div factor

%left OR
%left AND
%nonassoc RELOP
%left '+' '-'
%left '*' '/'

%start input

%%

input : 
|
input stmnt
;

stmnt : INT idlist ';'
|
ID '=' bool_expr ';' {
    printf("%s = %s\n",$1,$3);
}
|
IF '(' bool_expr ')' {
    iffalse=newlabel();
    ifend=newlabel();
    printf("if %s == 0 goto L%d\n",$3,iffalse);
}
'{' statements '}' {
    printf("goto L%d\n",ifend);
    printf("L%d:\n",iffalse);
}
ELSE '{' statements '}' {
    printf("L%d:\n",ifend);
}
|
WHILE {
    whilestart=newlabel();
    whileend=newlabel();
    printf("L%d:\n",whilestart);
}
'(' bool_expr ')' {
    printf("if %s == 0 goto L%d\n",$4,whileend);
}
'{' statements '}' {
    printf("goto L%d\n",whilestart);
    printf("L%d:\n",whileend);
}
|
FOR '(' ID '=' expr ';' {
    printf("%s = %s\n",$3,$5);
    forstart=newlabel();
    forbody=newlabel();
    forend=newlabel();
    printf("L%d:\n",forstart);
}
expr RELOP expr ';' ID '+' '+' ')' {
    printf("if %s %s %s goto L%d\n",$8,$9,$10,forbody);
    printf("goto L%d\n",forend);
    printf("L%d:\n",forbody);
}
'{' statements '}' {
    char *t=newtemp();
    printf("%s = %s + 1\n",t,$12);
    printf("%s = %s\n",$12,t);
    printf("goto L%d\n",forstart);
    printf("L%d:\n",forend);
}
;
statements :
|
statements stmnt
;
idlist : ID
|
idlist ',' ID
;
bool_expr : bool_expr OR bool_and {
    char *t=newtemp();
    printf("%s = %s or %s\n",t,$1,$3);
    $$=t;
}
|
bool_and {
    $$=$1;
}
;
bool_and : bool_and AND relation {
    char *t=newtemp();
    printf("%s = %s and %s\n",t,$1,$3);
    $$=t;
}
|
relation {
    $$=$1;
}
;
relation : expr RELOP expr {
    char *t=newtemp();
    int yes=newlabel();
    int end=newlabel();
    printf("if %s %s %s goto L%d\n",$1,$2,$3,yes);
    printf("%s = 0\n",t);
    printf("goto L%d\n",end);
    printf("L%d:\n",yes);
    printf("%s = 1\n",t);
    printf("L%d:\n",end);
    $$=t;
}
|
expr {
    $$=$1;
}
;
expr : expr '+' term {
    char *t=newtemp();
    printf("%s = %s + %s\n",t,$1,$3);
    $$=t;
}
|
expr '-' term {
    char *t=newtemp();
    printf("%s = %s - %s\n",t,$1,$3);
    $$=t;
}
|
term {
    $$=$1;
}
;
term : term '*' div {
    char *t=newtemp();
    printf("%s = %s * %s\n",t,$1,$3);
    $$=t;
}
|
term '/' div {
    char *t=newtemp();
    printf("%s = %s / %s\n",t,$1,$3);
    $$=t;
}
|
div {
    $$=$1;
}
;
div : div '^' factor {
    char *t=newtemp();
    printf("%s = %s ^ %s\n",t,$1,$3);
    $$=t;
}
|
factor {
    $$=$1;
}
;

factor : ID {
    $$=$1;
}
|
NUMBER {
    $$=$1;
}
|
'(' expr ')' {
    $$=$2;
}
;

%%

int yyerror(char *s){
    fprintf(stderr,"Syntax error %s\n",s);
    return 0;
}

int main(){
    return yyparse();
}
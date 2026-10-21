%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    int yylex(void);
    int yyerror(char *s);

    int temp=1, label=0;
    int start, body, end;
    
    char *newtemp(){
        char *s = malloc(20);
        sprintf(s,"t%d",temp++);
        return s;
    }
%}

%union {
    char *str;
}
%token WHILE
%token <str> ID NUM
%type <str> expr term factor

%left '+' '-'
%left '*' '/'
%start program

%%
program: stmt;
stmt: WHILE { 
    start = ++label;
    body = ++label;
    end = ++label;
    printf("L%d:\n",start);
    } 
    '(' expr '<' expr ')' {
        printf("if %s < %s goto L%d\n",$4, $6, body);
        printf("goto L%d\n",end);
        printf("L%d:\n",body);
    } 
    '{' statements '}' {
        printf("goto L%d\n",start);
        printf("L%d\n",end);
    }
    ;

statements : statements assignment | assignment ;

assignment: ID '=' expr ';' {
    printf("%s = %s\n",$1,$3);
};

expr: expr '+' term {
    char *t = newtemp();
    printf("%s = %s + %s\n",t,$1,$3);
    $$=t;
    }
    | term {
        $$=$1;
    }
    ;

term: term '*' factor {
    char *t = newtemp();
    printf("%s = %s * %s\n",t,$1,$3);
    $$=t;
    } 
    | factor {
        $$ = $1;
    }
    ;

factor: ID {
    $$=$1;
    }
    | NUM {
        $$=$1;
    }
    | '(' expr ')' {
        $$ = $2;
    }
    ;

%%
int yyerror(char *s){
    printf("Error");
    return 0;
}

int main(){
    yyparse();
    return 0;
}
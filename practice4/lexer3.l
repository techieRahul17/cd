%{
    #include <stdio.h>
    #include <string.h>
    #include "parser3.tab.h"
%}

%option noyywrap

%%
"if" {return IF;}
"else" {return ELSE;}
[A-Za-z_][a-zA-Z0-9_]* {
    yylval.str = strdup(yytext);
    return ID;
}
[0-9]+ {
    yylval.str = strdup(yytext);
    return NUM;
}
[=+*<>] {return yytext[0];}
[(){};] {return yytext[0];}
[ \t\n\r] ;

%%

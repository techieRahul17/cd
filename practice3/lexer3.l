%{
    #include <stdio.h>
    #include <string.h>
    #include "parser3.tab.h"
%}

%option noyywrap

%%
"while" { return WHILE ;}
[a-zA-Z_][a-zA-Z0-9_]* {
    yylval.str = strdup(yytext);
    return ID;
}
[0-9]+ {
    yylval.str = strdup(yytext);
    return NUM;
}
[=+*/<>] {return yytext[0];}
[(){};] {return yytext[0];}
[ \t\n\r]+ ;
. {return yytext[0];}

%%
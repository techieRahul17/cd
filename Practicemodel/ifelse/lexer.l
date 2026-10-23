%option noyywrap
%{
#include "parser.tab.h"
#include <stdlib.h>
#include <string.h>
%}
%%
"int"       { return INT; }
"if"        { return IF; }
"else"      { return ELSE; }
"while"     { return WHILE; }
"for"       { return FOR; }
"and"       { return AND; }
"or"        { return OR; }
"<="|">="|"=="|"!="|"<"|">" { yylval.str=strdup(yytext); return RELOP; }
[A-Za-z_][A-Za-z0-9_]* { yylval.str=strdup(yytext); return ID; }
[0-9]+      { yylval.str=strdup(yytext); return NUMBER; }
[ \t\r\n]+  ;
[=,;(){}+\-*/] {return yytext[0];}
.           { return yytext[0]; }
%%

%option yylineno noyywrap
%x COMMENT STRING
%{
#include<stdio.h>
#include<string.h>

struct Symbol{
    char name[50];
    char type[20];
    int bytes;
    int address;
    char value[50];
};

struct Symbol table[100];
int next_address=1000;
int symbol_count=0;
int in_declaration=0;
int current_bytes=0;
char current_type[20]="";
int last_symbol=-1;
int expect_decl_identifier=0;
int expect_value=0;
int comment_start_line=0;
int string_start_line=0;

int findsymbol(const char *name){
    for(int i=0;i<symbol_count;i++){
        if(strcmp(table[i].name,name)==0)
            return i;
    }
    return -1;
}

int addsymbol(const char *name){
    int index=findsymbol(name);
    if(index!=-1)
        return index;

    if(symbol_count>=100){
        printf("Error: Symbol table is full\n");
        return -1;
    }

    index=symbol_count++;
    snprintf(table[index].name,sizeof(table[index].name),"%s",name);
    snprintf(table[index].type,sizeof(table[index].type),"%s",current_type);
    table[index].bytes=current_bytes;
    table[index].address=next_address;
    snprintf(table[index].value,sizeof(table[index].value),"-");
    next_address+=current_bytes;

    return index;
}

void display_table(void){
    printf("\n\nSYMBOL TABLE\n");
    printf("%-15s %-10s %-8s %-10s %-15s\n",
           "Name","Type","Bytes","Address","Value");

    printf("------------------------------------------------------------\n");

    for(int i=0;i<symbol_count;i++){
        printf("%-15s %-10s %-8d %-10d %-15s\n",
               table[i].name,
               table[i].type,
               table[i].bytes,
               table[i].address,
               table[i].value);
    }

    if(symbol_count==0)
        printf("No symbols found.\n");
}

%}
%%
"//"[^\n]* ;

"/*" {
    comment_start_line=yylineno;
    BEGIN(COMMENT);
}

<COMMENT>"*/" { BEGIN(INITIAL); }
<COMMENT>[^*\n]+ ;
<COMMENT>"*" ;
<COMMENT>\n ;

<COMMENT><<EOF>> {
    printf("Error: Unterminated comment starting at line %d\n",comment_start_line);
    return 0;
}

\"([^\\\n\"]|\\.)*\" {
    if(expect_value && last_symbol!=-1){
        snprintf(table[last_symbol].value,sizeof(table[last_symbol].value),"%s",yytext);
        expect_value=0;
    }
    printf("%s - string constant\n",yytext);
}

\'([^\\\n\']|\\.)\' {
    if(expect_value && last_symbol!=-1){
        snprintf(table[last_symbol].value,sizeof(table[last_symbol].value),"%s",yytext);
        expect_value=0;
    }
    printf("%s - character constant\n",yytext);
}

\" {
    string_start_line=yylineno;
    BEGIN(STRING);
}

<STRING>\\[^\n] ;
<STRING>[^\\\"\n]+ ;

<STRING>\" {
    printf("Error: Unterminated string starting at line %d\n",string_start_line);
    BEGIN(INITIAL);
}

<STRING>\n {
    printf("Error: Unterminated string starting at line %d\n",string_start_line);
    BEGIN(INITIAL);
}

<STRING><<EOF>> {
    printf("Error: Unterminated string starting at line %d\n",string_start_line);
    return 0;
}

#[^\n]* {
    printf("%s - preprocessor directive\n",yytext);
}

"auto"|"break"|"case"|"char"|"const"|"continue"|"default"|"do"|"double"|"else"|"enum"|"extern"|"float"|"for"|"goto"|"if"|"int"|"long"|"register"|"return"|"short"|"signed"|"sizeof"|"static"|"struct"|"switch"|"typedef"|"union"|"unsigned"|"void"|"volatile"|"while" {
    printf("%s - keyword\n",yytext);

    if(strcmp(yytext,"int")==0){
        strcpy(current_type,"int");
        current_bytes=2;
    }
    else if(strcmp(yytext,"char")==0){
        strcpy(current_type,"char");
        current_bytes=1;
    }
    else if(strcmp(yytext,"float")==0){
        strcpy(current_type,"float");
        current_bytes=4;
    }
    else if(strcmp(yytext,"double")==0){
        strcpy(current_type,"double");
        current_bytes=8;
    }
    else if(strcmp(yytext,"long")==0){
        strcpy(current_type,"long");
        current_bytes=4;
    }
    else if(strcmp(yytext,"short")==0){
        strcpy(current_type,"short");
        current_bytes=2;
    }

    if(current_bytes>0 &&
       (strcmp(yytext,"int")==0 ||
        strcmp(yytext,"char")==0 ||
        strcmp(yytext,"float")==0 ||
        strcmp(yytext,"double")==0 ||
        strcmp(yytext,"long")==0 ||
        strcmp(yytext,"short")==0)){
        in_declaration=1;
        expect_decl_identifier=1;
    }
}

("printf"|"scanf"|"getch"|"clrscr")[ \t]*\([^()\n]*\) {
    printf("%s - function call\n",yytext);
}

0[xX][0-9A-Fa-f]+ {
    if(expect_value && last_symbol!=-1){
        snprintf(table[last_symbol].value,sizeof(table[last_symbol].value),"%s",yytext);
        expect_value=0;
    }
    printf("%s - hexadecimal integer constant\n",yytext);
}

[0-9]+[A-Za-z_][A-Za-z0-9_]* {
    printf("Error: Invalid numeric token %s\n",yytext);
}

[0-9]+\.[0-9]*|\.[0-9]+ {
    if(expect_value && last_symbol!=-1){
        snprintf(table[last_symbol].value,sizeof(table[last_symbol].value),"%s",yytext);
        expect_value=0;
    }
    printf("%s - floating constant\n",yytext);
}

[0-9]+ {
    if(expect_value && last_symbol!=-1){
        snprintf(table[last_symbol].value,sizeof(table[last_symbol].value),"%s",yytext);
        expect_value=0;
    }
    printf("%s - integer constant\n",yytext);
}

"++"|"--" {
    printf("%s - unary operator\n",yytext);
}

"+="|"-="|"*="|"/="|"%=" {
    printf("%s - arithmetic assignment operator\n",yytext);
}

"=="|"<="|">="|"!=" {
    printf("%s - relational operator\n",yytext);
}

"&&"|"||" {
    printf("%s - logical operator\n",yytext);
}

"<<"|">>" {
    printf("%s - bitwise shift operator\n",yytext);
}

"=" {
    expect_value=1;
    printf("%s - assignment operator\n",yytext);
}

"<"|">" {
    printf("%s - relational operator\n",yytext);
}

[+\-*/%] {
    printf("%s - arithmetic operator\n",yytext);
}

[&|^] {
    printf("%s - bitwise operator\n",yytext);
}

"!" {
    printf("%s - logical operator\n",yytext);
}

";" {
    printf("%s - special character\n",yytext);
    in_declaration=0;
    expect_decl_identifier=0;
    expect_value=0;
    last_symbol=-1;
}

"," {
    printf("%s - special character\n",yytext);
    if(in_declaration)
        expect_decl_identifier=1;
    expect_value=0;
}

"("|")"|"{"|"}"|"["|"]"|"." {
    printf("%s - special character\n",yytext);
}

[A-Za-z_][A-Za-z0-9_]* {
    if(in_declaration && expect_decl_identifier){
        last_symbol=addsymbol(yytext);
        expect_decl_identifier=0;
        printf("%s - identifier\n",yytext);
    }
    else{
        last_symbol=findsymbol(yytext);
        printf("%s - identifier\n",yytext);
    }
}

[ \t\r\n]+ ;

. {
    printf("Unknown character: %s\n",yytext);
}
%%

int main(void){
    yylex();
    display_table();
    return 0;
}

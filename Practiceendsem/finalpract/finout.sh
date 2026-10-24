#!/bin/sh
flex lexer.l
bison -d parser.y
gcc parser.tab.c lex.yy.c -o icg
./icg <input.txt> tac.txt
gcc optimizer.c -o o
./o <tac.txt> opt.txt
gcc codegen.c -o g
./g <opt.txt> gen.txt
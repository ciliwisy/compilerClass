%{
#include "parser.tab.h"
#include <string.h>
#include <stdlib.h>
%}
 
%%
 
[0-9]+        { yylval.intVal = atoi(yytext); return NUMBER; }
[a-zA-Z][a-zA-Z0-9]* { yylval.strVal = strdup(yytext); return IDENTIFIER; }  // 变量
"\n"      { return EOL; }
[ \t]   { /* 忽略空白字符 */ }
"+"          { return PLUS; }
"-"          { return MINUS; }
"*"          { return MULTIPLY; }
"/"          { return DIVIDE; }
"("          { return LPAREN; }
")"          { return RPAREN; }
"="          { return ASSIGN; }
.            { fprintf(stderr, "lexical error at line %d: unexpected character '%s'\n", yylineno, yytext); return yytext[0]; }
 
%%
 
int yywrap()
{
    return 1;
}
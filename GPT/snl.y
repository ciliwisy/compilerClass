%{
#include <stdio.h>
#include <stdlib.h>
#include "string.h"

// 显式定义 YYSTYPE 为 char* 类型
typedef char* YYSTYPE; 

extern YYSTYPE yylval;  // 与 Flex 中的 yylval 一致
extern int yylex(void);
void yyerror(const char *s);
%}

%token PROGRAM PROCEDURE TYPE VAR IF THEN ELSE FI WHILE DO ENDWH BEGIN1 END1 READ WRITE ARRAY OF RECORD RETURN1
%token INTEGER CHAR1 ID INTC CHARC ASSIGN EQ LT PLUS MINUS TIMES OVER LPAREN RPAREN DOT COLON SEMI COMMA LMIDPAREN RMIDPAREN UNDERANGE
%left PLUS MINUS
%left TIMES OVER
%right ASSIGN

%%

program:
    PROGRAM ID SEMI declarations compound_stmt
    ;

declarations:
    declaration_list
    ;

declaration_list:
    declaration
    | declaration_list declaration
    ;

declaration:
    VAR var_declarations
    | TYPE type_declarations
    ;

var_declarations:
    var_declaration SEMI
    | var_declarations var_declaration SEMI
    ;

var_declaration:
    ID COLON type
    ;

type_declarations:
    type_declaration SEMI
    | type_declarations type_declaration SEMI
    ;

type_declaration:
    ID COLON type
    ;

type:
    INTEGER
    | CHAR1
    ;

compound_stmt:
    BEGIN1 statement_list END1
    ;

statement_list:
    statement
    | statement_list statement
    ;

statement:
    assignment_stmt
    | if_stmt
    | while_stmt
    | read_stmt
    | write_stmt
    ;

assignment_stmt:
    ID ASSIGN expression SEMI
    ;

if_stmt:
    IF condition THEN statement ELSE statement FI
    ;

while_stmt:
    WHILE condition DO statement ENDWH
    ;

read_stmt:
    READ LPAREN ID RPAREN SEMI
    ;

write_stmt:
    WRITE LPAREN expression RPAREN SEMI
    ;

condition:
    expression LT expression
    ;

expression:
    term
    | expression PLUS term
    | expression MINUS term
    ;

term:
    factor
    | term TIMES factor
    | term OVER factor
    ;

factor:
    ID
    | INTC
    | CHARC
    | LPAREN expression RPAREN
    ;

%%

void yyerror(const char *s)
{
    fprintf(stderr, "Syntax error: %s\n", s);
}

int main(void)
{
    printf("Enter the source code:\n");
    yyparse();
    return 0;
}

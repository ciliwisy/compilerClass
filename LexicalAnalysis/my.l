%option noyywrap
%{
#include "string.h"
#include "stdio.h"

typedef enum
{
ENDFILE, ERROR,
PROGRAM,PROCEDURE,TYPE,VAR,IF,THEN, ELSE,FI,WHILE,DO,ENDWH,BEGIN1,END1,READ,
WRITE,ARRAY,OF,RECORD,RETURN1,
INTEGER, CHAR1,
ID, INTC, CHARC,
ASSIGN,EQ,LT,PLUS,MINUS,TIMES,OVER,LPAREN,RPAREN,DOT,COLON,SEMI,COMMA,LMIDPAREN,
RMIDPAREN,UNDERANGE
} LexType;

#define MAXRESERVED 21
static struct
	{char* str;
	LexType tok;
	} reservedWords[MAXRESERVED]
	={ {"program",PROGRAM}, {"type",TYPE}, {"var",VAR},
	{"procedure",PROCEDURE}, {"begin",BEGIN1}, {"end",END1},
	{"array",ARRAY}, {"of",OF}, {"record",RECORD}, {"if",IF}, {"then",THEN},
	{"else",ELSE}, {"fi",FI}, {"while",WHILE}, {"do",DO}, {"endwh",ENDWH},
	{"read",READ}, {"write",WRITE}, {"return",RETURN1},
	{"integer",INTEGER}, {"char",CHAR1} };

LexType reservedLookup(char *s)
{
    int i;  // 变量声明移到循环外
    for(i = 0; i < MAXRESERVED; i++) {
        if(strcmp(reservedWords[i].str, s) == 0)
            return reservedWords[i].tok;
    }
    return ID;  // 如果不是保留字，返回ID类型
}

char yylval[20];
int flag=0;
%}
%option yylineno

%%
[0-9]+ if (flag == 0) {yylval[0] = '\0';strcpy(yylval,yytext);return INTC;}

[a-z][a-z0-9]* if (flag == 0) {yylval[0] = '\0';strcpy(yylval,yytext);return (reservedLookup(yytext));}

'[a-z,0-9]' if (flag == 0) {yylval[0] = '\0';strcpy(yylval,yytext);return CHARC;} 
"+" if (flag == 0) return PLUS;
"-" if (flag == 0) return MINUS;
"*" if (flag == 0) return TIMES;
"/" if (flag == 0) return OVER;
"(" if (flag == 0) return LPAREN;
")" if (flag == 0) return RPAREN;
"." if (flag == 0) return DOT;
"[" if (flag == 0) return LMIDPAREN;
"]" if (flag == 0) return RMIDPAREN;
"," if (flag == 0) return COMMA;
";" if (flag == 0) return SEMI;
":" if (flag == 0) return COLON;
"<" if (flag == 0) return LT;
"=" if (flag == 0) return EQ;
":=" if (flag == 0) return ASSIGN;
".." if (flag == 0) return UNDERANGE;
"EOF" if (flag == 0) return ENDFILE;
"{" flag = 1;
"}" flag = 0;
[ \t\n] ;
. if (flag == 0) {yylval[0] = '\0';strcpy(yylval,yytext);return ERROR;}
%%

void printToken(int token)
{
    switch(token) {
        case ID: printf("ID, %s\n", yylval); break;
        case INTC: printf("NUM, %s\n", yylval); break;
        case CHARC: printf("CHAR, %s\n", yylval); break;
        case PROGRAM: printf("PROGRAM\n"); break;
        case PROCEDURE: printf("PROCEDURE\n"); break;
        case TYPE: printf("TYPE\n"); break;
        case VAR: printf("VAR\n"); break;
        case IF: printf("IF\n"); break;
        case THEN: printf("THEN\n"); break;
        case ELSE: printf("ELSE\n"); break;
        case FI: printf("FI\n"); break;
        case WHILE: printf("WHILE\n"); break;
        case DO: printf("DO\n"); break;
        case ENDWH: printf("ENDWH\n"); break;
        case BEGIN1: printf("BEGIN\n"); break;
        case END1: printf("END\n"); break;
        case READ: printf("READ\n"); break;
        case WRITE: printf("WRITE\n"); break;
        case ARRAY: printf("ARRAY\n"); break;
        case OF: printf("OF\n"); break;
        case RECORD: printf("RECORD\n"); break;
        case RETURN1: printf("RETURN\n"); break;
        case INTEGER: printf("INTEGER\n"); break;
        case CHAR1: printf("CHAR\n"); break;
        case ASSIGN: printf(":=\n"); break;
        case EQ: printf("=\n"); break;
        case LT: printf("<\n"); break;
        case PLUS: printf("+\n"); break;
        case MINUS: printf("-\n"); break;
        case TIMES: printf("*\n"); break;
        case OVER: printf("/\n"); break;
        case LPAREN: printf("(\n"); break;
        case RPAREN: printf(")\n"); break;
        case DOT: printf(".\n"); break;
        case COLON: printf(":\n"); break;
        case SEMI: printf(";\n"); break;
        case COMMA: printf(",\n"); break;
        case LMIDPAREN: printf("[\n"); break;
        case RMIDPAREN: printf("]\n"); break;
        case UNDERANGE: printf("..\n"); break;
        case ERROR: printf("ERROR: %s\n", yylval); break;
        default: printf("UNKNOWN TOKEN: %d\n", token);
    }
}

int main()
{
    int n=1;
    while(n){
	n=yylex();
	printToken(n);
    }
   return 0;
}


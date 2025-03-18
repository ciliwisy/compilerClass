%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
 
// 符号表：存储变量名和值
#define MAX_VARS 100
typedef struct {
    char *name;
    int value;
} Variable;
 
Variable symbol_table[MAX_VARS];
int symbol_count = 0;
 
void set_variable_value(const char *name, int value) {
    // 检查符号表中是否已有该变量
    for (int i = 0; i < symbol_count; i++) {
        if (strcmp(symbol_table[i].name, name) == 0) {
            symbol_table[i].value = value;
            return;
        }
    }
    // 如果没有，插入新变量
    symbol_table[symbol_count].name = strdup(name);
    symbol_table[symbol_count].value = value;
    symbol_count++;
}
 
int get_variable_value(const char *name) {
    // 查找变量值
    for (int i = 0; i < symbol_count; i++) {
        if (strcmp(symbol_table[i].name, name) == 0) {
            return symbol_table[i].value;
        }
    }
    // 如果未找到变量，报错并退出
    printf("Error: Undefined variable %s\n", name);
    exit(1);
}
 
void yyerror(const char *s) {
    fprintf(stderr, "error: %s\n", s);
}
 
int yylex(void);
 
// 定义抽象语法树节点
typedef enum {
    NODE_NUMBER,
    NODE_IDENTIFIER,
    NODE_PLUS,
    NODE_MINUS,
    NODE_MULTIPLY,
    NODE_DIVIDE,
    NODE_ASSIGN,
    NODE_PAREN
} NodeType;
 
typedef struct ASTNode {
    NodeType type;
    int value; // 用于存储数字
    char *name; // 用于存储变量名
    struct ASTNode *left;
    struct ASTNode *right;
} ASTNode;
 
ASTNode* createNode(NodeType type, int value, char *name, ASTNode *left, ASTNode *right) {
    ASTNode *node = (ASTNode*)malloc(sizeof(ASTNode));
    node->type = type;
    node->value = value;
    node->name = name;
    node->left = left;
    node->right = right;
    return node;
}
 
int evaluateNode(ASTNode *node) {
    if (node == NULL) return 0;
    switch (node->type) {
        case NODE_NUMBER:
            return node->value;
        case NODE_IDENTIFIER:
            return get_variable_value(node->name);
        case NODE_PLUS:
            return evaluateNode(node->left) + evaluateNode(node->right);
        case NODE_MINUS:
            return evaluateNode(node->left) - evaluateNode(node->right);
        case NODE_MULTIPLY:
            return evaluateNode(node->left) * evaluateNode(node->right);
        case NODE_DIVIDE:
            return evaluateNode(node->left) / evaluateNode(node->right);
        case NODE_ASSIGN:
            return node->right->value;
        case NODE_PAREN:
            return evaluateNode(node->left);
        default:
            return 0;
    }
}
 
void printAST(ASTNode *node, int level) {
    if (node == NULL) return;
    for (int i = 0; i < level; i++) printf("  ");
    switch (node->type) {
        case NODE_NUMBER:
            printf("Number: %d\n", node->value);
            break;
        case NODE_IDENTIFIER:
            printf("Identifier: %s\n", node->name);
            break;
        case NODE_PLUS:
            printf("Plus\n");
            break;
        case NODE_MINUS:
            printf("Minus\n");
            break;
        case NODE_MULTIPLY:
            printf("Multiply\n");
            break;
        case NODE_DIVIDE:
            printf("Divide\n");
            break;
        case NODE_ASSIGN:
            printf("Assign\n");
            break;
        case NODE_PAREN:
            printf("Paren\n");
            break;
    }
    printAST(node->left, level + 1);
    printAST(node->right, level + 1);
}
 
void printSymbolTable() {
    printf("Symbol Table:\n");
    for (int i = 0; i < symbol_count; i++) {
        printf("%s = %d\n", symbol_table[i].name, symbol_table[i].value);
    }
}
 
%}
 
%union {
    int intVal;
    char *strVal;
    struct ASTNode *astNode;
}
 
%token <intVal> NUMBER
%token <strVal> IDENTIFIER
%token PLUS MINUS MULTIPLY DIVIDE 
%token LPAREN RPAREN EOL ASSIGN
%type <astNode> exp term factor program
 
%right ASSIGN
%left PLUS MINUS
%left MULTIPLY DIVIDE
%nonassoc EOL
 
%%
 
program:
      exp EOL { 
          $$ = $1; 
          $$->value = evaluateNode($1); 
          printf("Result: %d\n", $$->value); 
          printAST($1, 0); 
      }
    | program exp EOL { 
          $$ = $2; 
          $$->value = evaluateNode($2); 
          printf("Result: %d\n", $$->value); 
          printAST($2, 0); 
      }
    ;
 
exp     : term { $$ = $1; $$->value = evaluateNode($1); }
        | exp PLUS term { 
            $$ = createNode(NODE_PLUS, 0, NULL, $1, $3); 
            $$->value = evaluateNode($1) + evaluateNode($3); 
        }
        | exp MINUS term { 
            $$ = createNode(NODE_MINUS, 0, NULL, $1, $3); 
            $$->value = evaluateNode($1) - evaluateNode($3); 
        }
        | IDENTIFIER ASSIGN exp {
            set_variable_value($1, evaluateNode($3)); 
            $$ = createNode(NODE_ASSIGN, 0, strdup($1), NULL, $3);
            $$->value = $3->value;
        }
        ;
 
term    : factor { $$ = $1; $$->value = evaluateNode($1); }
        | term MULTIPLY factor { 
            $$ = createNode(NODE_MULTIPLY, 0, NULL, $1, $3); 
            $$->value = evaluateNode($1) * evaluateNode($3); 
        }
        | term DIVIDE factor { 
            $$ = createNode(NODE_DIVIDE, 0, NULL, $1, $3); 
            $$->value = evaluateNode($1) / evaluateNode($3); 
        }
        ;
 
factor  : NUMBER { $$ = createNode(NODE_NUMBER, $1, NULL, NULL, NULL); }
        | IDENTIFIER { 
            $$ = createNode(NODE_IDENTIFIER, get_variable_value($1), strdup($1), NULL, NULL); 
        }
        | LPAREN exp RPAREN { 
            $$ = createNode(NODE_PAREN, 0, NULL, $2, NULL); 
            $$->value = evaluateNode($2); 
        }
        ;
 
%%
 
int main() {
    printf("Enter expression: \n");
    yyparse();
    printSymbolTable();
    return 0;
}
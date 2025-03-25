/* A Bison parser, made by GNU Bison 3.0.4.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015 Free Software Foundation, Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

#ifndef YY_YY_SNL_TAB_H_INCLUDED
# define YY_YY_SNL_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    PROGRAM = 258,
    PROCEDURE = 259,
    TYPE = 260,
    VAR = 261,
    IF = 262,
    THEN = 263,
    ELSE = 264,
    FI = 265,
    WHILE = 266,
    DO = 267,
    ENDWH = 268,
    BEGIN1 = 269,
    END1 = 270,
    READ = 271,
    WRITE = 272,
    ARRAY = 273,
    OF = 274,
    RECORD = 275,
    RETURN1 = 276,
    INTEGER = 277,
    CHAR1 = 278,
    ID = 279,
    INTC = 280,
    CHARC = 281,
    ASSIGN = 282,
    EQ = 283,
    LT = 284,
    PLUS = 285,
    MINUS = 286,
    TIMES = 287,
    OVER = 288,
    LPAREN = 289,
    RPAREN = 290,
    DOT = 291,
    COLON = 292,
    SEMI = 293,
    COMMA = 294,
    LMIDPAREN = 295,
    RMIDPAREN = 296,
    UNDERANGE = 297
  };
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef int YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_SNL_TAB_H_INCLUDED  */

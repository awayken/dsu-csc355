/****************************************************/
/* File: assignment2.l                              */
/* CSC355 - Tom Halverson                           */
/*                                                  */
/* Miles C. Rausch                                  */
/****************************************************/

%{
#include <stdlib.h>
#include <stdarg.h>
#include <stdio.h>
#include <string.h>

int MAXTOKENLEN = 0;
int intKeyword = 0;
int intNumber = 0;
int intOperator = 0;
int intIdentifier = 0;

char tokenString[MAXTOKENLEN+1];

TokenType getToken(void)
%}

integer		[0-9]+
floating	[0-9]+[.[0-9][0-9]?]
identifier	[a-z]+[[A-Z]+[a-z]*[0-9]+]*

%%

"for"			{intKeyword++; yytext = "for";}
"while"			{intKeyword++; yytext = "while";}
"if"            {intKeyword++; yytext = "if";}
"then"          {intKeyword++; yytext = "then";}
"else"          {intKeyword++; yytext = "else";}
"begin"			{intKeyword++; yytext = "begin";}
"format"		{intKeyword++; yytext = "format";}

"=="            {intOperator++; yytext = "==";}
"="             {intOperator++; yytext = "=";}
"<"             {intOperator++; yytext = "<";}
"<="			{intOperator++; yytext = "<=";}
"+"             {intOperator++; yytext = "+";}
"-"             {intOperator++; yytext = "-";}
"*"             {intOperator++; yytext = "*";}

{integer}       {intNumber++; yytext = "int";}
{floating}		{intNumber++; yytext = "float";}
{identifier}	{intIdentifier++; yytext = "id";}

.               {getToken();}

%%

int main()
{
return 0;
}

TokenType getToken(void)
{
  static int firstTime = TRUE;
  TokenType currentToken;
  if (firstTime)
  {
    firstTime = FALSE;
    lineno++;
    yyin = source;
    yyout = listing;
  }
  currentToken = yylex();
  strncpy(tokenString,yytext,MAXTOKENLEN);
  if (TraceScan) {
    fprintf(listing,"\t%d: ",lineno);
    printToken(currentToken,tokenString);
  }
  
  printf("Keywords: %d", intKeywords);
  printf("Numbers: %d", intNumbers);
  printf("Operators: %d", intOperators);
  printf("Identifiers: %d", intIdentifiers);
  
  return currentToken;
}

int yywrap()
{
return 0;
}

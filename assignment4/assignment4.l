/****************************************************/
/* File: assignment4.l                              */
/* CSC355 - Tom Halverson                           */
/*                                                  */
/* Miles C. Rausch                                  */
/****************************************************/

%{
int intKeyword = 0;
int intNumber = 0;
int intOperator = 0;
int intIdentifier = 0;
%}

integer		[0-9]+
floating	[0-9]+[.[0-9][0-9]?]
identifier	[a-z]+|[a-z]*[A-Z]+[0-9]+

%%

"for"			{intKeyword++; printf("FOR \n");}
"while"			{intKeyword++; printf("WHILE \n");}
"if"            {intKeyword++; printf("IF \n");}
"then"          {intKeyword++; printf("THEN \n");}
"else"          {intKeyword++; printf("ELSE \n");}
"begin"			{intKeyword++; printf("BEGIN \n");}
"format"		{intKeyword++; printf("FORMAT \n");}

"=="            {intOperator++; printf("IS \n");}
"="             {intOperator++; printf("EQ \n");}
"<"             {intOperator++; printf("LT \n");}
"<="			{intOperator++; printf("LTE \n");}
"+"             {intOperator++; printf("ADD \n");}
"-"             {intOperator++; printf("SUB \n");}
"*"             {intOperator++; printf("MULT \n");}

{integer}       {intNumber++; printf("INT \n");}
{floating}		{intNumber++; printf("FLOAT \n");}
{identifier}	{intIdentifier++; printf("ID \n");}

.               {printf("ERROR");}

%%

TokenType getToken(void)
{
	TokenType currentToken;	
	currentToken = yylex();
	
	strncpy(tokenString,yytext,200);

		printf("Keywords: %d", intKeywords);
		printf("Numbers: %d", intNumbers);
		printf("Operators: %d", intOperators);
		printf("Identifiers: %d", intIdentifiers);
		printToken(currentToken,tokenString);
 
	return currentToken;
}
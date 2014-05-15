%{
/**********************
 **  xrml.l          **
 **  By John Larson  **
 **********************/

#include "y.tab.h"
%}

[0-9]+		yylval.iValue = atoi(yytext);return INTEGER;
[0-9]+"."[0-9]+	yylval.fValue = atof(yytext);return REAL;
[a-zA-Z]+	yylval.sValue = *yytext;return STRING;
[a-zA-Z]	yylval.sIndex = *yytext;return CHAR;
[-+/*&\n]	return *yytext;


position	{integer}","{integer}
underscore	[_]
identifier	{letter}+{{integer}|{underscore}|{letter}}*
property	{underscore}{letter}+
newline		\n
whitespace	[ \t]+
concate		[..]

%%


[a-zA-Z]+[0-9]+|"_"|[a-zA-Z]+*	{return IDENTIFIER;}
{integer}+","{integer}+		{return POSITION;}
"IS"		{return IS;}
"#"		{return COM;}
"repeat"	{return RPT;}
"robot"		{return RBT;}
"newline"	{lineno++;}
"whitespace"	{/* skip whitespace */}

%%

int main(void)
{
	return 0;	
}
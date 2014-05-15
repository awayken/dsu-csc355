%{
#include <stdio.h>

int count(char type);

int keys = 0;
int nums = 0;
int ops = 0;
int ids = 0;
%}

digit       [0-9]
integer     {digit}+
real        {digit}+"."[{digit}|{digit}{digit}]
identifier  [a-zA-Z]+
whitespace  [ \t\n]+

%%

"for"           {count('k'); return FOR;}
"if"            {count('k'); return IF;}
"then"          {count('k'); return THEN;}
"else"          {count('k'); return ELSE;}
"begin"         {count('k'); return BEGIN;}
"end"           {count('k'); return END;}
"format"        {count('k'); return FORMAT;}
"while"         {count('k'); return WHILE;}

"="             {count('o'); return ASSIGN;}
"=="            {count('o'); return EQ;}
"<"             {count('o'); return LT;}
"<="            {count('o'); return LET;}
"+"             {count('o'); return PLUS;}
"-"             {count('o'); return MINUS;}
"*"             {count('o'); return TIMES;}

{integer}       {count('n'); return INT;}
{real}          {count('n'); return FLOAT;}

{identifier}    {count('i'); return ID;}

{whitespace}    {/* skip whitespace */}
.               {return ERROR;}

%%

int count(char type)
{
   if (type == 'k')
   {
      keys++;
   } elseif (type == 'o') {
      ops++;
   } elseif (type == 'n') {
      nums++;
   } elseif (type == 'i') {
      ids++;
   }
   return 0;
}

int main()
{

printf("Number of keywords: %d\n", keys);
printf("Number of operators: %d\n", ops);
printf("Number of numbers: %d\n", nums);
printf("Number of identifiers: %d\n", ids);

return 0;
}

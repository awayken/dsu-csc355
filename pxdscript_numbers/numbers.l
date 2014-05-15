/* numbers flex-file
 *
 * History:
 */

%{
#include <string.h>
%}

%%

[ \t]+                /* ignore spaces and tabs*/;


"+"                      {printf("plus\n");}
"-"                      {printf("minus\n");}
"*"                      {printf("mul\n");}
"/"                      {printf("div\n");}
"%"                      {printf("mod\n");}
"("                      {printf("left paran\n");}
")"                      {printf("right paran\n");}

0|([1-9][0-9]*)          {printf("intconst(%i)\n", atoi(yytext));}

[A-Za-z_][A-Za-z0-9_]*   {printf("identifier(%s)\n", yytext);}

.                        /* ignore other chars*/;

%%

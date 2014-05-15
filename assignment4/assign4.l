%{
/* rom.l: Roman numerals, trickier yacc, simpler lex
 * R Dowling 96Oct20
 */

#include "ytab.h"
#include <stdlib.h>
#include <stdarg.h>
#include <stdio.h>
#include <string.h>
void count ();

%}

%%

I			{ count(); yylval = 1; return GLYPH; }
V			{ count(); yylval = 5; return GLYPH; }
X			{ count(); yylval = 10; return GLYPH; }
L			{ count(); yylval = 50; return GLYPH; }
C			{ count(); yylval = 100; return GLYPH; }
D			{ count(); yylval = 500; return GLYPH; }
M			{ count(); yylval = 1000; return GLYPH; }

[ \t\n]			{ count(); return (WHITE); }

.			{ count();
			  yyerror("Unknown character (%c)", *yytext); }

%%
int column = 0;
int line_num = 1;
char error_line_buffer[256];

/* Count makes pretty error messages by counting characters and saving
 * them in a global error_line_buffer.  yyerror() below knows about the
 * buffer and can print out the partial line with the error.
 */
void count()
{
	int i;
	static char *elb=error_line_buffer;

	for (i = 0; yytext[i] != '\0'; i++)
	{
		if (yytext[i] == '\n')
		{
			column = 0;
			line_num++;
			elb = error_line_buffer;
		}
		else
		{
			*elb++ = yytext[i];
			if (yytext[i] == '\t')
				column += 8 - (column & (8-1));
			else
				column++;
		}
		*elb = 0;
	}
}

void yyerror(char *fmt, ...)
{
	/* extern int yylineno; */
	extern int column, line_num;
	extern char error_line_buffer[256];
	va_list va;

	va_start(va, fmt);
	fprintf (stdout, "%s\n", error_line_buffer);
	fprintf (stdout, "\n%*s", column, "^");
	vfprintf(stdout, fmt, va);
	fprintf (stdout, ":Line %d\n", line_num);
	error_code = 26;
}
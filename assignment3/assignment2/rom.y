%{
/* rom.y: Roman numerals, trickier, right-recursive yacc, simpler lex
 * R Dowling 96Oct20
 */
#include "rom.h"
#define	YYTRACE

int last=0;
%}

%token GLYPH WHITE
%start file

%%

file			/* file uses the more efficient left-recursion */
	: number		{ printf ("Got <%d>\n", $1); $$=$1; last=0; }
	| file WHITE number	{ printf ("Got <%d>\n", $3); $$=$3; last=0; }
	;

number			/* number uses right-recursion and a state variable */
	: GLYPH			{ last = $$=$1; }
	| GLYPH number		{ if ($1 >= last)
					$$ = $2 + (last=$1);
				  else
					$$ = $2 - (last=$1);
				}
	;

%%
#include "trace.i"	/* for mks yacc debugger */

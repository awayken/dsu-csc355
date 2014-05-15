/* Parse.c: Taken from C2C.C 10Feb93
 * R Dowling 13Apr94
 */

#include "rom.h"

int error_code = 0;

main (int c, char **v)
{
	/* Initialize */
	yyparse ();
	if (error_code)
		printf ("C2C Error: %d\n", error_code);
	return error_code;
}

/* #include "d:\mks\lib\yywrap.c" */
int yywrap()
{
	return 1;
}

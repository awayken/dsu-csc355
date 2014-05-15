%{
/*********************
 **  xrml.y         **
 **  by Mies Rausch **
 *********************/
 
#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include "xrml.h"                        /* A header file with some key functions, enums, and structs */

nodeType *opr(int oper, int nops, ...);  /* Performs operations on nodes */
nodeType *id(int i);                     /* Adds a node */
nodeType *con(int value);                /* Converts a node */
void freeNode(nodeType *p);
int ex(nodeType *p);                     /* Found in the interpreter */
int yylex(void);

void yyerror(char *s);                   /* Error function in Yacc */
int sym[26];                             /* symbol table only allows for single character variables */
%}

%union {
    int iValue;                 /* integer value */
	float fValue;               /* float value */
	string sValue;              /* string value */
	string rValue;              /* string value for robot */
	string pValue;              /* string value for position */
    char sIndex;                /* symbol table index */
    nodeType *nPtr;             /* node pointer */
};

%token <iValue> INTEGER
%token <fValue> REAL
%token <sValue> STRING
%token <rValue> ROBOT
%token <pValue> POSITION
%token <sIndex> ID
%token WORLD WIDTH HEIGHT COLOR
%token NAME SIZE LOCATION SAYS
%token IS REPEAT PROCEDURE

%left '+' '-' '*' '/' '%'
%type <nPtr> stmt expr stmt_list
%start program

%%

program:
        function                { exit(0); }
        ;

function:
          function stmt         { ex($2); freeNode($2); }
        | /* NULL */
        ;

stmt:
          '\n'                                              { $$ = opr('\n', 2, NULL, NULL); }
        | expr '\n'                                         { $$ = $1; }
        | WORLD WIDTH IS expr '\n'                          { $$ = opr(WIDTH, 2, id($1), $4); }
        | WORLD HEIGHT IS expr '\n'                         { $$ = opr(HEIGHT, 2, id($1), $4); }
        | ROBOT ID IS robt '\n'                             { $$ = opr(IS, 2, id($2), $4); }
        | ROBOT ID SAYS strn '\n'                           { $$ = opr(SAYS, 1, id($2), $4); }
        | INTEGER ID IS expr '\n'                           { $$ = opr(IS, 2, id($2), $4); }
        | REAL ID IS rlnm '\n'                              { $$ = opr(IS, 2, id($2), $4); }
        | STRING ID IS strn '\n'                            { $$ = opr(IS, 2, id($2), $4); }
        | ID NAME IS expr '\n'                              { $$ = opr(NAME, 2, id($1), $4); }
        | ID LOCATION IS expr '\n'                          { $$ = opr(LOCATION, 2, id($1), $4); }
        | ID SIZE IS expr '\n'                              { $$ = opr(SIZE, 2, id($1), $4); }
        | ID COLOR IS strn '\n'                             { $$ = opr(COLOR, 2, id($1), $4); }
        | REPEAT '(' INTEGER ')' stmt                       { $$ = opr(REPEAT, 2, $5); }
		| REPEAT '(' ID ',' INTEGER ',' INTEGER ')' stmt    { $$ = opr(REPEAT, 2, $9); }
        ;
		
robt:
		ROBOT                  { $$ = con($1); }
		;
		
strn:
		STRING                { $$ = con($1); }
		;

rlnm:
		REAL                  { $$ = con($1); }
		;

expr:
          INTEGER               { $$ = con($1); }
        | ID                    { $$ = id($1); }
        | expr '+' expr         { $$ = opr('+', 2, $1, $3); }
        | expr '-' expr         { $$ = opr('-', 2, $1, $3); }
        | expr '*' expr         { $$ = opr('*', 2, $1, $3); }
        | expr '/' expr         { $$ = opr('/', 2, $1, $3); }
        | expr '%' expr         { $$ = opr('%', 2, $1, $3); }
        | '(' expr ')'          { $$ = $2; }
        ;

%%

#define SIZEOF_NODETYPE ((char *)&p->con - (char *)p)

nodeType *con(int value) {
    nodeType *p;
    size_t nodeSize;

    /* allocate node */
    nodeSize = SIZEOF_NODETYPE + sizeof(conNodeType);
    if ((p = malloc(nodeSize)) == NULL)
        yyerror("out of memory");

    /* copy information */
    p->type = typeCon;
    p->con.value = value;

    return p;
}

nodeType *id(int i) {
    nodeType *p;
    size_t nodeSize;

    /* allocate node */
    nodeSize = SIZEOF_NODETYPE + sizeof(idNodeType);
    if ((p = malloc(nodeSize)) == NULL)
        yyerror("out of memory");

    /* copy information */
    p->type = typeId;
    p->id.i = i;

    return p;
}

nodeType *opr(int oper, int nops, ...) {
    va_list ap;
    nodeType *p;
    size_t nodeSize;
    int i;

    /* allocate node */
    nodeSize = SIZEOF_NODETYPE + sizeof(oprNodeType) +
        (nops - 1) * sizeof(nodeType*);
    if ((p = malloc(nodeSize)) == NULL)
        yyerror("out of memory");

    /* copy information */
    p->type = typeOpr;
    p->opr.oper = oper;
    p->opr.nops = nops;
    va_start(ap, nops);
    for (i = 0; i < nops; i++)
        p->opr.op[i] = va_arg(ap, nodeType*);
    va_end(ap);
    return p;
}

void freeNode(nodeType *p) {
    int i;

    if (!p) return;
    if (p->type == typeOpr) {
        for (i = 0; i < p->opr.nops; i++)
            freeNode(p->opr.op[i]);
    }
    free (p);
}

void yyerror(char *s) {
    fprintf(stdout, "%s\n", s);
}

int main(void) {
    yyparse();
    return 0;
}

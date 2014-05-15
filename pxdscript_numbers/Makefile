CC = gcc
CFLAGS = -Wall -pedantic -g

comp:			lex.yy.o 
			$(CC) $(CFLAGS) lex.yy.o -o numbers -lfl


lex.yy.o:		lex.yy.c 
			$(CC) -c $(CFLAGS) lex.yy.c

lex.yy.c:		numbers.l 
			flex numbers.l


clean:
			- rm *.o lex.yy.c numbers.exe  



/*************************************************
Compilers: Exam 3


Obs: Program stop when encounter first error.

***************************************************/

#	include <string.h>
#	include <stdio.h>

#	define MAX 80

int nline = 1;
int traceFlag = 0;

int flag_html = 0;
int flag_body = 0;
int flag_head = 0;

char aux[500];

char stack[MAX][80];

int top = -1;


void prLex(char *lexeme, char *token);
int ProcessSemantics (char type[], char tagName[]);
char *strlwr(char *str);

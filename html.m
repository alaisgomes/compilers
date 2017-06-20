/*************************************************
Compilers: Exam 3

Obs: Program stop when encounter first error.

***************************************************/



int yyerror(const char *s)
    {
    	printf ("\n (line %d) \t Error: \t %s \n ",nline,s);
    return;
    }

int yywrap(void)
{
		return(1);
}


/*
* fLex Parsing function
*/

void prLex(char *lexeme, char *token)
{
	if (traceFlag)
		printf("lexeme: %-20s TOKEN:%s \n", lexeme, token);

	return;
}



/*
* String fuction to make everything lowercase, for comparisons
*/

char *strlwr(char *str)
{
  unsigned char *p = (unsigned char *)str;

  while (*p) {
     *p = tolower(*p);
      p++;
  }

  return str;
}
	


/*
* Stack Operations
*/

int push(char stack[MAX][MAX], int *top, char data[MAX])
{
	if(*top == MAX -1)
		return(-1);
	else
	{
		*top = *top + 1;
		strcpy(stack[*top], data);
		return(1);
	} 
} 

int pop(char stack[MAX][MAX], int *top, char data[MAX])
{
	if(*top == -1)
		return(-1);
	else
	{
		strcpy(data, stack[*top]);
		*top = *top - 1;
		return(1);
	} // else
} // pop





/*
* Semantic Processing
*/



int ProcessSemantics (char type[], char tagName[]) {

	char string[80], string2[80];
	char generic[80];

	strcpy (string, type);

	strcat( string, strlwr(tagName));


	/* Rules for HTML tag */
	if (strcmp(string, "<html") == 0) {

		if (flag_html == 0) {
			flag_html = 1;
			push(stack,  &top, string);
			
		} else {
			printf ("Error\n");
			return 1;	
		}


	} else if (strcmp(string, "</html") == 0) {

		if (flag_html == 1) {

			flag_html = 2;

			if(pop(stack,  &top, string2) != -1) {

				if (strcmp(string2, "<html") != 0) {
					return 1;
				}

			}

		} else {
			printf ("Error\n");
			return 1;
		}
			
	/* Rules for HEAD tag */

	}	else if (strcmp(string, "<head") == 0) {
		if ((flag_html == 1)&&(flag_head == 0)&&(flag_body == 0)){

			flag_head = 1;
			push(stack,  &top, string);

		} else {

			printf ("Error\n");
			return 1;	
		}

	} else if (strcmp(string, "</head") == 0) { 
		if (flag_head == 1){

			flag_head = 2;
			if(pop(stack,  &top, string2) != -1) {

				if (strcmp(string2, "<head") != 0) {
					return 1;
				}

			}

		} else {

			printf ("Error\n");
			return 1;	
		}

	/* Rules for body tag */

	} else if (strcmp(string, "<body") == 0) {

		if ((flag_html == 1)&&(flag_head != 1)&&(flag_body == 0)){

			flag_body = 1;
			push(stack,  &top, string);

		} else {
			printf ("Error\n");
			return 1;	
		}

	} else if (strcmp(string, "</body") == 0) { 
		if ((flag_body == 1)){

			flag_body = 2;
			if(pop(stack,  &top, string2) != -1) {

				if (strcmp(string2, "<body") != 0) {
					return 1;
				}

			}

		} else {
			printf ("Error\n");
			return 1;	
		}


	} else {

		/*Process what is related to normal tags: pus/pop stuff in stack*/
		if (strcmp(type, "<") == 0) {
			push(stack,  &top, string);
		} else if (strcmp(type, "</") == 0) {
			strcpy(generic, "<");
			strcat(generic, tagName);
			if(pop(stack,  &top, string2) != -1) {
				if (strcmp(string2, generic) != 0) {
					return 1;
				}

			}
		}

	}

	return 0;

}



int main(int argc, char **argv)
{
	int argo = 0;

	while (++argo < argc)
	{
		if (strcmp(argv[argo], "-t") == 0)	
			traceFlag = 1;
	}


	do {
		yyparse();
	} while (!feof(yyin));

	return 0;
}

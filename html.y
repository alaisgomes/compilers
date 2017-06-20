/*************************************************
Compilers: Exam 3


Obs: Program stop when encounter first error.

***************************************************/

%{
#include "html.h"


%}


%union {
	char str[500];
}


%start Start


/*
 * Token declaration
 */

%token <str>		T_ERROR
%token <str>		T_OPEN_TAG		
%token <str>		T_OPEN_ENDTAG	
%token <str>		T_TEXT			
%token <str>		T_EQUALS	
%token <str>		T_OPEN_BANGTAG	
%token <str>		T_BANGTAG			
%token <str>		T_CLOSE_TAG		
%token <str>		T_CLOSE_SCTAG		
%token <str>		T_ATTR_VALUE	
%token <str>		T_ATTR_NAME			
%token <str>		T_IDENT			
%token <str>		T_OPEN_COMMENT
%token <str>		T_CLOSE_COMMENT
%token <str>		T_COMMENT
%token <str>		T_CODE
%token <str>		T_CLOSE_PHP
%token <str>		T_OPEN_PHP
%token <str>		T_PHP_CODE


%type <str> tag_name

%%



Start 		: doc 
							{	if (traceFlag) 
									printf("    REDUCING <doc> to <START>\n\n");	}
			;

doc  		: /*  empty  */				
							{	if (traceFlag) 
									printf("    REDUCING <epsilon> to <doc>\n\n"); }
	  		| code doc 					 
	  						{	if (traceFlag) 
	  								printf("    REDUCING <code doc> to <doc>\n");  }
	  		| text doc					 
	  						{	if (traceFlag) 
	  								printf("    REDUCING <text doc> to <doc>\n\n");	}
	  		| comment doc	
	  						{	if (traceFlag) 
	  								printf("    REDUCING <comment doc> to <doc>\n\n"); }
	  		| bangtag doc				
	  						{	if (traceFlag) 
	  								printf("    REDUCING <bangtag doc> to <doc>\n\n");  }
	  		| start_tag doc end_tag doc	 
	  						{	if (traceFlag) 
	  								printf("    REDUCING <start_tag doc end_tag doc> to <doc>\n\n");	}
	  		| sc_tag doc	
	  						{	if (traceFlag) 
	  								printf("    REDUCING <sc_tag doc> to <doc>\n\n");	}			 
	  		| T_ERROR 
	  						{	return 0;	}

	  		| php doc  		{ if (traceFlag) 
	  								printf("    REDUCING <php doc> to <doc>\n\n"); }
	  		
	  		;


start_tag	: T_OPEN_TAG tag_name attr_seq T_CLOSE_TAG 				
							{	
								if (ProcessSemantics($1, $2)) { yyerror("Semantic Error"); return 0; }
								if (traceFlag) 
									printf("    REDUCING <T_OPEN_TAG  tag_name T_CLOSE_TAG> to <start_tag>\n\n");	 }
			;


end_tag		: T_OPEN_ENDTAG tag_name T_CLOSE_TAG 			
							{	
								if (ProcessSemantics($1, $2)) { yyerror("Semantic Error"); return 0; }
								if (traceFlag) 
									printf("    REDUCING <T_OPEN_ENDTAG tag_name T_CLOSE_TAG> to <end_tag> \n\n"); }
			;

sc_tag		: T_OPEN_TAG tag_name attr_seq T_CLOSE_SCTAG 	
							{	if (traceFlag) 
									printf("    REDUCING <T_OPEN_TAG tag_name attr_seq T_CLOSE_SCTAG> to <sc_tag> \n\n"); }
			;

attr_seq	: /*Empty*/		
							{	if (traceFlag) 
									printf("    REDUCING <epsilon> to <attr_seq> \n\n"); }

			| attr attr_seq									
							{	if (traceFlag) 
									printf("    REDUCING <attr attr_seq> to <attr_seq> \n\n"); }		
			;

attr 		: attr_name T_EQUALS T_ATTR_VALUE				
							{	if (traceFlag) 
									printf("    REDUCING <attr_name T_EQUALS T_ATTR_VALUE> to <attr> \n\n"); }
			;

bangtag 	: T_OPEN_BANGTAG T_BANGTAG T_CLOSE_TAG 	
							{	if (traceFlag) 
									printf("    REDUCING <T_OPEN_BANGTAG T_BANGTAG T_CLOSE_TAG> to <bangtag> \n\n"); }
			;

comment 	: T_OPEN_COMMENT T_COMMENT T_CLOSE_COMMENT		
							{	if (traceFlag) 
									printf("    REDUCING <T_OPEN_COMMENT T_COMMENT T_CLOSE_COMMENT> to <comment> \n\n"); }
			;

php 		: T_OPEN_PHP T_PHP_CODE T_CLOSE_PHP 
								{
								if (traceFlag) 
									printf("    REDUCING <T_OPEN_PHP T_PHP_CODE T_CLOSE_PHP> to <php>\n\n");	 }
			;

tag_name 	: T_IDENT 										
							{	
								if (traceFlag) 
									printf("    REDUCING <T_IDENT> to <tag_name> \n\n"); }
			;

attr_name 	: T_IDENT										
							{	if (traceFlag) 
									printf("    REDUCING <T_IDENT> to <attr_name> \n\n"); }
			;

code 		: T_CODE										
							{	if (traceFlag) 
									printf("    REDUCING <T_CODE> to <code> \n\n");}
			;

text 		: T_TEXT 										
							{	if (traceFlag) 
									printf("    REDUCING <T_TEXT> to <text> \n\n"); }
			;






%%

/**** Functions: ******/
#include "lex.yy.c"
#include "html.m"

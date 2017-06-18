
***************************************************


     ABOUT START STATE
*    An HTML program can start with a normal tag, text, comments or bangtag. 
* So for each of them, create a condition that they can also happen with
* an initial state. More info: http://flex.sourceforge.net/manual/Start-Conditions.html
*
*    Note that an html program cannot start with an end tag, so they are not 
* considering the initial state. 
*
*     ABOUT STATES IN GENERAL
*    All rules are separated in groups and you can see that when you get into a
* a tag, for example, you active a IN_TAG state, and when you close the tag, you active
* NOT_IN_TAG state, which will be used to match things that only happens outside 
* tags such as text, comments...
*
*	Anything else will be matched as UNKNOWN so we can be able to parse errors later.


***************************************************/


%{
	
/*
 *  Constant definitions:
 *      these are all found in html.h, which is included via html.y
 */


%}

IDENT			[a-zA-Z0-9_\-]+
WHITESPACE		[ \t\r]+

TEXT 			[^&<>"\n\t\r]+
CODE 			[a-zA-Z0-9_]+
BANGTAG 		[^-<>][^<>]*
COMMENT 		[^-{2}]+ 
ATTR_VALUE 		[^"]+

QUOTES			\"
OPEN_COMMENT	"<!--"
CLOSE_COMMENT 	"-->"
EQUALS			"="
OPEN_TAG		"<"
OPEN_ENDTAG		"</"
CLOSE_SCTAG		"/>"
SEMI_COLON		";"
OPEN_BANGTAG 	"<!"
CLOSE_TAG		">"
AMPERSAND		"&"

OP_PHP			"<?php"
PHP_CODE 		{TEXT}
CLOSE_PHP		"?>"





%s NOT_IN_TAG IN_TAG IN_COMMENT IN_ATTR IN_ATTR_VALUE IN_BANGTAG IN_PHP


%%

{OP_PHP}							{ BEGIN (IN_PHP);
										prLex(yytext, "T_OPEN_PHP");
										strcpy(yylval.str, yytext);
										return T_OPEN_PHP;
									}
<IN_PHP>
	{PHP_CODE}						{ BEGIN (IN_PHP);
										strcpy(yylval.str, yytext);
										prLex(yytext, "T_PHP_CODE");
										return T_PHP_CODE;
									}
<IN_PHP>
	{CLOSE_PHP}						{ BEGIN(NOT_IN_TAG);
										strcpy(yylval.str, yytext);
									 	prLex(yytext, "T_CLOSE_PHP");
										return T_CLOSE_PHP;	
									}


<INITIAL,NOT_IN_TAG>
	{OPEN_TAG}		 				{ 	BEGIN(IN_TAG); 
										strcpy(yylval.str, yytext);
										prLex(yytext, "T_OPEN_TAG"); 
										return  T_OPEN_TAG;
									}

<INITIAL,NOT_IN_TAG>
	{OPEN_COMMENT}					{ BEGIN(IN_COMMENT); 
										strcpy(yylval.str, yytext);
										prLex(yytext, "T_OPEN_COMMENT"); 
										return T_OPEN_COMMENT;
									}

<INITIAL,NOT_IN_TAG>
	{OPEN_BANGTAG} 					{ BEGIN(IN_BANGTAG); 
										strcpy(yylval.str, yytext);
										prLex(yytext, "T_OPEN_BANGTAG"); 
										return T_OPEN_BANGTAG;
									}  

<INITIAL,NOT_IN_TAG>{TEXT}          { 
										prLex(yytext, "T_TEXT");  
										strcpy(yylval.str, yytext);
										return T_TEXT;
									}

<IN_BANGTAG>{BANGTAG} 				{ BEGIN(IN_BANGTAG); 
										
										prLex(yytext, "T_BANGTAG");
										strcpy(yylval.str, yytext); 
										return T_BANGTAG;
									}

<IN_COMMENT>{COMMENT} 				{ 
										prLex(yytext, "T_COMMENT");
										strcpy(yylval.str, yytext);  
										return T_COMMENT;
									}

<IN_COMMENT>{CLOSE_COMMENT} 		{ BEGIN(NOT_IN_TAG); 
										
										prLex(yytext, "T_CLOSE_COMMENT");
										strcpy(yylval.str, yytext); 
										return T_CLOSE_COMMENT;
									}

<IN_TAG>{IDENT}                 	{ BEGIN(IN_ATTR); 
										
										prLex(yytext, "T_IDENT");
										strcpy(yylval.str, yytext);  
										return T_IDENT; 
									}

<IN_ATTR>{IDENT}                 	{  
										prLex(yytext, "T_IDENT");
										strcpy(yylval.str, yytext); 
										return T_IDENT; 
									}

<IN_ATTR>{EQUALS}                 	{ BEGIN (IN_ATTR_VALUE); 
										
										prLex(yytext, "T_EQUALS");
										strcpy(yylval.str, yytext); 
										return T_EQUALS;
									}
<IN_ATTR_VALUE>
	{QUOTES}{ATTR_VALUE}{QUOTES} 	{ BEGIN(IN_ATTR); 
										 
										prLex(yytext, "T_ATTR_VALUE");
										strcpy(yylval.str, yytext);
										return T_ATTR_VALUE; 
									}

{CLOSE_TAG}             			{ BEGIN(NOT_IN_TAG); 
										
										prLex(yytext, "T_CLOSE_TAG");
										strcpy(yylval.str, yytext); 
										return T_CLOSE_TAG; 
									}
{CLOSE_SCTAG}           			{ BEGIN(NOT_IN_TAG); 
										
										prLex(yytext, "T_CLOSE_SCTAG");
										strcpy(yylval.str, yytext); 
										return T_CLOSE_SCTAG; 
									}

<NOT_IN_TAG>{OPEN_ENDTAG}           {	BEGIN(IN_TAG); 
										
										prLex(yytext, "T_OPEN_ENDTAG");
										strcpy(yylval.str, yytext); 
										return T_OPEN_ENDTAG;
									}

{AMPERSAND}{CODE}{SEMI_COLON}		{  
										prLex(yytext, "T_CODE");
										strcpy(yylval.str, yytext);
										return T_CODE; 
									}

{WHITESPACE}            			{ prLex("-------", "(white space)"); 	 } 

[\n]								{ nline++; } 		/*Be able to count lines*/

.									{ prLex("*******", "UNKNOWN"); 
										return T_ERROR;
									}

%%

/*
 * These are all found in html.m 
 */
 

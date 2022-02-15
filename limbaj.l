%{
#include"y.tab.h"
void yyerror(char *);
%}
%option yylineno
%%
"begin"    			    {return BGIN;}
"end"				    {return END;}
"if"                               {return IF;}
"else"                             {return ELSE;}
"endif"                              {return ENDIF;}
"while"                            {return WHILE;}
"string"                           {yylval.sir=strdup(yytext);return DECLRSTRING;}
"char"                             {yylval.sir=strdup(yytext);return DECLRCHAR;}
"int"                              {yylval.sir=strdup(yytext);return DECLRINT;}
"float"                            {yylval.sir=strdup(yytext);return DECLRFLOAT;}
"bool"   		            {yylval.sir=strdup(yytext);return DECLRBOOL;}
";"                              {return SEMIC;}
[0-9]+                           {yylval.valoare=atoi(yytext);return NUMBER;}
[0-9]+[.][0-9]+ 		  {yylval.float_value=atof(yytext);return NUMAR_FLOAT;}
[a-zA-Z][a-zA-Z0-9_]*            {yylval.sir=strdup(yytext);return ID;}
'[a-z0-9A-Z ]' 		  {yylval.sir=strdup(yytext);return CHAR;}
\"[a-z0-9A-Z _;,"'.=? !]+\"	  {yylval.sir=strdup(yytext);return STRING;}
[0-9]+#                          {yylval.bool_value=atoi(yytext);return BOOL;}
[ \t\n]                          {;}
.                                {return yytext[0];}
"=="                             {return EQLTO;}
"!="                             {return NETQLTO;}
"<="                             {return SMALLEREQ;}
">="                             {return BIGGEREQ;}
[/][*][a-zA-Z0-9_;,"'.=? \n\t]*[*][/]   {;}
%%
int yywrap(){
   return 1;
}


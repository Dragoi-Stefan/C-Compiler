%{
#include<stdio.h>
#include<stdlib.h>
#include <string.h>
#include <stdbool.h>
extern FILE* yyin;
extern char* yytext;
extern int yylineno;
int yylex(void);
void yyerror(char *);
char vID_INT[256][256],vID_FLOAT[256][256],vID_CHAR[256][256],vID_STRING[256][256],vID_BOOL[256][256],vID_FUNC[256][256],vTIP_FUNC[256][256],vPAR_FUNC[256][256];
char vTIP_PARAMETRU[256][256];
char vTIP_VARIABILA_int[256][256],vTIP_VARIABILA_float[256][256],vTIP_VARIABILA_char[256][256],vTIP_VARIABILA_string[256][256],vTIP_VARIABILA_bool[256][256];
char vCHAR[256],vSTRING[256][256];
char aux[3];
int vINT[256]; int vBOOL[256];
int v_LOGIC[256];
float vFLOAT[256];
int cTIP_INT=0,cTIP_FLOAT=0,cTIP_CHAR=0,cTIP_STRING=0,cTIP_BOOL=0,cFUNC=0,cPARAM=0,c_LOGIC=0,cTIP_INT_1=0,cTIP_FLOAT_1=0,cFUNC_1=0,cTIP_CHAR_1=0,cTIP_STRING_1=0,cTIP_BOOL_1=0;
int vCOUNT_PARAM[256],par=0;
int ok_INT=1,ok_CHAR=1,ok_BOOL=1,ok_FLOAT=1,ok_STRING=1;


int validare(char s[100],char vtype[256][256],int type);
int validare_functie(char s[100],char vtype[256][256],int type);
int verif_parametru(char id[100],int par);
int validare_tip_parametru(char s[100], char tip[256][256],int type1,int par,char tip2[256][256]);
%}

%union
{
  char* sir;
  int valoare,bool_value;
  float float_value;
}

%token STRIN SEMIC COMMA IF ELSE ENDIF EQLTO NETQLTO SMALLEREQ BIGGEREQ WHILE BGIN END 
%token<sir> DECLRINT ID DECLRFLOAT CHAR STRING DECLRSTRING DECLRBOOL DECLRCHAR
%token<valoare> NUMBER
%token<float_value> NUMAR_FLOAT
%token<bool_value> BOOL
%left '+' '-'
%left '*' '/'
%type <valoare> exp declr assgn
%type <sir> exp1 lista_apel 
%type <bool_value> cond cond1
%%
main:
    progr {printf("valid expression\n");} 
;
progr:declaratii program;
declaratii:declaratie1 
          |declaratii declaratie1;
        

declaratie1:declr SEMIC
	   |tip '(' ')' '{' '}'
	   |tip '(' lista_param ')' '{' '}'
;

lista_param : param;
             |lista_param ',' param;
	     
param : DECLRINT ID{
		    strcpy(vTIP_PARAMETRU[cFUNC_1],strdup($1)); 
		    strcat(vPAR_FUNC[cFUNC]," int ");
		    strcat(vPAR_FUNC[cFUNC],strdup($2));
		    vCOUNT_PARAM[cFUNC]++;
		    cFUNC_1++;
		   } 
		   | DECLRFLOAT ID
		  { 
		    strcpy(vTIP_PARAMETRU[cFUNC_1],strdup($1)); 
		    strcat(vPAR_FUNC[cFUNC]," float ");
		    strcat(vPAR_FUNC[cFUNC],strdup($2));
		   vCOUNT_PARAM[cFUNC]++;
		   cFUNC_1++;
		   } 
		   | DECLRCHAR ID
		   {
		    strcpy(vTIP_PARAMETRU[cFUNC_1],strdup($1));  
		    strcat(vPAR_FUNC[cFUNC]," char ");
		    strcat(vPAR_FUNC[cFUNC],strdup($2));
		    vCOUNT_PARAM[cFUNC]++;
		    cFUNC_1++;
		   } 
		   | DECLRSTRING ID
		   { 
		    strcpy(vTIP_PARAMETRU[cFUNC_1],strdup($1));  
		    strcat(vPAR_FUNC[cFUNC]," string ");
		    strcat(vPAR_FUNC[cFUNC],strdup($2));
		    vCOUNT_PARAM[cFUNC]++;
		    cFUNC_1++;
		   } 
		   | DECLRBOOL ID
		   {
		    strcpy(vTIP_PARAMETRU[cFUNC_1],strdup($1));  
		    strcat(vPAR_FUNC[cFUNC]," bool ");
		    strcat(vPAR_FUNC[cFUNC],strdup($2));
		    vCOUNT_PARAM[cFUNC]++;
		    cFUNC_1++; 
		   };
tip:DECLRINT ID{
		 if(validare_functie(strdup($2),vID_FUNC,cFUNC)==1)
			  {cFUNC++;  
			  strcpy(vTIP_FUNC[cFUNC],"int");
			  strcpy(vID_FUNC[cFUNC],strdup($2));
			  }
			  else
			    yyerror("functia a fost declarata anterior");
		}
		
|DECLRFLOAT ID {
		 if(validare_functie(strdup($2),vID_FUNC,cFUNC)==1)
			  {cFUNC++;
			  strcpy(vTIP_FUNC[cFUNC],"float");
			  strcpy(vID_FUNC[cFUNC],strdup($2));
			  
			  }
			  else
			    yyerror("functia a fost declarata anterior");
		}
		
|DECLRCHAR ID {
		 if(validare_functie(strdup($2),vID_FUNC,cFUNC)==1)
			  {cFUNC++;
			  strcpy(vTIP_FUNC[cFUNC],"char");
			  strcpy(vID_FUNC[cFUNC],strdup($2));
			  
			  }
			  else
			    yyerror("functia a fost declarata anterior");
		}
		
|DECLRSTRING ID {
		 if(validare_functie(strdup($2),vID_FUNC,cFUNC)==1)
			  {cFUNC++;
			  strcpy(vTIP_FUNC[cFUNC],"string");
			  strcpy(vID_FUNC[cFUNC],strdup($2));
			  
			  }
			  else
			    yyerror("functia a fost declarata anterior");
	   }
		
|DECLRBOOL ID {
		 if(validare_functie(strdup($2),vID_FUNC,cFUNC)==1)
			  {cFUNC++;
			  strcpy(vTIP_FUNC[cFUNC],"bool");
			  strcpy(vID_FUNC[cFUNC],strdup($2));
			  
			  }
			  else
			    yyerror("functia a fost declarata anterior");
		}																	
;
program: BGIN list END;

list:
    stmt
    |list stmt | ifelsestmt | list ifelsestmt
;
ifelsestmt: IF '(' cond ')'
                stmt
            ENDIF
           |
           IF '(' cond ')'
               stmt
           ENDIF
           ELSE
               stmt
           ENDIF
          
           |
           IF '(' cond ')'
               ifelsestmt
           ENDIF
           |
           IF '(' cond ')'
               ifelsestmt
           ENDIF
           ELSE
               ifelsestmt
           ENDIF 
           |
           IF '(' cond ')'
               stmt
           ENDIF
           ELSE
               ifelsestmt
           ENDIF 
           |
           IF '(' cond ')'
               ifelsestmt
           ENDIF
           ELSE
               stmt
           ENDIF 
           |
           WHILE '(' cond ')'
               stmt
           ENDIF
           |
           WHILE '(' cond ')'
               ifelsestmt
           ENDIF
           |  
            ifelsestmt ifelsestmt
;

stmt: exp SEMIC | declr SEMIC |assgn SEMIC | functie SEMIC | cond SEMIC
;
functie: ID '(' lista_apel ')' { 
				  if(validare_functie(strdup($1),vID_FUNC,cFUNC)==1)
				  yyerror("functia nu a fost declarata");  
				  if(verif_parametru(strdup($1),par)==0)
				 { 
			          
				   yyerror("numar incorect de parametri");
				 }	
				  par=0;
				}
					
				
;
cond: cond1{c_LOGIC++;v_LOGIC[c_LOGIC]=$$;}
;
cond1: exp '<' exp	{ 
				if($1<$3)
				$$=1; else $$=0;
			}  
	| exp '>' exp  {	
				if($1>$3)
				$$=1; else $$=0;
			}
	| exp EQLTO exp {
				if($1==$3)
				$$=1;else $$=0;		
			 }
	| exp NETQLTO exp 
			 {
				if($1!=$3)
				$$=1;else $$=0;		
			 }
	| exp SMALLEREQ exp  {
				if($1<=$3)
				$$=1;else $$=0;		
			      }
	| exp BIGGEREQ exp  {
				if($1>=$3)
				$$=1;else $$=0;		
			     }
	| exp           {
				if($1!=0)
				$$=1;else $$=0;		
			 }
        ;

declr: DECLRINT ID     {
			  if(validare(strdup($2),vID_INT,cTIP_INT)==1)
			  {
			  strcpy(vTIP_VARIABILA_int[cTIP_INT_1],strdup($1));
			  strcpy(vID_INT[cTIP_INT],strdup($2));
			  cTIP_INT++;
			  cTIP_INT_1++;
			  }
			  else
			    yyerror("variabila a fost declarata anterior");
			}
| DECLRINT ID '=' NUMBER
{
  if(validare(strdup($2),vID_INT,cTIP_INT)==1)
  {
  strcpy(vID_INT[cTIP_INT],strdup($2));
  vINT[cTIP_INT]=$4;
  cTIP_INT++;
  }
  else
  yyerror("variabila a fost declarata anterior");
	
}

|DECLRFLOAT ID     {
			  if(validare(strdup($2),vID_FLOAT,cTIP_FLOAT)==1)
			  {
			  strcpy(vTIP_VARIABILA_float[cTIP_FLOAT_1],strdup($1));
			  strcpy(vID_FLOAT[cTIP_FLOAT],strdup($2));
			  cTIP_FLOAT++;
			  cTIP_FLOAT_1++;
			  }
			  else
			    yyerror("variabila a fost declarata anterior");
			}
			
| DECLRFLOAT ID '=' NUMAR_FLOAT
{
  if(validare(strdup($2),vID_FLOAT,cTIP_FLOAT)==1)
  {
  strcpy(vID_FLOAT[cTIP_FLOAT],strdup($2));
  vFLOAT[cTIP_FLOAT]=$4;
  cTIP_FLOAT++;
  }
  else
  	yyerror("variabila a fost declarata anterior");
  	
}

|DECLRCHAR ID     {
			  if(validare(strdup($2),vID_CHAR,cTIP_CHAR)==1)
			  {
			  strcpy(vTIP_VARIABILA_char[cTIP_CHAR_1],strdup($1));
			  strcpy(vID_CHAR[cTIP_CHAR],strdup($2));
			  cTIP_CHAR++;
			  cTIP_CHAR_1++;
			  }
			  else
			    yyerror("variabila a fost declarata anterior");
		  }
		  
| DECLRCHAR ID '=' CHAR
{
  if(validare(strdup($2),vID_CHAR,cTIP_CHAR)==1)
  {
  strcpy(vID_CHAR[cTIP_CHAR],strdup($2));
  strcpy(aux,strdup($4));
  vCHAR[cTIP_CHAR]=aux[1];
  cTIP_CHAR++;
  }
}						

|DECLRSTRING ID '['NUMBER']'    {
			  if(validare(strdup($2),vID_STRING,cTIP_STRING)==1)
			  {
			  strcpy(vTIP_VARIABILA_string[cTIP_STRING_1],strdup($1));
			  strcpy(vID_STRING[cTIP_STRING],strdup($2));
			  cTIP_STRING++;
			  cTIP_STRING_1++;
			  }
			  else
			    yyerror("variabila a fost declarata anterior");
		  }

| DECLRSTRING ID'['NUMBER']' '=' STRING
{
  if(validare(strdup($2),vID_STRING,cTIP_STRING)==1)
  {
  if(strlen(strdup($7))>$4)
  yyerror("prea lung");
  strcpy(vID_STRING[cTIP_STRING],strdup($2));
  strcpy(vSTRING[cTIP_STRING],strdup($7));
  cTIP_STRING++;
  }
  else
  	yyerror("variabila a fost declarata anterior");
  
  
}

|DECLRBOOL ID     {
			  if(validare(strdup($2),vID_BOOL,cTIP_BOOL)==1)
			  {
			 strcpy(vTIP_VARIABILA_bool[cTIP_BOOL_1],strdup($1));
			  strcpy(vID_BOOL[cTIP_BOOL],strdup($2));
			  cTIP_BOOL++;
			  cTIP_BOOL_1++;
			  }
			  else
			  yyerror("variabila a fost declarata anterior");
		 }
		 
| DECLRBOOL ID '=' NUMBER
{ 
  if(validare(strdup($2),vID_BOOL,cTIP_BOOL)==1)
  {
  if($4>1)
  yyerror("bool declarat incorect");
  strcpy(vID_BOOL[cTIP_BOOL],strdup($2));
  vBOOL[cTIP_BOOL]=$4;
  cTIP_BOOL++;
  }
  else
      yyerror("variabila a fost declarata anterior");   
}		 	
;

assgn: ID '=' exp { if(validare(strdup($1),vID_INT,cTIP_INT)==0)
		   {
		   for(int i=0;i<cTIP_INT;i++)
		   if(strcmp(vID_INT[i],strdup($1))==0)
		   vINT[i]=$3;
		   }
		   
		   else yyerror("Variabila nu exista");
		   }
		  
;

exp :
    exp '+' exp {$$ = $1 + $3; }
    | exp '-' exp { $$ = $1 - $3; }
    | exp '*' exp { $$ = $1 * $3; }
    | exp '/' exp { $$ = $1 / $3; }
    | '(' exp ')' { $$ = $2; }
    | NUMBER { $$ = $1; }
    | ID {
    if(validare(strdup($1),vID_INT,cTIP_INT)==0)
		   {
		   for(int i=0;i<cTIP_INT;i++)
		   if(strcmp(vID_INT[i],strdup($1))==0)
		   $$=vINT[i];
		   }

		   else yyerror("Variabila nu exista");
    }
   ;
   
exp1: ID {
	    par++;
	    if(validare(strdup($1),vID_INT,cTIP_INT)==0) 
	    {
	    if(validare_tip_parametru(strdup($1),vID_INT,cTIP_INT_1,par,vTIP_VARIABILA_int)==0 )
            yyerror("parametrii de tip diferit");
            }
            else
            if(validare(strdup($1),vID_FLOAT,cTIP_FLOAT)==0) 
	    { 
	    if(validare_tip_parametru(strdup($1),vID_FLOAT,cTIP_FLOAT_1,par,vTIP_VARIABILA_float)==0 )   
            yyerror("parametrii de tip diferit");
            }
            else
            if(validare(strdup($1),vID_CHAR,cTIP_CHAR)==0) 
	    { 
	    if(validare_tip_parametru(strdup($1),vID_CHAR,cTIP_CHAR_1,par,vTIP_VARIABILA_char)==0 )   
            yyerror("parametrii de tip diferit");
            }
            else
            if(validare(strdup($1),vID_STRING,cTIP_STRING)==0) 
	    { 
	    if(validare_tip_parametru(strdup($1),vID_STRING,cTIP_STRING_1,par,vTIP_VARIABILA_string)==0 )   
            yyerror("parametrii de tip diferit");
            }
            else
            if(validare(strdup($1),vID_BOOL,cTIP_BOOL)==0) 
	    { 
	    if(validare_tip_parametru(strdup($1),vID_BOOL,cTIP_BOOL_1,par,vTIP_VARIABILA_bool)==0 )   
            yyerror("parametrii de tip diferit");
            }
            		
	  }
;  

//expresie_aritmetica_functie: NUMBER {$$=$1;}
//			      |expresie_aritmetica_functie '+' expresie_aritmetica_functie  {$$ = $1 + $3; }
//			      | expresie_aritmetica_functie  '-' expresie_aritmetica_functie { $$ = $1 - $3; }
//			      | expresie_aritmetica_functie  '*' expresie_aritmetica_functie  { $$ = $1 * $3; }
//			      | expresie_aritmetica_functie  '/' expresie_aritmetica_functie  { $$ = $1 / $3; }
//			      | '(' expresie_aritmetica_functie  ')' { $$ = $2; }
//;
lista_apel : exp1
           | exp1 ',' lista_apel{           
					if(validare(strdup($1),vID_INT,cTIP_INT)==0) 
					{
					    if(validare(strdup($3),vID_INT,cTIP_INT)==1 && validare(strdup($3),vID_FLOAT,cTIP_FLOAT)==1 && validare(strdup($3),vID_CHAR,cTIP_CHAR)==1
					    && validare(strdup($3),vID_STRING,cTIP_STRING)==1 && validare(strdup($3),vID_BOOL,cTIP_BOOL)==1
					    )
					    yyerror("variabila nedeclarata"); 
					}
					else if(validare(strdup($1),vID_FLOAT,cTIP_FLOAT)==0)
					     {
					    if(validare(strdup($3),vID_INT,cTIP_INT)==1 && validare(strdup($3),vID_FLOAT,cTIP_FLOAT)==1 && validare(strdup($3),vID_CHAR,cTIP_CHAR)==1
					    && validare(strdup($3),vID_STRING,cTIP_STRING)==1 && validare(strdup($3),vID_BOOL,cTIP_BOOL)==1
					    )
					    yyerror("variabila nedeclarata"); 
					    }
					    else if(validare(strdup($1),vID_CHAR,cTIP_CHAR)==0)
					     {
					    if(validare(strdup($3),vID_INT,cTIP_INT)==1 && validare(strdup($3),vID_FLOAT,cTIP_FLOAT)==1 && validare(strdup($3),vID_CHAR,cTIP_CHAR)==1
					    && validare(strdup($3),vID_STRING,cTIP_STRING)==1 && validare(strdup($3),vID_BOOL,cTIP_BOOL)==1
					    )
					    yyerror("variabila nedeclarata"); 
					    }
					    else if(validare(strdup($1),vID_STRING,cTIP_STRING)==0)
					     {
					    if(validare(strdup($3),vID_INT,cTIP_INT)==1 && validare(strdup($3),vID_FLOAT,cTIP_FLOAT)==1 && validare(strdup($3),vID_CHAR,cTIP_CHAR)==1
					    && validare(strdup($3),vID_STRING,cTIP_STRING)==1 && validare(strdup($3),vID_BOOL,cTIP_BOOL)==1
					    )
					    yyerror("variabila nedeclarata"); 
					    }
					    else if(validare(strdup($1),vID_BOOL,cTIP_BOOL)==0)
					     {
					    if(validare(strdup($3),vID_INT,cTIP_INT)==1 && validare(strdup($3),vID_FLOAT,cTIP_FLOAT)==1 && validare(strdup($3),vID_CHAR,cTIP_CHAR)==1
					    && validare(strdup($3),vID_STRING,cTIP_STRING)==1 && validare(strdup($3),vID_BOOL,cTIP_BOOL)==1
					    )
					    yyerror("variabila nedeclarata"); 
					    }
					    else
					    yyerror("variabila nedeclarata");	   
           		         }
           ;

%%

void yyerror(char  *msg)
{
    fprintf(stderr, "line %d: %s\n", yylineno, msg);
    //printf("Invalid expression:%s\n",msg);
    exit(0);
}

int validare_tip_parametru(char s[100],char tip[256][256] ,int type1,int par, char tip2[256][256])
{
    int i;
     for(i=0;i<type1;i++)
     	if(strcmp(tip[i],s)==0 && strcmp(tip2[i],vTIP_PARAMETRU[par-1])!=0)
     	return 0;
     return 1;  	
}


int validare(char s[100],char vtype[256][256],int type)
{
  int i;
  for(i=0;i<type;i++)
    {
    	if(strcmp(s,vtype[i])==0)
    	return 0;
    }
  return 1;	
}
int validare_functie(char s[100],char vtype[256][256],int type)
{
  int i;
  for(i=1;i<=type;i++)
    {
    	if(strcmp(s,vtype[i])==0)
    	return 0;
    }
  return 1;	
}

int verif_parametru(char id[100],int par)
{
	int i;
	for(int i=1;i<=cFUNC;i++)
	  { 
	   if(vCOUNT_PARAM[i]!=par && strcmp(vID_FUNC[i],id)==0) 
	    {return 0;}
	  }  
	return 1;   
}

int main(int argc, char** argv){

yyin=fopen(argv[1],"r");
yyparse();
FILE *fp;
FILE *fpf;
fp=fopen("symbol_table.txt","w");
fpf=fopen("symbol_table_functions.txt","w");
fprintf(fp,"Tip ID Valoare\n");
for(int i=0;i<cTIP_INT;i++)
{
printf("int %s %d\n",vID_INT[i],vINT[i]);
fprintf(fp,"int %s %d\n",vID_INT[i],vINT[i]);
fprintf(fp,"\r\n");
}
for(int i=0;i<cTIP_FLOAT;i++)
{
printf("float %s %f\n",vID_FLOAT[i],vFLOAT[i]);
fprintf(fp,"float %s %f\n",vID_FLOAT[i],vFLOAT[i]);
fprintf(fp,"\r\n");
}
for(int i=0;i<cTIP_CHAR;i++)
{
printf("char %s %c\n",vID_CHAR[i],vCHAR[i]);
fprintf(fp,"char %s %c\n",vID_CHAR[i],vCHAR[i]);
fprintf(fp,"\r\n");
}
for(int i=0;i<cTIP_STRING;i++)
{
printf("string %s %s\n",vID_STRING[i],vSTRING[i]);
fprintf(fp,"string %s %s\n",vID_STRING[i],vSTRING[i]);
fprintf(fp,"\r\n");
}
for(int i=0;i<cTIP_BOOL;i++)
{
printf("bool %s %d\n",vID_BOOL[i],vBOOL[i]);
fprintf(fp,"bool %s %d\n",vID_BOOL[i],vBOOL[i]);
fprintf(fp,"\r\n");
}
for(int i=1;i<=c_LOGIC;i++)
{
   printf("valoarea expresiei logice %d este: %d\n",i,v_LOGIC[i]);
}
printf("------functii\n");
for(int i=1;i<=cFUNC;i++)
{
printf("numele functiei:%s \t tip functie:%s \t parametrii:%s\n",vID_FUNC[i],vTIP_FUNC[i],vPAR_FUNC[i]);
fprintf(fpf,"numele functiei:%s \t tip functie:%s \t parametrii:%s\n",vID_FUNC[i],vTIP_FUNC[i],vPAR_FUNC[i]);
}

} 

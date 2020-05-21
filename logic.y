/*
*This project aims to use a one dimension boolean array to save case sensitive binary variables
*the software should be able to solve/simplify the a given logic expression
*/
%{
	void yyerror(char* s);
	int  yylex();/*Adding YACC functions before any further step to avoid any YACC process issues*/
	#include <ctype.h>
	#include <stdio.h>
	#include <stdlib.h>
	#include <stdbool.h>/*Including the library for boolean primitive type be available */
	bool g_logicVars[52];
	enum operations {not,and,or,then,equal};
	int  findIndex(char* logicVar);
	void printVar(char logicVar);
	void updateVar(char logicVar,bool value);
	bool executeOperation(char logicVar1,int ope,char logicVar2);/* Using integers to represent each of the expressions*/
%}

%%


%union {char id;bool isWhat;}	/* YACC definitions */
%start 			line
%token 			PRINT
%token 			EXIT
%left 	<id> 		NOT
%left 	 		AND
%token 			OR
%right			THEN
%right			EQUAL
%token 	<id> 		IDENTIFIER
%type 	<isWhat> 	VT


%%

/* descriptions of the inputs	actions in C */
line	: line 					{;}
        | EXIT 					{exit(EXIT_SUCCESS);}
	| PRINT					{;}
	| PRINT IDENTIFIER 			{printVar($2);}
	| NOT					{executeOperation($<id>$,not,'z');}
	| NOT IDENTIFIER 			{executeOperation($2,not,'z');}
	| IDENTIFIER AND IDENTIFIER		{executeOperation($1,and,$3);}
	| IDENTIFIER OR IDENTIFIER		{executeOperation($1,or,$3);}
	| IDENTIFIER THEN IDENTIFIER 		{executeOperation($1,then,$3);}
	| IDENTIFIER EQUAL IDENTIFIER 		{executeOperation($1,equal,$3);}
	| line EXIT	 			{exit(EXIT_SUCCESS);}
	;

VT	: VT 					{;}
	| IDENTIFIER '=' VT 			{updateVar($1,$3);}
	;

%%
/*Declaring YACC specific C functions before Actual C actions*/

void yyerror(char* s){
	fprintf(stderr,"%s\n",s);
}

int findIndex(char* logicVar){
	int index=0;
	if(islower(logicVar)){
		index=logicVar - 'a' + 26;
	}
	else{
		index=logicVar - 'A';
	}
	return index;
}

void printVar(char logicVar){
	int index=findIndex(logicVar);
	if (g_logicVars[index]){
		printf("%s the variable is True",logicVar);
	}
	else{
		printf("%s the variable is False",logicVar);
	}
}

void updateVar(char logicVar,bool value){
	int index=findIndex(&logicVar);
	g_logicVars[index]=value;
	printVar(logicVar);
}


bool executeOperation(char logicVar1, int ope,char logicVar2){
	int index1=findIndex(&logicVar1);
	int index2=findIndex(&logicVar2);
	bool opeResult=false;
	switch (ope){
		case not:
			if(!g_logicVars[index1]){
				opeResult=true;
			}
			break;
		case and:
			if(g_logicVars[index1] && g_logicVars[index2]){
				opeResult=true;	
			}
			break;
		case or:
			if(g_logicVars[index1] || g_logicVars[index2]){
				opeResult=true;
			}
			break;
		case then:
			if(!g_logicVars[index2]){
				if(g_logicVars){
					opeResult=false;/*Just stating this so the code logic makes sense */
				}
				else{
					opeResult=true;
				}
			}
			else{
				opeResult=true;
			}
			break;
		case equal:
			if(g_logicVars[index1] == g_logicVars[index2]){
				opeResult=true;
			}
			break;

	}
	return opeResult;

}

void addToStack(){

}

int main(void){
	/*initializing symbol table for the logic vars as false for every element*/
	for(int i=0;i<52;i++){
		g_logicVars[i]=false;	
	}
	return yyparse();

}


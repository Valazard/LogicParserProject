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
	typedef struct stack{
		stack* next;
		char id1;
		int ope;
		char id2;
		
	};
	int  findIndex(char* logicVar);
	void printVar(char logicVar);
	void updateVar(char logicVar,bool value);
	void executeOperation(char logicVar1,int ope,char logicVar2);/* Using integers to represent each of the expressions*/
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
	| NOT IDENTIFIER 			{executeOperation($2,0,'@');}
	| IDENTIFIER AND IDENTIFIER		{executeOperation($1,1,$3);}
	| IDENTIFIER OR IDENTIFIER		{executeOperation($1,2,$3);}
	| IDENTIFIER THEN IDENTIFIER 		{executeOperation($1,3,$3);}
	| IDENTIFIER EQUAL IDENTIFIER 		{executeOperation($1,4,$3);}
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


void executeOpe(char logicVar1, char ope,char logicVar2){

}

int main(void){
	/*initializing symbol table for the logic vars as false for every element*/
	for(int i=0;i<52;i++){
		g_logicVars[i]=false;	
	}
	return yyparse();

}


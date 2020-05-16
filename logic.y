/*
*This project aimsd to use a one dimension boolean array to save case sensitive binary variables
*the software should be able to simplify the expression
*/
%{
	void yyerror(char* s);
	int  yylex();/*Adding YACC functions before any further step to avoid any YACC process issues*/
	#include <ctype.h>
	#include <stdio.h>
	#include <stdlib.h>
	#include <stdbool.h>/*Including the library for boolean primitive type be available */
	bool logicVars[52];
	int  findIndex(char* logicVar);
	void printVar(char* logicVar);
	void updateVar(char logicVar,bool value);
	void executeOpe(char logicVar1, char ope,char logicVar2);
%}

%%

%union {char id;bool isWhat;}	/* YACC definitions */
%start line
%token print
%token exit_command
%token <id> identifier
%type <isWhat> vt
%type <id> ope

%%

/* descriptions of the inputs	actions in C */
line	: assignment ';'				{;}
        | exit_command ';'				{exit(EXIT_SUCCESS);}
		| print							{;}
		| print identifier ';'			{printVar(&$2);}
		| line exit_command ';' 		{exit(EXIT_SUCCESS);}
		;

vt		: vt ';'						{;}
		| identifier '=' vt				{updateVar($1,$3);}
		;

ope		: ope ';'						{;}
    	| identifier ope vt ';'			{updateVar($1,$3);}
		| identifier ope identifier ';'	{executeOpe($1,$2,$3);}
		;

int findIndex(char* logicVar){
	int index=0;
	if(islower(&logicVar)){
		index=&logicVar - 'a' + 26;
	}
	else{
		index=&logicVar-'A';
	}
	return index;
}


int main(){
}

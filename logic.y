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
	#include <malloc.h>
	bool g_logicVars[52];
	enum operations {not,and,or,then,equal};
	typedef struct stack{
		int index1;
		int index2;
		int ope;
		stack* next;
	};
	stack* g_logicStack;
	int  findIndex(char* logicVar);
	void printVar(char logicVar);
	void updateVar(char logicVar,bool value);
	bool executeOperation(bool* logicVar1,int ope,bool* logicVar2);/* Using integers to represent each of the expressions*/
	void addToStack(char logicVar1,int ope,char logicVar2);
	void solveStack();

%}

%%


%union {char id;bool isWhat;}	/* YACC definitions */
%start 			line
%token 			PRINT
%token 			EXIT
%left 	<id> 		NOT
%left 	 		AND
%left 			OR
%left			THEN
%left			EQUAL
%left 	<id> 		IDENTIFIER
%type 	<isWhat> 	VT


%%

/* descriptions of the inputs	actions in C */
line	: line 					{;}
        | EXIT 					{exit(EXIT_SUCCESS);}
	| SOLVE					{solveStack();}
	| PRINT					{;}
	| PRINT IDENTIFIER 			{printVar($2);}
	| NOT					{addToStack($<id>$,not,'z');}
	| NOT IDENTIFIER 			{addToStack($2,not,'z');}
	| IDENTIFIER AND IDENTIFIER		{addToStack($1,and,$3);}
	| IDENTIFIER OR IDENTIFIER		{addToStack($1,or,$3);}
	| IDENTIFIER THEN IDENTIFIER 		{addToStack($1,then,$3);}
	| IDENTIFIER EQUAL IDENTIFIER 		{addToStack($1,equal,$3);}
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


bool executeOperation(bool* logicVar1, int ope,bool* logicVar2){
	bool opeResult=false;
	switch (ope){
		case not:
			if(!*logicVar1){
				opeResult=true;
			}
			break;
		case and:
			if(*logicVar1 && *logicVar2){
				opeResult=true;	
			}
			break;
		case or:
			if(*logicVar1 || *logicVar2){
				opeResult=true;
			}
			break;
		case then:
			if(!*logicVar2){
				if(*logicVar1){
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
			if(*logicVar1 == *logicVar2){
				opeResult=true;
			}
			break;

	}
	return opeResult;

}

void addToStack(char logicVar1,int ope,char logicVar2){
	int indexVar1=findIndex(&logicVar1);
	int indexVar2=findIndex(&logicVar2);
	bool concluded=false;
	stack* newStep=(stack*)malloc(sizeof(stack));
	stack* temp=g_logicStack->next;
	newStep->index1=indexVar1;
	newStep->index2=indexVar2;
	if(temp != g_logicStack){
		while(temp != g_logicStack && !concluded){
			if(temp->operator < ope && temp->next->operator >= ope ){
				newStep->next=temp->next;
				temp->next=newStep;
				concluded=true;
			}
			temp=temp->next;	
		}
	}
	else if(g_logicStack->index1 == -1){
		newStep->next=newStep;
		free(g_logicStack);
		g_logicStack=newStep;
	}
	else if(g_logicStack->operator < ope){
		newStep->next=g_logicStack;
		g_logicStack->next=newStep;
		g_logicStack=newStep;
	}
	else{
		newStep->next=g_logicStack;
		g_logicStack->next=newStep;
	}
	

}

void solveStack(){
	

}

int main(void){
	/*initializing symbol table for the logic vars as false for every element*/
	for(int i=0;i<52;i++){
		g_logicVars[i]=false;	
	}
	*g_logicStack=(stack*)malloc(sizeof(stack));
	g_logicStack->next=g_logicStack;
	g_logicStack->index1=-1;/* Setting to initialization value to -1 to provide awareness of newly created stack*/
	g_logicStack->index2=-1;
	g_logicStack->operator=-1;
	return yyparse();

}


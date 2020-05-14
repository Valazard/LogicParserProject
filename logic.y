/*
*This project aimsd to use a one dimension boolean array to save case sensitive binary variables
*the software should be able to simplify the expression
*/
%{
	#include <ctype.h>
	#include <stdio.h>
	#include <stdlib.h>
	#include <stdbool.h>/*Including the library for boolean primitive type be available */
	bool logicVars[52];
	void updateVars(char logicVar,bool value);
%}

%%

%union {char id;bool isWhat;}
%start line
%token print
%token exit_command
%token <id> identifier
%token <isWhat> value
%type <id> assigment 

%%

/*  */

int main(){
}

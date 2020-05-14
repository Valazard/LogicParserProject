%{
	#include <ctype.h>
	#include <stdio.h>
	#include <stdlib.h>
	#include <stdbool.h>
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

%%

int main(){
}

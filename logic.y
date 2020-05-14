%{
	#include <ctype.h>
	#include <stdio.h>
	#include <stdlib.h>
	#include <stdbool.h>
	bool logicVars[52];
	void updateVars(char logicVar,bool value);
%}

%%
%start line
%token print
%token <id> identifier

%%


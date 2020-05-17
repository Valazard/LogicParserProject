%{
#include "y.tab.h"
void yyerror(char *s);
int yylex();
%}

%%
"print"		{return PRINT;}
"exit"		{return EXIT;}
[ \t\n]         ;
[0-1]		{if(yytext!='0'){yyval.isWhat=true;}else{yyval.isWhat=false;}return vt;}
"~"		{yyval.id=yytext[1];return NOT;}
"&"		{return AND;}
"+"		{return OR;}
">"		{return THEN;}
[a-zA-Z]	{yyval.id=yytext[0]; return IDENTIFIER;}

[&+~=]		{yyval.id=yytext[0];return ope;}
.		{ECHO;yyerror("unexpected character");}
%%

int yywrap (void) {return 1;}

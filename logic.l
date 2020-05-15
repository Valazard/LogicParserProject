%{
void yyerror(chjar *s);
int yylex();
%}
%%
"print"		{return print;}
"exit"		{return exit_command;}
["true"]	{yyval.id=yytext[0];return true;}
[ \t\n]         ;
[a-zA-Z]	{yyval.id=yytext[0]; return identifier;}
[&+~=]		{yyval.id=yytext[0];return operator}
.		{ECHO;yyerror("unexpected character");}
%%

int yywrap (void) {return 1;}

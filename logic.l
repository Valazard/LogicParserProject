%{
void yyerror(chjar *s);
int yylex();
%}
%%
"print"		{return print;}
"exit"		{return exit_command;}
[ \t\n]         ;
[a-zA-Z]	{yyval.id=yytext[0]; return identifier;}
[&+~=]		{return yytext[0];}
.		{ECHO;yyerror("unexpected character");}
%%

int yywrap (void) {return 1;}

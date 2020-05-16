%{
void yyerror(char *s);
int yylex();
%}
%%
"print"		{return print;}
"exit"		{return exit_command;}
[ \t\n]         ;
[a-zA-Z]	{yyval.id=yytext[0]; return identifier;}
[0-1]		{if(yytext!='0'){yyval.isWhat=true;}else{yyval.isWhat=false;}return vt;}
[&+~=]		{yyval.id=yytext[0];return ope;}
.		{ECHO;yyerror("unexpected character");}
%%

int yywrap (void) {return 1;}

%{
    #include<stdio.h>
    #include<string.h>
    int comment=0;
    int line=1;
%}

%option noyywrap

whiteSpaces [\n\t ]
arithmaticOperator [+\-*/^]
bitwiseOperator [&|]

%%
"//".*$                 {printf("TOKEN_COMMENT\t%s\n",yytext);}
"/*"                    {comment=1;printf("TOKEN_COMMENT\t%s",yytext);}
"*/"                    {if(comment==1){
                          comment=0;
                          printf("%s\n",yytext);}
                         else {printf("error in line %d : unopend comment section\n",line);return 0;}
                        }

"int"                   {if(comment!=1)printf("TOKEN_INTTYPE\t%s\n",yytext); else printf("%s",yytext);}
"void"                  {if(comment!=1)printf("TOKEN_VOIDTYPE\t%s\n",yytext); else printf("%s",yytext);}
"foreach"               {if(comment!=1)printf("TOKEN_LOOP\t%s\n",yytext); else printf("%s",yytext);}
"return"                {if(comment!=1)printf("TOKEN_RETURN\t%s\n",yytext); else printf("%s",yytext);}
"if"                    {if(comment!=1)printf("TOKEN_IFCONDITION\t%s\n",yytext); else printf("%s",yytext);}
"else"                  {if(comment!=1)printf("TOKEN_ELSE\t%s\n",yytext); else printf("%s",yytext);}
"main"                  {if(comment!=1)printf("TOKEN_MAINFUNC\t%s\n",yytext); else printf("%s",yytext);}
"float"                 {if(comment!=1)printf("TOKEN_FLOATTYPE\t%s\n",yytext); else printf("%s",yytext);}
"double"                {if(comment!=1)printf("TOKEN_DOUBLETYPE\t%s\n",yytext); else printf("%s",yytext);}
"string"                {if(comment!=1)printf("TOKEN_STRINGTYPE\t%s\n",yytext); else printf("%s",yytext);}
"char"                  {if(comment!=1)printf("TOKEN_CHARTYPE\t%s\n",yytext); else printf("%s",yytext);}
"break"                 {if(comment!=1)printf("TOKEN_BREAKSTMT\t%s\n",yytext); else printf("%s",yytext);}
"continue"              {if(comment!=1)printf("TOKEN_CONTINUESTMT\t%s\n",yytext); else printf("%s",yytext);}

{arithmaticOperator}    {if(comment!=1)printf("TOKEN_ARITHMATICOP\t%s\n",yytext); else printf("%s",yytext);}
{bitwiseOperator}       {if(comment!=1)printf("TOKEN_BITWISEOP\t%s\n",yytext); else printf("%s",yytext);}
"&&"|"||"|"!"           {if(comment!=1)printf("TOKEN_LOGICOP\t%s\n",yytext); else printf("%s",yytext);}
"<="|"<"|">"|">="|"=="|"!="      {if(comment!=1)printf("TOKEN_RELATIONOP\t%s\n",yytext); else printf("%s",yytext);}
"="                     {if(comment!=1)printf("TOKEN_ASSIGNOP\t%s\n",yytext); else printf("%s",yytext);}
"("                     {if(comment!=1)printf("TOKEN_LEFTPAREN\t%s\n",yytext); else printf("%s",yytext);}
")"                     {if(comment!=1)printf("TOKEN_RIGHTPAREN\t%s\n",yytext); else printf("%s",yytext);}
"{"                     {if(comment!=1)printf("TOKEN_LCB\t%s\n",yytext); else printf("%s",yytext);}
"}"                     {if(comment!=1)printf("TOKEN_RCB\t%s\n",yytext); else printf("%s",yytext);}
";"                     {if(comment!=1)printf("TOKEN_SEMICOLON\t%s\n",yytext); else printf("%s",yytext);}
","                     {if(comment!=1)printf("TOKEN_COMMA\t%s\n",yytext); else printf("%s",yytext);}
".."                    {if(comment!=1)printf("TOKEN_UNTIL\t%s\n",yytext); else printf("%s",yytext);}
"["                     {if(comment!=1)printf("TOKEN_LB\t%s\n",yytext); else printf("%s",yytext);}
"]"                     {if(comment!=1)printf("TOKEN_RB\t%s\n",yytext); else printf("%s",yytext);}

" "                     {if(comment!=1)printf("TOKEN_WHITESPACE\t[space]\n"); else printf("%s",yytext);}
"\n"                    {line++; if(comment!=1){printf("TOKEN_WHITESPACE\t\\n\n");} else printf("%s",yytext);}
"\t"                    {if(comment!=1)printf("TOKEN_WHITESPACE\t\\t\n"); else printf("%s",yytext);}

(("+"|"-")[0-9]*)|[0-9]*  {if(comment!=1){
                              if(atol(yytext)<2147483648 &&atol(yytext)>-2147483648 )printf("TOKEN_INTCONST\t%s\n",yytext);
                              else {printf("error in line %d : integer constant is out of range\n",line);return 0;}
                            }
                            else printf("%s",yytext);
                           }


[0-9][0-9]*"."[0-9][0-9]*         {if(comment!=1)printf("TOKEN_FLOATCONST\t%s\n",yytext); else printf("%s",yytext);}
[0-9][0-9]*"."[0-9][0-9]*"E"("+"|"-")[0-9][0-9]*  {if(comment!=1)printf("TOKEN_FLOATCONST\t%s\n",yytext); else printf("%s",yytext);}
[0-9][0-9]*"."[0-9][0-9]*"E"[0-9][0-9]*  {if(comment!=1)printf("TOKEN_FLOATCONST\t%s\n",yytext); else printf("%s",yytext);}

\'.\'                   {if(comment!=1)printf("TOKEN_CHARCONST\t%s\n",yytext); else printf("%s",yytext);}

\".*\"                  {if(comment!=1)printf("TOKEN_STRINGCONST\t%s\n",yytext); else printf("%s",yytext);}

[a-zA-Z][a-zA-Z0-9_]*   {if(comment!=1)printf("TOKEN_ID\t%s\n",yytext); else printf("%s",yytext);}
[^a-zA-Z\n\t (){};,[\]][a-zA-Z0-9_]*          {if(yyleng>=2&&yytext[0]=='/'&&yytext[1]=='*'){comment=1;printf("TOKEN_COMMENT\t%s",yytext);} else{if(comment!=1){printf("error in line %d : wrong id definition\n",line);return 0;} else printf("%s",yytext);}}

.                       {if(comment!=1)printf("%s",yytext); else printf("%s",yytext);}

<<EOF>>                 {if(comment==1)printf("error in line %d : unclosed comment section\n",line); return 0;}

%%




int main(int argc,char* argv[]){
  yyin=fopen(argv[1], "r");

  yylex();

  return 0;
}

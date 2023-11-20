%{

#include<stdio.h>
#include<string.h>
#include<math.h>
#include "finaldemo3.tab.h"
    void yyerror(char *);
%}
%option yylineno
%%
"Jog Koro"[ ]*"["[A-Za-z0-9]+[.][h]"]"          {return DEP;}
"Cholok"[ ]*                                       {return INIT;}
[+-]?[0-9]+                                     {yylval.variable.ival = atoi(yytext);
                                                 return INT;}
    
[+-]?[0-9]*[.][0-9]+                {yylval.variable.fval = atof(yytext);
                                     return FLOAT;}

["].*["]                            {yytext++;int l=strlen(yytext);
                                    yylval.variable.st=yytext;
                                    yylval.variable.st[l-1]='\0';
                                    return STRING;}
"="                                     {return EQUAL;}
"+"                                     {return ADD;}
"-"                                     {return MINUS;}
"*"                                     {return MUL;}
"/"                                     {return DIV;}
"%"                                     {return MOD;}
"("                                     {return LFB;}
")"                                     {return RFB;}
"{"                                     {return LSB;}
"}"                                     {return RSB;}
"["                                     {return LTB;}

"]"                                     {return RTB;}
","                                     {return COMMA;}
":"                                     {return COLON;}
"!"                                     {return NOT;}
"++"                              {return INC;}
"--"                              {return DEC;}
">"                               {return GT;}
"<"                               {return LT;}
">="                              {return GEQ;}
"<="                              {return LEQ;}
"=="                              {return EQ;}
"!="                              {return NEQ;}
[k][a][j][-][>][a-zA-Z0-9]+             {return FUN;}
"#"                               {return *yytext;}
[#][a-z<>.h]+                     {return HEAD;}
[/]{2}.*                          {return CMT;}
[#][a-zA-Z][a-zA-Z0-9]*                   {yylval.variable.str = yytext;
                                    return AN;}
[ ;\t\n]                           {}
"Thamo"                            {return STOP;}
"CholeThako"                       {return GOING;}
"Motamot"                        {return RET;}
"!?"                              {return VOID;}
"bkaj->FLOOR"                       {return FLOOR;}
"bkaj->CEIL"                        {return CEIL;}
"bkaj->ABS"                         {return ABS;}
"intnum"                            {return INTT;}
"floatnum"                            {return FL;}
"stringnum"                          {return STT;}

"bkaj->SIN"                         {return SINE;}
"bkaj->COS"                         {return COS;}
"bkaj->TAN"                         {return TAN;}
"bkaj->POW"                         {return POW;}
"bkaj->LOGE"                          {return LN;}
"bkaj->PRIME"                       {return PRIME;}
"bkaj->FACTORIAL"                   {return FACT;}
"Dekhaoi"                         {return OUTPUTI;}
"Dekhaof"                         {return OUTPUTF;}
"Dekhaos"                         {return OUTPUTS;}
"inputi"                          {return INPUTI;}
"inputf"                          {return INPUTF;}
"endl"                            {return END;}

"bkaj->LEN"                         {return LEN;}
"bkaj->CMP"                         {return CMP;}
"bkaj->CAT"                         {return CAT;}
"bkaj->CPY"                         {return CPY;}
"bkaj->GCD"                         {return GCD;}
"bkaj->LCM"                         {return LCM;}
"bkaj->MIN"                         {return MIN;}
"bkaj->MAX"                         {return MAX;}
"bkaj->BITAND"                      {return BITAND;}
"bkaj->BITOR"                       {return BITOR;}
"bkaj->BITNOT"                      {return BITNOT;}
"bkaj->BITXOR"                      {return BITXOR;}
"bkaj->BITLEFT"                     {return BITLEFT;}
"bkaj->BITRIGHT"                    {return BITRIGHT;}

"Jodi"                              {return IF;}
"AbarJodi"                             {return ELIF;}
"Nahole"                             {return ELSE;}
"ForChokro"                           {return FOR;}
"WhileChokro"                           {return WHILE;}
"Chokro"                            {return LOOP;}
"Poriborton"                           {return SW;}
"bikolpo"                             {return CA;}
"auto"                              {return DF;}
"Koro"                              {return DO;}
"Shuru Kori"                          {return MAIN;}
"##".*"##"                        {printf("This is a Comment\n");}
[a-zA-Z][a-zA-Z0-9]*              {yylval.variable.str = strdup(yytext);
                                    return ID;}
.                                 {printf("Unknown character is detected.\n");}
%%
int yywrap(void) {
    return 1;
}

%{
    #include<bits/stdc++.h>
    using namespace std;

    void yyerror(char *);
    extern int yylex();
    extern int yyparse();
    extern FILE *yyin;
    extern FILE *yyout;

     class store
     {
        public:
        char name[100];
        char vas[100];
        int val;
        float vall;
     };
     store symbol_table[100];

    class listt
    {
        public:
        char array_name[100];
        int arr[1000];
        int limit;
    };
    listt list1[50];
    
    // typedef struct{
    // 	char func_name[100];
    // }funlists;
    // funlists funlist[50];
    int check(int n);

    int count1,sw,dv,array_counter;
    store find_value(char **sym);
    int add_value(char **sym);
    int find_array_value(char **sym,int j);
    int add_array_value(char **sym,int j);
%}

%union{
    struct use
    {
        int ival;
        float fval;
        char *str;
        char *st;
    }variable;
}
%start program
%token<variable>INT INTT FL FLOAT ID STRING STT VOID AN INIT EQ NEQ GEQ LEQ STOP GOING LOOP FUN MAIN DEP
%type<variable>statement factor expr assignments assignment var declaration type display input add sub mul div mod great less equal notequal eqgreat eqless condition if_else elseif else switch_ case cases df for while break_con do_while array array_assignment function return built_func main end dep
%token IF ELIF ELSE FOR SW CA WHILE COL INC DEC MIN MAX GCD OUTPUTI DO PRIME DF POW OUTPUTF PFA SINE COS TAN LN CMT HEAD ABS FLOOR CEIL RET OUTPUTS PFSN LEN CMP CAT CPY END INPUTI INPUTF
%left '+' '-'
%left '*' '/'
%left INC DEC

%%

program:
    |program statement
    |
    ;
statement:
    declaration 
    |assignments
    |input
    |display {$$.ival=$1.ival;}
    |if_else
    |switch_
    |case
    |for
    |while
    |do_while
    |array
    |array_assignment 
    |built_func
    |function
    |main
    |end
    |dep
    ;
dep:
    DEP
    ;
main:
    type MAIN '('')' ':' '{'
    ;
    
end:
    RET '(' expr ')' '}'
    ;
declaration:
    INIT assignments
    ;
    
assignments:
    assignment 
    ;
    
input:
    INPUTI '(' var ')'{
        int a;
        scanf("%d",&a);
        symbol_table[$3.ival].val = a;
    }
    |INPUTF '(' var ')'{
        float a;
        scanf("%f",&a);
        symbol_table[$3.ival].vall = a;
    }
    ;
    
display:
    OUTPUTI '(' expr ')'{
        printf("%d\n",$3.ival);
    }
    |OUTPUTF '(' expr ')'{
        printf("%f\n",$3.fval);
    }
    |OUTPUTS '(' expr ')'{
        printf("%s ",$3.st);
    }
    |PFA '(' '<' AN ',' INT '>' ')' {int a = find_array_value(&$4.str,$6.ival); printf("%d\n",a);}
    |END {printf("\n");}
    ;
    
array:
    AN ':' type'[' expr ']'{
        char a[100];
        strcpy(a,$1.str);
        int i=0;
        while(1)
        {
            if(a[i]==':')
            {
                break;
            }
            i++;
        }
        a[i]='\0';
        strcpy(list1[array_counter].array_name,a);
        list1[array_counter].limit=$5.ival;
        array_counter++;
        }
    |'{' AN ',' expr '}' {$$.ival = find_array_value(&$2.str,$4.ival);}
    ;
    
array_assignment:
    '{' AN ',' expr '}' '<''<' expr {int i = add_array_value(&$2.str,$4.ival); list1[i].arr[$4.ival]=$8.ival;}
    ;

function:
	type FUN  '(' expr ',' expr ',' ')'':''{' expr return '}' { int val1 = $4.ival;
								    int val2 = $6.ival;
								    int val3 = $11.ival;
								    $$.ival = val1 + val2 + val3;}
        ;
built_func:        								    
        LEN '(' expr ')'{int a=strlen($3.st);printf("Lenght of string: %d\n",a);$$.ival=a;}
        |CMP '(' expr ',' expr ')'{store n = find_value(&$3.str),m=find_value(&$5.str);int a = strcmp(n.vas,m.vas);}
        |CAT '(' expr ',' expr ')'{int i = add_value(&$3.str),j = add_value(&$5.str);strcat(symbol_table[i].vas,symbol_table[j].vas);}
        |PRIME '(' expr ')'{
        int n=$3.ival;
        $$.ival = check(n);
        $$.ival==0?printf("Not prime.\n"):printf("Prime.\n");
    }
    |MIN '(' expr ',' expr ')'{
        if($3.ival>$5.ival)
        {
            $$.ival = $5.ival;
        }
        else
        {
            $$.ival = $3.ival;
        }
        printf("%d\n",$$.ival);
    }
    |MAX '(' expr ',' expr ')'{
        if($3.ival>$5.ival)
        {
            $$.ival = $3.ival;
        }
        else
        {
            $$.ival = $5.ival;
        }
        printf("%d\n",$$.ival);
    }
    |GCD '(' expr ',' expr ')'{
       int c;
       int a = $3.ival;
       int b = $5.ival;
       if(a>b)
       {
           int temp = a;
           a=b;
           b=a;
       }
       while(a!=0)
       {
           int temp = b%a;
           b=a;
           a=temp;
       }
       $$.ival = b;
       printf("%d\n",$$.ival);
    }
    |SINE '(' expr ')'{double x = (double)$3.fval,ans = sin((x*3.1416)/180.0);printf("%f\n",$$.fval=(float)ans);}
    |COS '(' expr ')'{double x = (double)$3.fval,ans = cos((x*3.1416)/180.0); printf("%f\n",$$.fval=(float)ans); }
    |TAN '(' expr ')'{double x = (double)$3.fval,ans = tan((x*3.1416)/180.0); printf("%f\n",$$.fval=(float)ans); }
    |POW '(' expr ',' expr ')'{double x = (double)$3.fval,y = (double)$5.fval;printf("%f\n",$$.fval=(float)pow(x,y));}
    |LN '(' expr ')'{float x = $3.fval,ans = log(x);printf("%f\n",$$.fval=ans);}
    |FLOOR '(' expr ')'{$$.ival=(int)$3.fval;printf("%d\n",$$.ival);}
    |CEIL '(' expr ')' {$$.ival=(int)$3.fval+1;printf("%d\n",$$.ival);}
        ;
        
return:
       RET {$$.str = "RETURN";}
       |   {$$.str = "VOID";}
       ;
       
assignment: 
    var ':' type '<''<' expr   {
                    if($6.ival==INT_MIN && $6.fval==FLT_MIN && symbol_table[$1.ival].val==INT_MAX && symbol_table[$1.ival].vall==FLT_MAX)
                    {
                        strcpy(symbol_table[$1.ival].vas,$6.st);
                    }
                    else if($6.ival==INT_MIN && $6.fval!=FLT_MIN && symbol_table[$1.ival].val==INT_MAX && symbol_table[$1.ival].vas[0]=='\0')
                    {
                        symbol_table[$1.ival].vall=$6.fval;
                    }
                    else if($6.ival!=INT_MIN && $6.fval==FLT_MIN && symbol_table[$1.ival].vall==FLT_MAX && symbol_table[$1.ival].vas[0]=='\0')
                    {
                        symbol_table[$1.ival].val=$6.ival;

                    }
                    else
                    {
                        printf("Variable Type error.\n");\
                        
                    }
                    

    }
    |var '<''<' expr {
                    if($4.ival==INT_MIN && $4.fval==FLT_MIN && symbol_table[$1.ival].val==INT_MAX && symbol_table[$1.ival].vall==FLT_MAX)
                    {
                        strcpy(symbol_table[$1.ival].vas,$4.st);
                    }
                    else if($4.ival==INT_MIN && $4.fval!=FLT_MIN && symbol_table[$1.ival].val==INT_MAX && symbol_table[$1.ival].vas[0]=='\0')
                    {
                        symbol_table[$1.ival].vall=$4.fval;
                    }
                    else if($4.ival!=INT_MIN && $4.fval==FLT_MIN && symbol_table[$1.ival].vall==FLT_MAX && symbol_table[$1.ival].vas[0]=='\0')
                    {
                        symbol_table[$1.ival].val=$4.ival;
                    }
                    else
                    {
                        printf("Variable Type error.\n");

                    }
    }
    ;

type:
    INTT
    |FL
    |STT
    |VOID
    ;

var:
    var ',' ID
    |ID {$$.ival = add_value(&$1.str);}
    ;  
expr:
    factor{$$.ival=$1.ival;$$.fval=$1.fval;if($1.st!=NULL){strcpy($$.st,$1.st);}}
    |'+''(' add ')' {$$.ival=$3.ival;$$.fval=$3.fval;if($3.st!=NULL){strcpy($$.st,$3.st);}}
    |'-''(' sub ')' {$$.ival=$3.ival;$$.fval=$3.fval;if($3.st!=NULL){strcpy($$.st,$3.st);}}
    |'*''(' mul ')' {$$.ival=$3.ival;$$.fval=$3.fval;if($3.st!=NULL){strcpy($$.st,$3.st);}}
    |'/''(' div ')' {$$.ival=$3.ival;$$.fval=$3.fval;if($3.st!=NULL){strcpy($$.st,$3.st);}}
    |'%''(' mod ')' {$$.ival=$3.ival;$$.fval=$3.fval;if($3.st!=NULL){strcpy($$.st,$3.st);}}
    |condition
    |array 
    |function
    ;
    
add:
    expr ',' expr{if($1.fval!=FLT_MIN){$$.fval=$1.fval+$3.fval;}else{$$.ival=$1.ival+$3.ival;}}  
    |expr ',' '+'  {$$.ival=$1.ival+1;}  
    |'+' ',' expr  {$$.ival=$3.ival+1;}
    ;
sub:
    expr ',' expr{if($1.fval!=FLT_MIN){$$.fval=$1.fval-$3.fval;}else{$$.ival=$1.ival-$3.ival;}}  
    |expr ',' '-'  {$$.ival=$1.ival-1;}  
    |'-' ',' expr  {$$.ival=$3.ival-1;}
    ;
mul:
    expr ',' expr{if($1.fval!=FLT_MIN){$$.fval=$1.fval*$3.fval;}else{$$.ival=$1.ival*$3.ival;}}  
    ;
div:
    expr ',' expr{if($1.fval!=FLT_MIN){if($3.fval!=0.0){$$.fval=$1.fval/$3.fval;}}else{if($3.ival!=0){$$.ival=$1.ival/$3.ival;}}}    
    ;
mod:
    expr ',' expr{$$.ival = $1.ival % $3.ival;}   
    ;   
    
condition:
    //factor{$$.ival=$1.ival;$$.fval=$1.fval;}
    '>''(' great ')'       {$$.ival=$3.ival;$$.fval=$3.fval;}
    |'<''(' less ')'        {$$.ival=$3.ival;$$.fval=$3.fval;}
    |EQ '(' equal ')'    {$$.ival=$3.ival;$$.fval=$3.fval;}
    |NEQ '(' notequal ')' {$$.ival=$3.ival;$$.fval=$3.fval;}
    |GEQ '(' eqgreat ')'  {$$.ival=$3.ival;$$.fval=$3.fval;}
    |LEQ '(' eqless ')'   {$$.ival=$3.ival;$$.fval=$3.fval;}
    ;

great:
     expr ',' factor{if($1.ival==INT_MIN){$$.ival = $1.fval > $3.fval;}else{$$.ival = $1.ival > $3.ival;}}
     ;
less:
     expr ',' factor{if($1.ival==INT_MIN){$$.ival = $1.fval < $3.fval;}else{$$.ival = $1.ival < $3.ival;}}
     ;
equal:
     expr ',' factor{if($1.ival==INT_MIN){$$.ival = $1.fval == $3.fval;}else{$$.ival = $1.ival == $3.ival;}}
     ;
notequal:
     expr ',' factor{if($1.ival==INT_MIN){$$.ival = $1.fval != $3.fval;}else{$$.ival = $1.ival != $3.ival;}}
     ;
eqgreat:
     expr ',' factor{if($1.ival==INT_MIN){$$.ival = $1.fval >= $3.fval;}else{$$.ival = $1.ival >= $3.ival;}}
     ;
eqless:
     expr ',' factor{if($1.ival==INT_MIN){$$.ival = $1.fval <= $3.fval;}else{$$.ival = $1.ival <= $3.ival;}}
     ;

factor:
    INT{$$.ival=$1.ival; $$.fval=FLT_MIN;$$.st=NULL;}
    |FLOAT{$$.fval = $1.fval; $$.ival=INT_MIN;$$.st=NULL;}
    |STRING{$$.ival=INT_MIN;$$.fval=FLT_MIN;strcpy($$.st,$1.st);}
    |ID{store pp = find_value(&$1.str);if(pp.val==INT_MAX && pp.vall==FLT_MAX){$$.ival=INT_MIN;$$.fval=FLT_MIN;strcpy($$.st,pp.vas);}
    else if(pp.val==INT_MAX && pp.vall!=FLT_MAX){$$.fval=pp.vall;$$.ival=INT_MIN;}
                                       else{$$.ival=pp.val;$$.fval=FLT_MIN;}}
    ;

if_else:
    IF '[' condition ']' '{' expr '}'{
                                if($3.ival)
                                {
                                    printf("IF statement output %d\n", $6.ival);
                                }

    }
    |IF '[' condition ']' '{' expr '}' elseif{
                                if($3.ival)
                                {
                                    printf("IF statement output %d\n", $6.ival);
                                }

    }
    |IF '[' condition ']' '{' expr '}' else{
                                if($3.ival)
                                {
                                    printf("IF statement output %d\n", $6.ival);
                                }
                                else 
                                {
                                    printf("ELSE statement output %d\n", $8.ival);
                                }
    }
    ;

elseif:
    ELIF '[' condition ']' '{' expr '}' elseif{
                                if($3.ival)
                                {
                                    printf("ESIF statement output %d\n", $6.ival);
                                }
                        
    }
    |ELIF '[' condition ']' '{' expr '}' else{
                                if($3.ival)
                                {
                                    printf("ESIF statement output %d\n", $6.ival);
                                }
                                else 
                                {
                                    printf("ELSE statement output %d\n", $8.ival);
                                }
    }
    ;
else: 
    ELSE '{' expr '}'
                        {
                         $$.ival = $3.ival;
                        }
    ;

switch_:
    SW '[' expr ']' {
        sw = $3.ival;
        dv = -9999;
        printf("This is a switch statement.\n");
    }
    ;
    
case:
    cases
    {
        if(sw!=INT_MIN && dv != -9999)
        {
            printf("Default %d\n",dv);
        }
    }
    ;
    
cases: 
    CA '[' expr ']' ':' expr {
        if(sw==$3.ival)
        {
            printf("Case %d: ouput: %d\n",$3.ival,$6.ival);
            sw = INT_MIN;
        }

    }
    |CA '[' expr ']' ':' expr df {
        if(sw==$3.ival)
        {
            printf("Case %d: ouput: %d:\n",$3.ival,$6.ival);
            sw = INT_MIN;
        }

    }
    ;
df:
    DF ':' expr{
       dv = $3.ival;
    }
    ;

for:
    FOR '[' expr ',' '<''(' expr ',' expr ')' ',' expr ']' '{' expr '}'{
                   for(int i=$3.ival;i<$9.ival;i=i+1)
                   {
                        printf("For Iteration:%d output:%d\n",i,$15.ival);
                   }
    }
    |
    FOR '[' expr ',' '>''(' expr ',' expr ')' ',' expr ']' '{' expr '}'{
                   for(int i=$3.ival;i>$9.ival;i=i-1)
                   {
                        printf("For Iteration:%d output:%d\n",i,$15.ival);
                   }
    }
    ;
while:
    WHILE '[' '<''(' expr ',' expr ')' ']' '{' expr break_con '}'{
        int i = $5.ival;
        while(i < $7.ival){
        	printf("While Iteration:%d output:%d\n",i,$11.ival);
        	if(i == $12.ival)
        		break;
        	i = i + 1;
       } 		
    }
    |
    WHILE '[' expr ']' '{' expr break_con '}'{
        int i = 1;
        while(i){
        	printf("While Iteration:%d output:%d\n",i,$6.ival);
        	if(i == $7.ival)
        		break;
        	i = i + 1;
       } 		
    }
    |
    WHILE '[' '>''(' expr ',' expr ')' ']' '{' expr break_con '}'{
        int i = $5.ival;
        while(i > $7.ival){
        	printf("While Iteration:%d output:%d\n",i,$11.ival);
        	if(i == $12.ival)
        		break;
        	i = i - 1;
       } 		
    }
    ;
do_while:
    DO '{' expr break_con '}' LOOP '[' '<''(' expr ',' expr ')' ']'{
        int i = $10.ival;
        while(i < $12.ival){
        	printf("Do_While Iteration:%d output:%d\n",i,$3.ival);
        	if(i == $4.ival)
        		break;
        	i = i + 1;
       } 
    }
    |
    DO '{' expr break_con '}' LOOP '[' '<''(' expr ',' expr ')' ']'{
        int i = $10.ival;
        while(i > $12.ival){
        	printf("Do_While Iteration:%d output:%d\n",i,$3.ival);
        	if(i == $4.ival)
        		break;
        	i = i + 1;
       } 
    }
    |
    DO '{' expr break_con '}' LOOP '[' expr ']'{
        int i = 1;
        while(i){
        	printf("Do_While Iteration:%d output:%d\n",i,$3.ival);
        	if(i == $4.ival)
        		break;
        	i = i + 1;
       } 
    }
    ;

break_con:
	STOP '(' expr ')' {$$.ival = $3.ival;}
	|                 {$$.ival = -999999999;}
	;


%%
int add_value(char **sym)
{
    char a[100];
    int l=strlen(*sym);
    strcpy(a,*sym);
    int i=0;
    //printf("%s ro\n",a);
    while((a[i]>='a' && a[i]<='z') || (a[i]>='A' && a[i]<='Z') || (a[i]>='0' && a[i]<='9'))
    {
        if(a[i]=='\0')
        {
            break;
        }
        i++;
    }
    a[i]='\0';
    for(int i=0;i<count1;i++)
	{
		if (!strcmp(a, symbol_table[i].name))
		{
            return i;
		}
	}
    strcpy(symbol_table[count1].name,a);
    symbol_table[count1].val = INT_MAX;
    symbol_table[count1].vall = FLT_MAX;
    count1++;
    //printf("%d",count);
    return count1-1;
}

store find_value(char **sym)
{
    char a[100];
    int l=strlen(*sym);
    strcpy(a,*sym);
    int i=0;
    //printf("%s ro\n",a);
    while((a[i]>='a' && a[i]<='z') || (a[i]>='A' && a[i]<='Z') || (a[i]>='0' && a[i]<='9'))
    {
        if(a[i]=='\0')
        {
            break;
        }
        i++;
    }
    a[i]='\0';
	int p = 0;
	for(int i=0;i<count1;i++)
	{
		if (!strcmp(a, symbol_table[i].name))
		{
            return symbol_table[i];
		}
	}
    store n;
    printf("Variable not declared\n");
	return n;
}

int find_array_value(char **sym,int j)
{
    char a[100];
    int l=strlen(*sym);
    strcpy(a,*sym);
    int i=0;
    //printf("%s \n",a);
    while(1)
    {
        if(a[i]==',')
        {
            break;
        }
        i++;
    }
    a[i]='\0';
	int p = 0;
	for(int i=0;i<array_counter;i++)
	{
		if (!strcmp(a, list1[i].array_name))
		{
            return list1[i].arr[j];
		}
	}
    printf("Array not declared\n");
	return -1;
}
int add_array_value(char **sym,int j)
{
        char a[100];
        strcpy(a,*sym);
        int i=0;
        while(1)
        {
            if(a[i]==',')
            {
                break;
            }
            i++;
        }
        a[i]='\0';
        int p=0;
        for(int i=0;i<array_counter;i++)
        {
            if (!strcmp(a, list1[i].array_name)){
                if(j<list1[i].limit)
                {
                    //list[i].arr[$4.ival]=$7.ival;
                    p=1;
                    return i;
                }
                else{
                    printf("Program is trying to access invalid memory location.\n");
                }
           
            }
        }
        if(!p)
        {
            printf("Invalid Statement.\n");
        }
}

 int check(int n)
        {
            if(n==1)
            {
                return 0;
            }
            if(n==2)
            {
                return 1;
            }
            if(n%2==0)
            {
                return 0;
            }
            int m = sqrt(n);
            for(int i=3;i<=m+2;i+=2)
            {
                if(n%i==0)
                {
                    return 0;
                }
            }
            return 1;
        }
void yyerror(char *s)
{
	fprintf(stderr, "error: %s\n",s);
}

int main(void) {
freopen("input.txt","r",stdin);
freopen("output.txt","w",stdout);
yyparse();
return 0;
}
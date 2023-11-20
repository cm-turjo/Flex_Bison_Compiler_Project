%{
    #include<bits/stdc++.h>
    using namespace std;

    void yyerror( char *);
    extern int yylex();
    extern int yyparse();
    extern FILE *yyin;
    extern FILE *yyout;
    extern int yylineno;

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
    unsigned int factorial (unsigned int n);
   
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
%token EQUAL ADD MINUS MUL DIV MOD LFB RFB LSB RSB LTB RTB COMMA COLON NOT GT LT
%token<variable>INT INTT FL FLOAT ID STRING STT VOID AN INIT EQ NEQ GEQ LEQ STOP GOING LOOP FUN MAIN DEP
%type<variable>statement factor expr  assignments assignment var declaration type display input add1 sub1 mul1 div1 mod1 great less equal notequal eqgreat eqless condition if_else elseif else switch_ case cases df for while break_con do_while array array_assignment function return built_func main end dep

%token IF ELIF ELSE FOR SW CA WHILE COL INC DEC MIN MAX GCD LCM OUTPUTI DO PRIME DF POW OUTPUTF PFA SINE COS TAN LN CMT HEAD ABS FLOOR CEIL RET OUTPUTS  LEN CMP CAT CPY END INPUTI INPUTF FACT

%nonassoc IF
%nonassoc ELIF
%nonassoc ELSE

%left GT LT GEQ LEQ NEQ EQUAL EQ
%left ADD MINUS
%left MUL DIV
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
    |display {$$.ival=$1.ival;$$.fval=$1.fval;$$.st=$1.st;}
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
    DEP  {cout<<"Header File Declaration Detected!......."<<endl;}
    ;
    
main:
    type MAIN LFB RFB COLON LSB  {cout<<endl; cout<<"MAIN Function Started Successfully........."<<endl;}
    ;
    
end:
    RET LFB expr RFB RSB {cout<<endl;cout<<"MAIN Function Ended Successfully............"<<endl;}
    ;
declaration:
    INIT assignments
    ;
    
assignments:
    assignment 
    ;
    
input:
    INPUTI LFB var RFB{
        int a;
        scanf("%d",&a);
        symbol_table[$3.ival].val = a;
    } 
    |INPUTF LFB var RFB{
        float a;
         scanf("%f",&a);
        symbol_table[$3.ival].vall = a;
    }
    ;
    
display:
    OUTPUTI LFB expr RFB{
        
        cout<<"Output of Integer variable is : "<<$3.ival<<endl;
    }
    |OUTPUTF LFB expr RFB{
        
       cout<<"Output of Float variable is : "<<$3.fval<<endl;
    }
    |OUTPUTS LFB expr RFB{
        
        cout<<"Output of String variable is: "<<$3.st<<endl;
    }
    |END {printf("\n");}
    ;
    
array:
    AN COLON type LTB expr RTB{
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
    |LSB AN COMMA expr RSB {$$.ival = find_array_value(&$2.str,$4.ival);}
    ;
    
array_assignment:
    LSB AN COMMA expr RSB LT LT expr {int i = add_array_value(&$2.str,$4.ival); list1[i].arr[$4.ival]=$8.ival;}
    ;

function:
	type FUN LFB expr COMMA expr COMMA RFB COLON LSB expr return RSB {cout<<"Function Executed Successfully"<<endl; 
    int val1 = $4.ival;
								    int val2 = $6.ival;
								    int val3 = $11.ival;
								    $$.ival = val1 + val2 + val3;cout<<""<<endl;}
        ;
built_func:        								    
        LEN LFB expr RFB {
            int a=strlen($3.st);
            cout<<endl;
            cout<<"Length of String: "<<$3.st<<" is: "<<a<<endl;
            cout<<endl;
        //printf("Lenght of string: %d\n",a);
        $$.ival=a;
        }
        |CMP LFB expr COMMA expr RFB{
            store n = find_value(&$3.str),m=find_value(&$5.str);
        int a = strcmp(n.vas,m.vas);
        cout<<endl;
        if(a==0)
        {
            cout<<"String: "<<n.vas<<" & String: "<<m.vas<<" are equal..."<<endl;
        }
        else if(a>0)
        {
            cout<<"Between "<<n.vas <<" & " <<m.vas<<" "<<"String: "<<m.vas<<" is smaller..."<<endl;
        }
        else
        {
             cout<<"Between "<<n.vas <<" & " <<m.vas<<" "<<"String: "<<n.vas<<" is smaller..."<<endl;
        }
        
        }
        |CAT LFB expr COMMA expr RFB{
            int i = add_value(&$3.str),j = add_value(&$5.str);
            cout<<endl;
            cout<<"Before Concatanation: String1 is: "<<symbol_table[i].vas<<endl;
        strcat(symbol_table[i].vas,symbol_table[j].vas);
        cout<<endl;
        
        cout<<"Before Concatanation: String2 is: "<<symbol_table[j].vas<<endl;
        cout<<"After Concatanation: String1 is: "<<symbol_table[i].vas<<endl;

        }
        |PRIME LFB  expr RFB {
        int n=$3.ival;
        $$.ival = check(n);
        cout<<endl;

        //$$.ival=0 ? cout<<$3.ival <<" is not a prime number">>endl:cout<<$3.ival<<" is a prime number"<<endl;
        $$.ival==0?printf("Not prime.\n"):printf("Prime.\n");
    }
    |MIN LFB expr COMMA expr RFB{
        if($3.ival>$5.ival)
        {
            $$.ival = $5.ival;
        }
        else
        {
            $$.ival = $3.ival;
        }
        cout<<endl;
        cout<<"Minimum between "<<$3.ival<<" & "<<$5.ival<<" is : "<<$$.ival<<endl;
       // printf("%d\n",$$.ival);
    }
    |MAX LFB expr COMMA expr RFB{
        if($3.ival>$5.ival)
        {
            $$.ival = $3.ival;
        }
        else
        {
            $$.ival = $5.ival;
        }
        cout<<endl;
        cout<<"Maximum between "<<$3.ival<<" & "<<$5.ival<<" is : "<<$$.ival<<endl;
        //printf("%d\n",$$.ival);
    }
    |GCD LFB expr COMMA expr RFB{
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
       cout<<endl;
      cout<<"GCD of "<<$3.ival<<" & "<<$5.ival<<" is : "<<$$.ival<<endl; 
    }
    |LCM LFB expr COMMA expr RFB{
        int c;
        int a=$3.ival;
        int b=$5.ival;
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
       $$.ival = ($3.ival*$5.ival)/b;
       cout<<endl;
       cout<<"LCM of "<<$3.ival<<" & "<<$5.ival<<" is : "<<$$.ival<<endl;
        
    }
    |SINE LFB expr RFB{
        double x = (double)$3.fval,ans = sin((x*3.1416)/180.0);
    $$.fval=(float)ans;
    cout<<endl;
    cout<<"SINE value of "<<$3.fval<<" is : "<<$$.fval<<endl;
    //printf("%f\n",$$.fval=(float)ans);
    }
    |COS LFB expr RFB{
        double x = (double)$3.fval,ans = cos((x*3.1416)/180.0);
        $$.fval=(float)ans;
        cout<<endl;
        cout<<"COS value of "<<$3.fval<<" is : "<<$$.fval<<endl;
     //printf("%f\n",$$.fval=(float)ans); 
     }
    |TAN LFB expr RFB{
        cout<<endl;
        double x = (double)$3.fval,ans = tan((x*3.1416)/180.0); 
         $$.fval=(float)ans;
        cout<<"TAN value of "<<$3.fval<<" is : "<<$$.fval<<endl;
    //printf("%f\n",$$.fval=(float)ans); 
    }
    |POW LFB expr COMMA expr RFB{
        double x = (double)$3.fval,y = (double)$5.fval;
        $$.fval=(float)pow(x,y);
        cout<<endl;
        cout<<"POW Result is: "<<$$.fval<<endl;
   // printf("%f\n",$$.fval=(float)pow(x,y));
   }
    |LN LFB expr RFB {float x = $3.fval,ans = log(x);
    $$.fval=ans;
    cout<<endl;
    cout<<"Log value of "<<$3.fval<<" is : "<<$$.fval<<endl;
    //printf("%f\n",$$.fval=ans);
    }
    |FLOOR LFB expr RFB{$$.ival=(int)$3.fval;
    cout<<endl;
    cout<<"Floor Value of "<<$3.fval<<" is : "<<$$.ival<<endl;
    //printf("%d\n",$$.ival);
    }
    |CEIL LFB expr RFB {$$.ival=(int)$3.fval+1;
    cout<<endl;
    cout<<"CEIL Value of "<<$3.fval<<" is : "<<$$.ival<<endl;
   // printf("%d\n",$$.ival);
   }
   |FACT LFB expr RFB{
    int n=$3.ival;
    n=factorial(n);
    cout<<"Factorial of "<<$3.ival<<" is: "<<n<<endl;
    $$.ival=n;
   }
   |ABS LFB expr RFB{
    int n=abs($3.ival);
    cout<<endl;
    cout<<"ABS Value of "<<$3.ival<<" is :"<<n<<endl;
    $$.ival=$3.fval;
   }
 
        
return:
       RET {$$.str = "RETURN";}
       |   {$$.str = "VOID";}
       ;
       
assignment: 
    var COLON type LT LT expr   {
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
                        //printf("Variable Type error.\n");
                        cout<<endl;
                         cout<<"Variable Type Error..."<<endl;
                        
                    }
                    

    }
    | var LT LT expr {
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
                       // printf("Variable Type error.\n");
                       cout<<endl;
                       cout<<"Variable Value Setting Error..."<<endl;

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
    var COMMA ID
    |ID {$$.ival = add_value(&$1.str);}
    ;  


expr:
    |factor{$$.ival=$1.ival;$$.fval=$1.fval;if($1.st!=NULL){strcpy($$.st,$1.st);}}
    |ADD LFB add1 RFB {$$.ival=$3.ival;$$.fval=$3.fval;if($3.st!=NULL){strcpy($$.st,$3.st);}}
    |MINUS LFB sub1 RFB {$$.ival=$3.ival;$$.fval=$3.fval;if($3.st!=NULL){strcpy($$.st,$3.st);}}
    |MUL LFB mul1 RFB {$$.ival=$3.ival;$$.fval=$3.fval;if($3.st!=NULL){strcpy($$.st,$3.st);}}
    |DIV LFB div1 RFB {$$.ival=$3.ival;$$.fval=$3.fval;if($3.st!=NULL){strcpy($$.st,$3.st);}}
    |MOD LFB mod1 RFB {$$.ival=$3.ival;$$.fval=$3.fval;if($3.st!=NULL){strcpy($$.st,$3.st);}}
    |condition expr
    |array expr
    |function expr
    |built_func expr
    |display
   
   
   
   
    
    ;
    
add1:
    expr COMMA expr{if($1.fval!=FLT_MIN){$$.fval=$1.fval+$3.fval;cout<<endl;cout<<"After the Addition Operation between "<<$1.fval<<" & "<<$3.fval<< "Result is: "<<$$.fval<<endl;}else{$$.ival=$1.ival+$3.ival;cout<<"After the Addition Operation between "<<$1.ival<<" & "<<$3.ival<< " Result is: "<<$$.ival<<endl;}}
      
    |expr COMMA ADD  {$$.ival=$1.ival+1;}  
    |ADD COMMA expr  {$$.ival=$3.ival+1;}
    ;
sub1:
    expr COMMA expr{if($1.fval!=FLT_MIN){$$.fval=$1.fval-$3.fval;cout<<endl;cout<<"After the Subtraction Operation between "<<$1.fval<<" & "<<$3.fval<< "Result is: "<<$$.fval<<endl;}else{$$.ival=$1.ival-$3.ival;cout<<"After the Subtraction Operation between "<<$1.ival<<" & "<<$3.ival<< " is: "<<$$.ival<<endl;}}  
    |expr COMMA MINUS  {$$.ival=$1.ival-1;cout<<endl;cout<<"After the Post Decrement Operation result is: "<<$$.ival<<endl;}  
    |MINUS COMMA expr  {$$.ival=$3.ival-1;cout<<endl;cout<<"After the Pre Decrement Operation result is: "<<$$.ival<<endl;}
    ;
mul1:
    expr COMMA expr{if($1.fval!=FLT_MIN){$$.fval=$1.fval*$3.fval;cout<<endl;cout<<"After the Multiplication Operation between "<<$1.fval<<" & "<<$3.fval<< " is: "<<$$.fval<<endl;}else{$$.ival=$1.ival*$3.ival;cout<<"After the Multiplication Operation between "<<$1.ival<<" & "<<$3.ival<< " is: "<<$$.ival<<endl;}}  
    ;
div1:
    expr COMMA expr{if($1.fval!=FLT_MIN){if($3.fval!=0.0){$$.fval=$1.fval/$3.fval;cout<<endl;cout<<"After the Division Operation between "<<$1.fval<<" & "<<$3.fval<< "Result is: "<<$$.fval<<endl;}}else{if($3.ival!=0){$$.ival=$1.ival/$3.ival;cout<<"After the Division Operation between "<<$1.ival<<" & "<<$3.ival<< " is: "<<$$.ival<<endl;}}}    
    ;
mod1:
    expr COMMA expr{$$.ival = $1.ival % $3.ival;cout<<endl;cout<<"After the Modulus Operation between "<<$1.ival<<" & "<<$3.ival<< " Result is: "<<$$.ival<<endl;}   
    ;   
    
condition:
    //factor{$$.ival=$1.ival;$$.fval=$1.fval;}
    GT LFB great RFB       {$$.ival=$3.ival;$$.fval=$3.fval;}
    |LT LFB less RFB        {$$.ival=$3.ival;$$.fval=$3.fval;}
    |EQ LFB equal RFB    {$$.ival=$3.ival;$$.fval=$3.fval;}
    |NEQ LFB notequal RFB {$$.ival=$3.ival;$$.fval=$3.fval;}
    |GEQ LFB eqgreat RFB  {$$.ival=$3.ival;$$.fval=$3.fval;}
    |LEQ LFB eqless RFB   {$$.ival=$3.ival;$$.fval=$3.fval;}
    
    ;

great:
     expr COMMA factor{if($1.ival==INT_MIN){$$.ival = $1.fval > $3.fval;}else{$$.ival = $1.ival > $3.ival;}}
     ;
less:
     expr COMMA factor{if($1.ival==INT_MIN){$$.ival = $1.fval < $3.fval;}else{$$.ival = $1.ival < $3.ival;}}
     ;
equal:
     expr COMMA factor{if($1.ival==INT_MIN){$$.ival = $1.fval == $3.fval;}else{$$.ival = $1.ival == $3.ival;}}
     ;
notequal:
     expr COMMA factor{if($1.ival==INT_MIN){$$.ival = $1.fval != $3.fval;}else{$$.ival = $1.ival != $3.ival;}}
     ;
eqgreat:
     expr COMMA factor{if($1.ival==INT_MIN){$$.ival = $1.fval >= $3.fval;}else{$$.ival = $1.ival >= $3.ival;}}
     ;
eqless:
     expr COMMA factor{if($1.ival==INT_MIN){$$.ival = $1.fval <= $3.fval;}else{$$.ival = $1.ival <= $3.ival;}}
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
    IF LTB condition RTB LSB expr RSB{
                                if($3.ival)
                                {
                                    cout<<endl;
                                    printf("IF statement output %d\n", $6.ival);
                                }

    }
    |IF LTB condition RTB LSB expr RSB elseif{
                                if($3.ival)
                                {
                                    cout<<endl;
                                    printf("IF statement output %d\n", $6.ival);
                                }

    }
    |IF LTB condition RTB LSB expr RSB else{
                                if($3.ival)
                                {
                                    cout<<endl;
                                    printf("IF statement output %d\n", $6.ival);
                                }
                                else 
                                {
                                    cout<<endl;
                                    printf("ELSE statement output %d\n", $8.ival);
                                }
    }
    ;

elseif:
    ELIF LTB condition RTB LSB expr RSB elseif{
                                if($3.ival)
                                {
                                    cout<<endl;
                                    printf("ESIF statement output %d\n", $6.ival);
                                }
                        
    }
    |ELIF LTB condition RTB LSB expr RSB else{
                                if($3.ival)
                                {
                                    cout<<endl;
                                    printf("ESIF statement output %d\n", $6.ival);
                                }
                                else 
                                {
                                    cout<<endl;
                                    printf("ELSE statement output %d\n", $8.ival);
                                }
    }
    ;
else: 
    ELSE LSB expr RSB
                        {
                         $$.ival = $3.ival;
                        }
    ;

switch_:
    SW LTB expr RTB {
        sw = $3.ival;
        dv = -9999;
        cout<<endl;
        printf("This is a switch statement.\n");
    }
    ;
    
case:
    cases
    {
        if(sw!=INT_MIN && dv != -9999)
        {
            cout<<endl;
            printf("Default %d\n",dv);
        }
    }
    ;
    
cases: 
    CA LTB expr RTB COLON expr {
        if(sw==$3.ival)
        {
            cout<<endl;
            printf("Case %d: ouput: %d\n",$3.ival,$6.ival);
            sw = INT_MIN;
        }

    }
    |CA LTB expr RTB COLON expr df {
        if(sw==$3.ival)
        {
            cout<<endl;
            printf("Case %d: ouput: %d:\n",$3.ival,$6.ival);
            sw = INT_MIN;
        }

    }
    ;
df:
    DF COLON expr{
       dv = $3.ival;
    }
    ;

for:
    FOR LTB expr COMMA LT LFB expr COMMA expr RFB COMMA expr RTB LSB expr RSB{
                   for(int i=$3.ival;i<$9.ival;i=i+1)
                   {
                    cout<<endl;
                        printf("ForChokro Iteration:%d output:%d\n",i,$15.ival);
                   }
    }
    |
    FOR LTB expr COMMA GT LFB expr COMMA expr RFB COMMA expr RTB LSB expr RSB{
                   for(int i=$3.ival;i>$9.ival;i=i-1)
                   {
                    cout<<endl;
                        printf("ForChokro Iteration:%d output:%d\n",i,$15.ival);
                   }
    }
    ;
while:
    WHILE LTB LT LFB expr COMMA expr RFB RTB LSB expr break_con RSB{
        int i = $5.ival;
        while(i < $7.ival){
        	printf("While Iteration:%d output:%d\n",i,$11.ival);
        	if(i == $12.ival)
        		break;
        	i = i + 1;
       } 		
    }
    |
    WHILE LTB expr RTB LSB expr break_con RSB{
        int i = 1;
        while(i){
        	printf("While Iteration:%d output:%d\n",i,$6.ival);
        	if(i == $7.ival)
        		break;
        	i = i + 1;
       } 		
    }
    |
    WHILE LTB GT LFB expr COMMA expr RFB RTB LSB expr break_con RSB{
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
    DO LSB expr break_con RSB LOOP LTB LT LFB expr COMMA expr RFB RTB{
        int i = $10.ival;
        while(i < $12.ival){
        	printf("Do_While Iteration:%d output:%d\n",i,$3.ival);
        	if(i == $4.ival)
        		break;
        	i = i + 1;
       } 
    }
    |
    DO LSB expr break_con RSB LOOP LTB GT LFB expr COMMA expr RFB RTB{
        int i = $10.ival;
        while(i > $12.ival){
        	printf("Do_While Iteration:%d output:%d\n",i,$3.ival);
        	if(i == $4.ival)
        		break;
        	i = i - 1;
       } 
    }
    |
    DO LSB expr break_con RSB LOOP LTB expr RTB{
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
	STOP LFB expr RFB {$$.ival = $3.ival;}
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
            // mp1[a]++;
            // int x= mp1[a];
            // if(x>1)
            // {
            //    {cout<<" Value Declaration Error! "<<endl;}
            //    return -1;
            // }
            // else 
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
            //cout<< "Variable Name is : "<<symbol_table[i].name<<" ";
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
    printf("Array Access Error\n");
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
unsigned int factorial(unsigned int n) 
{ 
    if(n<0)
    {
        cout<<"Factorial is only applicable for postive value"<<endl;
        return -1;
    }

    if (n == 0 || n == 1) 
        return 1; 
    return n * factorial(n - 1); 
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
	//fprintf(stderr, "error: %s\n",s);
    cout<< "Error! "<<s;
    cout<<" Error is at: "<<yylineno<<" Line !"<<endl;

}

int main(void) {
freopen("input2.txt","r",stdin);
freopen("output2.txt","w",stdout);
yyparse();
fclose(yyin);
fclose(yyout);
return 0;
}
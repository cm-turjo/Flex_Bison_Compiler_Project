%{
      #include<bits/stdc++.h>
      using namespace std;

      map<string,int>m2;//map to count variables;
         
      map<string,int>m1;//to count keywords and IDs
         
      map<string,int>::iterator it;//to iterate through map container
   
   //To Check variable validity and variable count

   bool checkvarvalidity( string s)
   {
    string st; int i;
    //extracting the variable from string
    for(i=6;s[i]==' ';i++);
        for(;;i++){
            if(s[i]=='='||s[i]==' ')break;
            st+=s[i];
        }
        bool flag=0;
        m2[st]++;
        if(m2[st]>1)
        {
            cout<<"Problem is At line "<<s<<endl;
            cout<<"This Variable is Declared Before Please Choose another Variable"<<endl;
            m2[st]--;
            return flag;
        }
        else
        {
            cout<<"Variable Declared Successfully"<<endl;
            flag=1;
            return flag;
            
        }
        
   }


   //To Check operator related error like uninitialized value
   bool checkoperator(string t)
   {
    bool flag=1;
    char c;
    string st;
    string s=t;
    for(int i=0;i<s.size();i++)
    {
        if((s[i]>='a'&& s[i]<='z')||(s[i]>='A'&&s[i]<='Z'))
        st+=s[i];
    }
   
  
    for(int i=0;i<st.size();i++)
    {
        char d=st[i];
        string ab(1,d);
        
        if(m2.find(ab)==m2.end())
        {
            flag=0;
            c=s[i];
            break;
        }
    }
    if(flag==0)
    {
        cout<<"There is a value "<<c<<" undeclared! Please declare this"<<endl;
        return flag;
    }
    return flag;

   }
   //to count the number of lines in the file
   int num_lines=1;

%}


variable [A-Za-z_]+[A-Za-z_0-9]*
Assignment {variable}[ ]*"<<"[ ]*({variable}|[0-9]+|[0-9]+[.][0-9]+|['].[']|["].*["])
Condition (=|!|<|>)"("({variable}|([0-9]+[.]*[0-9]*)),({variable}|([0-9]+[.]*[0-9]*))")"
post ("+"|"-")"("({variable}|([0-9]+[.]*[0-9]*)),("+"|"-")")"
pre ("+"|"-")"("("+"|"-"),({variable}|([0-9]+[.]*[0-9]*))")"


%%


"cholok"[ ]+{variable}[=]"intnum"[ ]*"<<"[ ]*[-]?[0-9]+([.][0-9]+)?                 {    cout<<endl;
                                                                                         printf("Integer ");
                                                                                         //check whether the variable is valid or not
                                                                                         bool res=checkvarvalidity(yytext);
                                                                                         //if valid the increase the count
                                                                                         if(res==1)
                                                                                         {
                                                                                         m1["cholok"]++;
                                                                                         m1["intnum"]++;
                                                                                         }
                                                                                         //checking if any wrong data is sent to this datatype
                                                                                         string t;
                                                                                         t=yytext;
                                                                                         for(int i=0;i<t.size();i++)
                                                                                         {
                                                                                         if(t[i]=='.')
                                                                                         {
                                                                                         cout<<endl;     
                                                                                         cout<<"Warning! You have assign improper data to variable"<<endl;
                                                                                         cout<<endl;
                                                                                         cout<<yytext<<endl;
                                                                                         cout<<"Issue Arised!"<<endl;
                                                                                         cout<<endl;
                                                                                         break;
                                                                                         }
                                                                                         }
                                                                                    }


"cholok"[ ]+{variable}[=]"longnum"[ ]*"<<"[ ]*[-]?[0-9]+([.][0-9]+)?                {
                                                                                        cout<<endl;
                                                                                        printf("Long ");
                                                                                        //check whether the variable the valid or not
                                                                                        bool res=checkvarvalidity(yytext);
                                                                                        if(res==1)
                                                                                        {
                                                                                        m1["cholok"]++;
                                                                                        m1["longnum"]++;
                                                                                        }
                                                                                        //if valid increase the count
                                                                                        string t;
                                                                                        t=yytext;
                                                                                        //to check whether the data contains improper value or not
                                                                                        for(int i=0;i<t.size();i++)
                                                                                        {
                                                                                        if(t[i]=='.')
                                                                                        {
                                                                                        cout<<endl;     
                                                                                        cout<<"Warning! You have assign improper data to this variable"<<endl;
                                                                                        cout<<yytext<<endl;
                                                                                        cout<<"Issue Arised!"<<endl;
                                                                                        cout<<endl;
                                                                                        break;
                                                                                        }
                                                                                        }
                                                                                    }

"cholok"[ ]+{variable}[=]"floatnum"[ ]*"<<"[ ]*[-]?[0-9]+([.][0-9]+)?               {
                                                                                        cout<<endl;
                                                                                        printf("Float ");
                                                                                        //check whether the variable the valid or not
                                                                                        bool res=checkvarvalidity(yytext);
                                                                                        if(res==1)
                                                                                        {
                                                                                        m1["cholok"]++;
                                                                                        m1["floatnum"]++;
                                                                                        }
                                                                                        
                                                                                        
                                                                                    }


"cholok"[ ]+{variable}[=]"doublenum"[ ]*"<<"[ ]*[-]?[0-9]+[.][0-9]+                 {
                                                                                        cout<<endl;
                                                                                        printf("Double ");
                                                                                        //check whether the variable the valid or not
                                                                                        bool res=checkvarvalidity(yytext);
                                                                                        if(res==1)
                                                                                        {
                                                                                        m1["cholok"]++;
                                                                                        m1["doublenum"]++;
                                                                                        }
                                                                                        
                                                                                    }

"cholok"[ ]+{variable}[=]"boolnum"[ ]*"<<"[ ]*(true|false|True|False)               {   cout<<endl;
                                                                                        printf("Boolean ");
                                                                                
                                                                                        //check whether the variable the valid or not
                                                                                        bool res=checkvarvalidity(yytext);
                                                                                        if(res==1)
                                                                                        {
                                                                                        m1["cholok"]++;
                                                                                        m1["boolnum"]++;
                                                                                        }
                                                                                        
                                                                                    }




"cholok"[ ]+{variable}[=]"charnum"[ ]*"<<"[ ]*['].[']                               {
                                                                                         printf("Character ");
                                                                                         //check whether the variable the valid or not
                                                                                         bool res=checkvarvalidity(yytext);
                                                                                         if(res==1)
                                                                                         {
                                                                                         m1["cholok"]++;
                                                                                         m1["charnum"]++;
                                                                                         }
                                                                                     
                                                                                        
                                                                                    }
"cholok"[ ]+{variable}[=]"stringnum"[ ]*"<<"[ ]*["].*["]                            {    cout<<endl;
                                                                                         printf("String ");
                                                                                         bool res=checkvarvalidity(yytext);
                                                                                         if(res==1)
                                                                                         {
                                                                                         m1["cholok"]++;
                                                                                         m1["stringnum"]++;
                                                                                         }

                                                                                    }  

"sthir ""cholok"[ ]+{variable}[=]"intnum"[ ]*"<<"[ ]*[-]?[0-9]+                     {   cout<<endl;
                                                                                        printf("Static Integer ");
                                                                                        //check whether the variable is valid or not
                                                                                        bool res=checkvarvalidity(yytext);
                                                                                        if(res==1)
                                                                                        {
                                                                                        m1["sthir cholok"]++;
                                                                                        m1["intnum"]++;
                                                                                        }
                                                                                        //if valid the increase the count
                                                                                        string t;
                                                                                        t=yytext;
                                                                                        for(int i=0;i<t.size();i++)
                                                                                        {
                                                                                        if(t[i]=='.')
                                                                                        {
                                                                                        cout<<endl;     
                                                                                        cout<<"Warning! You have assign improper data to variable"<<endl;
                                                                                        cout<<endl;
                                                                                        cout<<yytext<<endl;
                                                                                        cout<<"Issue Arised!"<<endl;
                                                                                        cout<<endl;
                                                                                        break;
                                                                                        }
                                                                                        }
                                                                                    } 

"sthir ""cholok"[ ]+{variable}[=]"longnum"[ ]*"<<"[ ]*[-]?[0-9]+                    {   cout<<endl;
                                                                                        printf("Static Long ");
                                                                                        //check whether the variable is valid or not
                                                                                        bool res=checkvarvalidity(yytext);
                                                                                        if(res==1)
                                                                                        {
                                                                                        m1["sthir cholok"]++;
                                                                                        m1["longnum"]++;
                                                                                        }
                                                                                        //if valid the increase the count
                                                                                        string t;
                                                                                        t=yytext;
                                                                                        for(int i=0;i<t.size();i++)
                                                                                        {
                                                                                        if(t[i]=='.')
                                                                                        {
                                                                                        cout<<endl;     
                                                                                        cout<<"Warning! You have assign improper data to variable"<<endl;
                                                                                        cout<<endl;
                                                                                        cout<<yytext<<endl;
                                                                                        cout<<"Issue Arised!"<<endl;
                                                                                        cout<<endl;
                                                                                        break;
                                                                                        }
                                                                                        }
                                                                                    }   


"sthir ""cholok"[ ]+{variable}[=]"floatnum"[ ]*"<<"[ ]*[-]?[0-9]+[.][0-9]+          {   cout<<endl;
                                                                                        printf("Static Long ");
                                                                                        //check whether the variable is valid or not
                                                                                        bool res=checkvarvalidity(yytext);
                                                                                        if(res==1)
                                                                                        {
                                                                                        m1["sthir cholok"]++;
                                                                                        m1["floatnum"]++;
                                                                                        }
                                                                                        //if valid the increase the count
                                                                                       
                                                                                    }  

"sthir ""cholok"[ ]+{variable}[=]"doublenum"[ ]*"<<"[ ]*[-]?[0-9]+[.][0-9]+        {
                                                                                        cout<<endl;
                                                                                        printf("Static Double ");
                                                                                        //check whether the variable the valid or not
                                                                                        bool res=checkvarvalidity(yytext);
                                                                                        if(res==1)
                                                                                        {
                                                                                        m1["sthir cholok"]++;
                                                                                        m1["doublenum"]++;
                                                                                        }
                                                                                        
                                                                                    }  

"sthir ""cholok"[ ]+{variable}[=]"boolnum"[ ]*"<<"[ ]*(true|false|True|False)     {     cout<<endl;
                                                                                        printf("Static Boolean ");
                                                                                
                                                                                        //check whether the variable the valid or not
                                                                                        bool res=checkvarvalidity(yytext);
                                                                                        if(res==1)
                                                                                        {
                                                                                        m1["sthir cholok"]++;
                                                                                        m1["boolnum"]++;
                                                                                        }
                                                                                        
                                                                                        } 

"sthir ""cholok"[ ]+{variable}[=]"charnum"[ ]*"<<"[ ]*['].[']                  {
                                                                                        printf("Static Character ");
                                                                                        //check whether the variable the valid or not
                                                                                        bool res=checkvarvalidity(yytext);
                                                                                        if(res==1)
                                                                                        {
                                                                                        m1["sthir cholok"]++;
                                                                                        m1["charnum"]++;
                                                                                        }
                                                                                     
                                                                                        
                                                                        } 

"sthir ""cholok"[ ]+{variable}[=]"stringnum"[ ]*"<<"[ ]*["].*["]       {                cout<<endl;
                                                                                        printf("Static String ");
                                                                                        bool res=checkvarvalidity(yytext);
                                                                                        if(res==1)
                                                                                        {
                                                                                        m1["sthir cholok"]++;
                                                                                        m1["stringnum"]++;
                                                                                        }

                                                                                        }


{variable}[ ]*"<<"[ ]*"+("({variable}|([0-9]+[.]*[0-9]*)),({variable}|([0-9]+[.]*[0-9]*))")"       {
                                                                                                    if(checkoperator(yytext))
                                                                                                    {
                                                                                                          printf("Summation Command Executed\n");
                                                                                                          m1["Summation Command"]++;

                                                                                                    }
                                                                                                  }  


{variable}[ ]*"<<"[ ]*"-("({variable}|([0-9]+[.]*[0-9]*)),({variable}|([0-9]+[.]*[0-9]*))")"      {
                                                                                                    if(checkoperator(yytext))
                                                                                                    {
                                                                                                          printf("Subtraction Command Executed\n");
                                                                                                          m1["Subtaction Command"]++;

                                                                                                    }
                                                                                                  } 

{variable}[ ]*"<<"[ ]*"*("({variable}|([0-9]+[.]*[0-9]*)),({variable}|([0-9]+[.]*[0-9]*))")"          {
                                                                                                    if(checkoperator(yytext))
                                                                                                    {
                                                                                                          printf("Multiplication Command Executed\n");
                                                                                                          m1["Multiplication Command"]++;

                                                                                                    }
                                                                                                  } 

{variable}[ ]*"<<"[ ]*"/("({variable}|([0-9]+[.]*[0-9]*)),({variable}|([0-9]+[.]*[0-9]*))")"        {
                                                                                                    if(checkoperator(yytext))
                                                                                                    {
                                                                                                          printf("Division Command Executed\n");
                                                                                                          m1["Division Command"]++;

                                                                                                    }
                                                                                                  } 

{variable}[ ]*"<<"[ ]*"%("({variable}|([0-9]+[.]*[0-9]*)),({variable}|([0-9]+[.]*[0-9]*))")"        {
                                                                                                    if(checkoperator(yytext))
                                                                                                    {
                                                                                                          printf("Modulus Command Executed\n");
                                                                                                          m1["Modulus Command"]++;

                                                                                                    }
                                                                                                  } 

"=("({variable}|([0-9]+[.]*[0-9]*)),({variable}|([0-9]+[.]*[0-9]*))")"                            {
                                                                                                    if(checkoperator(yytext))
                                                                                                    {
                                                                                                          printf("Equal Command Executed\n");
                                                                                                          m1["Equal Command"]++;

                                                                                                    }
                                                                                                  }

"!("({variable}|([0-9]+[.]*[0-9]*)),({variable}|([0-9]+[.]*[0-9]*))")"                             {
                                                                                                    if(checkoperator(yytext))
                                                                                                    {
                                                                                                          printf("Equal Command Executed\n");
                                                                                                          m1["Equal Command"]++;

                                                                                                    }
                                                                                                  }

"<("({variable}|([0-9]+[.]*[0-9]*)),({variable}|([0-9]+[.]*[0-9]*))")"                            {
                                                                                                    if(checkoperator(yytext))
                                                                                                    {
                                                                                                          printf("Smaller Than Command Executed\n");
                                                                                                          m1["Smaller Than Command"]++;

                                                                                                    }
                                                                                                  }

">("({variable}|([0-9]+[.]*[0-9]*)),({variable}|([0-9]+[.]*[0-9]*))")"                               {
                                                                                                    if(checkoperator(yytext))
                                                                                                    {
                                                                                                          printf("Greater Than Command Executed\n");
                                                                                                          m1["Greater Than Command"]++;

                                                                                                    }
                                                                                                  }

"+("({variable}|([0-9]+[.]*[0-9]*)),"+)"                                                             {
                                                                                                    if(checkoperator(yytext))
                                                                                                    {
                                                                                                          printf("Post Increment Command Executed\n");
                                                                                                          m1["Post Increment Command"]++;

                                                                                                    }
                                                                                                  }


"+(+",({variable}|([0-9]+[.]*[0-9]*))")"                                                           {
                                                                                                    if(checkoperator(yytext))
                                                                                                    {
                                                                                                          printf("Pre Increment Command Executed\n");
                                                                                                          m1["Pre Increment Command"]++;

                                                                                                    }
                                                                                                  }

"-("({variable}|([0-9]+[.]*[0-9]*)),"-)"                                                            {
                                                                                                    if(checkoperator(yytext))
                                                                                                    {
                                                                                                          printf("Post decrement Command Executed\n");
                                                                                                          m1["Post decrement Command"]++;

                                                                                                    }
                                                                                                  }

"-(-",({variable}|([0-9]+[.]*[0-9]*))")"                                                           {
                                                                                                    if(checkoperator(yytext))
                                                                                                    {
                                                                                                          printf("Pre decrement Command Executed\n");
                                                                                                          m1["Pre decrement Command"]++;

                                                                                                    }
                                                                                                  }

{variable}[ ]*"<<"[ ]*({variable}|[0-9]+|[0-9]+[.][0-9]+|['].[']|["].*["])"\n"                          {
                                                                                                    if(checkoperator(yytext))
                                                                                                    {
                                                                                                          printf("Assignment Command Executed\n");
                                                                                                          m1["Assignment Command"]++;

                                                                                                    }
                                                                                                  }

"forchokro""["[ ]*{Assignment}[ ]*,[ ]*{Condition}[ ]*,[ ]*({post}|{pre})[ ]*"]"[ ]*[\n]*"{"([ ]*[\n]*.*[ ]*[\n]*)*"}"        {printf("For Loop Declared\n");
                                                                                                                              string s;
                                                                                                                              s=yytext;
                                                                                                                              for(int i=0;i<s.size();i++)
                                                                                                                              {
                                                                                                                                    if(s[i]=='\n')num_lines++;
                                                                                                                              }
                                                                                                                              num_lines++;
                                                                                                                              
                                                                                                                            m1["For Loop"]++;}

"whilechokro""["[ ]*{Condition}[ ]*"]"[ ]*[\n]*"{"[ ]*[\n]*.*[ ]*[\n]*"}"                                                   {printf("While Loop Declared\n");
                                                                                                                                    string s;
                                                                                                                              s=yytext;
                                                                                                                              for(int i=0;i<s.size();i++)
                                                                                                                              {
                                                                                                                                    if(s[i]=='\n')num_lines++;
                                                                                                                              }
                                                                                                                              num_lines++;
                                                                                                                                m1["While Loop"]++;}

("jodi""["[ ]*{Condition}[ ]*"]"[ ]*[\n]*"{"[ ]*[\n]*.*[ ]*[\n]*"}""\n")("abarjodi""["[ ]*{Condition}[ ]*"]"[ ]*[\n]*"{"[ ]*[\n]*.*[ ]*[\n]*"}""\n")*("nahole"[ ]*[\n]*"{"[ ]*[\n]*.*[ ]*[\n]*"}""\n")*               {printf("If Else Declared\n");
                                                                                                                                                                                                                       string s;
                                                                                                                                                                                                                        s=yytext;
                                                                                                                                                                                                                        for(int i=0;i<s.size();i++)
                                                                                                                                                                                                                        {
                                                                                                                                                                                                                        if(s[i]=='\n')num_lines++;
                                                                                                                                                                                                                        
                                                                                                                                                                                                                        }
                                                                                                                                                                                                                        num_lines++;
                                                                                                                                                                                                                      }


"*?" {printf("Void\n");m1["Void"]++;}

"!!" {printf("Null\n");m1["null"]++;}

"motamot" {printf("return\n");m1["return"]++;}

"thamo" {printf("break\n");m1["break"]++;}

"choltethako" {printf("continue\n");m1["continue"]++;}

"somosto" {printf("Public\n");m1["Public"]++;}

"goponio" {printf("Private\n");m1["Private"]++;}

"rokkhito" {printf("Protected\n");m1["Protected"]++;}

"jog koro"[ ]*["[a-zA-Z0-9]+[.][h]"]"  {printf("Header File Added\n");m1["header file"]++;}
                                                                  


"@@".* {printf("Single Line Comment Found!\n");m1["comment"]++;}

"@!"({variable}|(\n)*|[ ]*)*"!@" {printf("Multi Line Comment Found\n");m1["comment"]++;}
\n {num_lines++;}

.+ {printf("SYNTAX ERROR\n");
    cout<<"Problem is at : "<<yytext<<" this line!"<<endl;}

%%
int yywrap(){
	return 1;
}

int main(){
   

    yyin = fopen("finaldemo.txt","r");
    

    yylex();
    cout<<endl;
    cout<<endl;
    cout<<endl;
   
    m2.erase("cholok");
    m1.erase("Operator Command");
    printf("To Check Keyword Count: \n\n");

    for(it=m1.begin();it!=m1.end();it++)
    {
          cout<<"Key-> "<<(*it).first<<" Count-> "<<(*it).second<<endl;
    }

    cout<<endl;
    cout<<"To check Variable Count: \n\n";
     
    for(it=m2.begin();it!=m2.end();it++)
    {
         cout<<"Variable-> "<<(*it).first<<" Count-> "<<(*it).second<<endl;
    }
    cout<<endl;

    cout<<"Total Number of lines: "<<num_lines<<endl;
    cout<<"All Status Checked!"<<endl;
	return 0;
}
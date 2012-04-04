//
// A collection of functions that tests the compiler
// for compilance with C--'s semantics.
// Written by Antoine Delignat-Lavaud, ENS Cachan, in 2008.
//

int i; int k;

int rule_31()
{
 int i; i = 5;
 throw E(42);
 printf("ERROR !\n");
}

int rule_32_1()
{
 int j;
 try
 {
  j = 5;
 }
 finally
 {
  if(j == 5) j = 3;
  else j = 2;
 }

 if(j == 3) printf("  [+] Rule 32 : p' |- c' => p'' ... OK\n");
 else if(j == 2) printf(" [x] Variable environment is not passed in the finally in regard to rule 32 !\n");
 else printf(" [x] Local variables in try{} blocks are incorrectly handled !\n");
 return 0;
}

int rule_32_2()
{
 try
 {
  0 + 0;
 }
 finally
 {
  return 1;
 }
 return 0;
}

int rule_32_3()
{
 try{
 }
 finally
 {
  throw R32(10);
 }
 return 1;
}

int rule_33()
{
 try{return 1;}finally{i=99;}
 return 0;
}

int rule_34()
{
 try{return 0;}finally{return 42;}
}

int rule_36()
{
 try{throw E(6);}finally{i=66;}
}

int rule_37_1()
{
 try{throw E(1);}
 finally{return 1;}
}

int rule_37_2()
{
 try{throw E(1);}
 finally{throw F(1);}
}

int rule_39(int u, int v)
{
 try{ throw Ex(9); }
 catch(Bla u){}
 catch(Nope v){}
 catch(Ex x)
 {
  if(u==1) i=v;
  if(u==2) throw E1(x);
  if(u==3) return v;
 }
 finally
 {
  if(v==1) k=u;
  if(v==2) throw E2(u);
  if(v==3) return u;
 }
 return 1;
}

int main()
{
 int j; int g; int h; int tot;
 printf("Starting Testsuite for C--, see Goubault's webpage for semantics references.\n");
 printf("============================================================\n");
 printf("          ++ Testing basic compiler features ++\n");
 printf("============================================================\n");
 printf(" [o] Testing conditional blocks ...\t\t");
 if(1) printf("OK.\n"); else exit("ERROR !\n");
 printf(" [o] Testing local and global variables ... \t");
 if(variables()) return printf("ERROR !\n");
 printf("OK.\n [o] Testing compare operators ...\t\t");
 if(test_comp()) exit(printf("ERROR !\n"));
 printf("OK.\n [o] Testing binary operators ... \n");
 test_op();
 printf(" [o] Testing loops ...\t\t\t\t");
 for(j=0;j++<3;);
 if(j==4) printf("OK.\n");
 else return printf("ERROR !\n");
 printf("============================================================\n");
 printf("                ++ Testing exceptions ++\n");
 printf("============================================================\n");
 printf(" [o] Testing rule 31 ...\t\t\t");
 try{int i; i=3; rule_31(); printf("ERROR !\n");}
 catch(E x){if(x==42) printf("OK.\n"); else printf("ERROR !\n");}
 printf(" [o] Testing rule 32 ...\n");
 rule_32_1();
 if(rule_32_2()) printf("  [+] Rule 32 : p' |- c' => (p'', *, V) ... OK\n");
 else printf("  [x] Returning in a finally when no error has occured fails !\n");
 try{
  if(rule_32_3()) printf("  [x] Raising an exception in finally when none was raised in try fails !\n");
 }
 catch(R32 x){
  if(x==10)  printf("  [+] Rule 32 : p' |- c' => (p'', Exc, V) ... OK\n");
  else printf("  [x] Exception argument not propagated in rule 32.\n");
 }
 printf(" [o] Testing rule 33 ...\t\t\t");
 if(rule_33()==1 && i==99) printf("OK.\n"); else printf("ERROR !\n");
 printf(" [o] Testing rule 34 ...\t\t\t");
 if(rule_34()==42) printf("OK.\n"); else printf("ERROR !\n");
 printf(" [o] Testing rule 36 ...\t\t\t");
 try{rule_36();printf("ERROR !\n");}
 catch(E j){if(j==6 && i==66) printf("OK.\n"); else printf("ERROR !\n");}
 printf(" [o] Testing rule 37 ...\n");
 try{if(rule_37_1()) printf("  [+] Rule 37 : p |- c' => (p', *, V) ... OK\n");}
 catch(E x){printf("  [x] Wrong implementation of rule 37 !\n");}
 try{rule_37_2();}
 catch(E x){printf("  [x] Wrong implementation of rule 37 !\n");}
 catch(F j){if(j==1) printf("  [+] Rule 37 : p |- c' => (p', Exc, V) ... OK\n");}
 printf(" [o] Testing rule 39 ...\n");

 tot = 1;
 for(g=1; g <= 3; g++)
 {
  for(h=1; h <= 3; h++)
  {
   try{
     i = 0; k = 0;
     j = rule_39(g,h);
     if(j==1 && g == 1 && h == 1 && i==1 && k == 1)
      printf("  [+] %d/9 : p[] |- c1 => p' |- c' => p'' ... OK.\n", tot);
     else if(j==1 && g==1 && h==3 && i == 3 && k == 0)
      printf("  [+] %d/9 : p[] |- c1 => p' |- c' => (p'',*,V) ... OK\n", tot);
     else if(g==3 && i==0 && k==0)
     {
      if(j==h)
       printf("  [+] %d/9 : p[] |- c1 => (p',*,V) |- c' => (p',*,V) ... OK\n", tot);
      else
       printf("  [x] Error : Return value should not have been changed in finally clause !\n",g,h);
     }
     else printf("  [x] Error : execution unexpectedly continued : (%d,%d)\n",g,h);
   }
   catch(E1 V){
    if(g == 2 && i == 0 && k == 0 && V == 9){
     if(h==1) printf("  [+] %d/9 : p[] |- c1 => (p', Exc, V) |- c' => (p', Exc, V) ... OK.\n", tot);
     if(h==2) printf("  [+] %d/9 : p[] |- c1 => (p', Exc, V) |- c' => (p', Exc, V) ... OK.\n", tot);
     if(h==3) printf("  [+] %d/9 : p[] |- c1 => (p', Exc, V) |- c' => (p', Exc, V) ... OK.\n", tot);
    }else printf(" [x] Error : Unexpectedly caught exception E1 : (%d,%d)\n",g,h);
   }
   catch(E2 V){
     if(g==1 && h==2 && i == 2 && k == 0 && V == 1)
      printf("  [+] %d/9 : p[] |- c1 => p' |- c' => (p'', Exc, V) ... OK\n", tot);
     else printf("  [x] Error : Unexpectedly caugth exception E2 : (%d,%d)\n",g,h);
   }
   finally{
    if(tot == 9){
    printf("============================================================\n");
    printf(" Congratulations, you have not segfaulted yet !\n");
    printf(" We'll raise an uncaught exception now.\n");
    printf(" Your program should crash gracefully.\n");
    printf("============================================================\n");
    throw All_test_successfull(0);
    } tot++;
   }
  }
 }
 printf("============================================================\n");
 printf("  Sorry, your compiler has bugs. Fix them and try again !\n");
 printf("============================================================\n");
}

int test_comp()
{
 int i;
 char *s;
 i = 2;
 if(i==2) 0;
 else return 1;
 if(i<3) 0;
 else return 1;
 if(i>1) 0;
 else return 1;
 if(i != 0) 0;
 else return 1;
 s = (i==2 ? 0 : 1 );
 return s;
}

int test_op()
{
 int i; int t;
 i = 0; t = 0;
 if(i++ == 0 && i == 1){ t=t+1; printf("  [+] Post increment OK\n");}
 if(i-- == 1 && i == 0){ t=t+1; printf("  [+] Post decrement OK\n");}
 if(++i == 1 && i == 1){ t=t+1; printf("  [+] Pre increment OK\n");}
 if(--i == 0 && i == 0){ t=t+1; printf("  [+] Pre decrement OK\n");}

 if(t != 4) exit(printf(" [x] Some tests failed ! Check your increment/decrement operators.\n"));
 i = malloc(8); t=0;
 i[0] = 5; i[1] = 9;

 if(i[0]++ == 5 && i[0] == 6){t++; printf("  [+] Post increment array OK\n");}
 if(i[1]-- == 9 && i[1] == 8){t++; printf("  [+] Post decrement array OK\n");}
 if(++i[0] == 7 && i[0] == 7){t++; printf("  [+] Pre increment array OK\n");}
 if(--i[1] == 7 && i[1] == 7){t++; printf("  [+] Pre decrement array OK\n");}

 if(t!=4) exit(printf(" [x] Some tests failed ! Check your increment/decrement operators.\n"));
 t=0;

 if(13 % 5 == 3){t++; printf("  [+] Modulo OK\n");}
 if(7+5 == 12){t++; printf("  [+] Sum OK\n");}
 if(-4 * 23 == -92){t++; printf("  [+] Product OK\n");}
 if(7/3 == 2){t++; printf("  [+] Quotient OK\n");}
 if(!0){t++; printf("  [+] Negation OK\n");}
 if(12-5 == 7){t++; printf("  [+] Substract OK\n");}

 if(t != 6) printf(" [x] Some tests failed ! Check your binary operators.\n");
 return 0;
}

int zer()
{ return i=0;}
int inci()
{ return ++i;}

int variables()
{
 int i;
 i = 3;
 zer();

 {
 int i; i=5; 
 if(i!=5) return 1;
 }
 if(i != 3) return 1;
 if(inci() != 1 || inci() != 2) return 1;
 return 0;
}
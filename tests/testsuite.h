//
// A collection of functions that tests the compiler
// for compilance with C--'s semantics.
// Written by Antoine Delignat-Lavaud, ENS Cachan, in 2008.
// Modifed by Guillaume DAVY, ENS Cachan, in 2011.
//

int i; int k;

int zer(){ return i=0;}
int inci(){ return ++i;}

int variables()
{
	int i;
	i = 3;
	zer();
	{
		int i; i=5; 
		if(i!=5) return -1;
	}
	if(i != 3) return -2;
	if(inci() != 1 || inci() != 2) return -3;
	return 0;
}

int test_comp()
{
	int i, s;
	
	i = 2;
	if(i==2) 0; else return -1;
	if(i<3) 0; else return -2;
	if(i>1) 0; else return -3;
	if(i != 0) 0; else return 4;
	s = (i==2 ? 0 : -5 );
	return s;
}

int test_op()
{
	int i, t;
	int *j;
	
	t = 0;
	i = 0;
	if(i++ == 0 && i == 1) t=t+1;
	if(i-- == 1 && i == 0) t=t+1;
	if(++i == 1 && i == 1) t=t+1;
	if(--i == 0 && i == 0) t=t+1;
	if(t != 4) return -1;
	
	t=0;
	j = malloc(8);
	j[0] = 5; j[1] = 9;
	if(j[0]++ == 5 && j[0] == 6) t++;
	if(j[1]-- == 9 && j[1] == 8) t++;
	if(++j[0] == 7 && j[0] == 7) t++;
	if(--j[1] == 7 && j[1] == 7) t++;
	if(t!=4) return -2;
	
	t=0;
	if(13 % 5 == 3) t++;
	if(7+5 == 12) t++;
	if(-4 * 23 == -92) t++;
	if(7/3 == 2) t++;
	if(!0) t++;
	if(12-5 == 7) t++;
	if(t != 6) return -3;
	
	return 0;
}

int i; int k;

int rule_31()
{
	int i;
	i = 5;
	throw E(42);
	return -1;
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
		if(j == 5)
			j = 3;
		else
			j = 2;
	}
	
	if(j == 3)
		return 0;
	else if(j == 2)
		return -1;
	else
		return -2;
	
	return -3;
}

int rule_32_2()
{
	try
	{
		0 + 0;
	}
	finally
	{
		return 0;
	}
	return -1;
}

int rule_32_3()
{
	try
	{
		
	}
	finally
	{
		throw R32(10);
	}
	return -1;
}

int rule_33()
{
	try
	{
		return 1;
	}
	finally
	{
		i=99;
	}
	return 0;
}

int rule_34()
{
	try
	{
		return 0;
	}
	finally
	{
		return 42;
	}
}

int rule_36()
{
	try
	{
		throw E(6);
	}
	finally
	{
		i=66;
	}
}

int rule_37_1()
{
	try
	{
		throw E(1);
	}
	finally
	{
		return 1;
	}
}

int rule_37_2()
{
	try{
		throw E(1);
	}
	finally
	{
		throw F(1);
	}
}

int rule_39(int u, int v)
{
	try{
		throw Ex(9);
	}
	catch(Bla u){}
	catch(Nope v){}
	catch(Ex x)
	{
		if(u==1)
			i=v;
		if(u==2)
			throw E1(x);
		if(u==3)
			return v;
	}
	finally
	{
		if(v==1)
			k=u;
		if(v==2)
			throw E2(u);
		if(v==3)
			return u;
	}
	return 1;
}

int testSuite()
{
	int r;
	printf("Test suite :\t");
	
	if(0)
	{
		printf("Failed (conditionnal block)\n");
		exit(0);
	}
	
	r = variables();
	if (r)
	{
		printf("Failed (Variables : %i)\n", r);
		exit(0);
	}
	
	r = test_comp();
	if (r)
	{
		printf("Failed (Comparaisons : %i)\n", r);
		exit(0);
	}
	
	r = test_op();
	if (r)
	{
		printf("Failed (Operateur : %i)\n", r);
		exit(0);
	}
	
	for(r=0;r++<3;);
	if(r!=4)
	{
		printf("Failed (Boucle)\n");
		exit(0);
	}
	printf("Success\n");
}


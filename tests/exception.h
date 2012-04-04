
int recursif(int n)
{
	if (n==0)
	{
		throw Except(42)
	}
	recursif(n-1);
}

int pouressayerdegagner(int n)
{
	for (i=0;i<n;i++)
	{
		try
		{
			throw monexpetiontreslongueparcequefairedesstrlencestlongetcapermetdetestersivousgererdeschainestreslonguez(42)
		}
		catch(monexpetiontreslongueparcequefairedesstrlencestlongetcapermetdetestersivousgererdeschainestreslonguea x)
		{return -1;}
		catch(monexpetiontreslongueparcequefairedesstrlencestlongetcapermetdetestersivousgererdeschainestreslongueb x)
		{return -1;}
		catch(monexpetiontreslongueparcequefairedesstrlencestlongetcapermetdetestersivousgererdeschainestreslonguec x)
		{return -1;}
		catch(monexpetiontreslongueparcequefairedesstrlencestlongetcapermetdetestersivousgererdeschainestreslongued x)
		{return -1;}
		catch(monexpetiontreslongueparcequefairedesstrlencestlongetcapermetdetestersivousgererdeschainestreslonguef x)
		{return -1;}
		catch(monexpetiontreslongueparcequefairedesstrlencestlongetcapermetdetestersivousgererdeschainestreslongueg x)
		{return -1;}
		catch(monexpetiontreslongueparcequefairedesstrlencestlongetcapermetdetestersivousgererdeschainestreslongueh x)
		{return -1;}
		catch(monexpetiontreslongueparcequefairedesstrlencestlongetcapermetdetestersivousgererdeschainestreslonguei x)
		{return -1;}
		catch(monexpetiontreslongueparcequefairedesstrlencestlongetcapermetdetestersivousgererdeschainestreslonguej x)
		{return -1;}
		catch(monexpetiontreslongueparcequefairedesstrlencestlongetcapermetdetestersivousgererdeschainestreslonguek x)
		{return -1;}
		catch(monexpetiontreslongueparcequefairedesstrlencestlongetcapermetdetestersivousgererdeschainestreslonguel x)
		{return -1;}
		catch(monexpetiontreslongueparcequefairedesstrlencestlongetcapermetdetestersivousgererdeschainestreslonguem x)
		{return -1;}
		catch(monexpetiontreslongueparcequefairedesstrlencestlongetcapermetdetestersivousgererdeschainestreslonguen x)
		{return -1;}
		catch(monexpetiontreslongueparcequefairedesstrlencestlongetcapermetdetestersivousgererdeschainestreslongueo x)
		{return -1;}
		catch(monexpetiontreslongueparcequefairedesstrlencestlongetcapermetdetestersivousgererdeschainestreslonguep x)
		{return -1;}
		catch(monexpetiontreslongueparcequefairedesstrlencestlongetcapermetdetestersivousgererdeschainestreslongueq x)
		{return -1;}
		catch(monexpetiontreslongueparcequefairedesstrlencestlongetcapermetdetestersivousgererdeschainestreslonguer x)
		{return -1;}
		catch(monexpetiontreslongueparcequefairedesstrlencestlongetcapermetdetestersivousgererdeschainestreslongues x)
		{return -1;}
		catch(monexpetiontreslongueparcequefairedesstrlencestlongetcapermetdetestersivousgererdeschainestreslonguet x)
		{return -1;}
		catch(monexpetiontreslongueparcequefairedesstrlencestlongetcapermetdetestersivousgererdeschainestreslongueu x)
		{return -1;}
		catch(monexpetiontreslongueparcequefairedesstrlencestlongetcapermetdetestersivousgererdeschainestreslonguev x)
		{return -1;}
		catch(monexpetiontreslongueparcequefairedesstrlencestlongetcapermetdetestersivousgererdeschainestreslonguew x)
		{return -1;}
		catch(monexpetiontreslongueparcequefairedesstrlencestlongetcapermetdetestersivousgererdeschainestreslonguex x)
		{return -1;}
		catch(monexpetiontreslongueparcequefairedesstrlencestlongetcapermetdetestersivousgererdeschainestreslonguey x)
		{return -1;}
		catch(monexpetiontreslongueparcequefairedesstrlencestlongetcapermetdetestersivousgererdeschainestreslonguez x)
		{}
	}
	return 42;
}

int imbrication()
{
	int i;
	i=0;
	try{
	try{try{try{try{try{try{try{try{try{try{
	try{try{try{try{try{try{try{try{try{try{
	try{try{try{try{try{try{try{try{try{try{
	try{try{try{try{try{try{try{try{try{try{
	throw last(2);
	}finally{i++;}}finally{i++;}}finally{i++;}}finally{i++;}}finally{i++;}
	}finally{i++;}}finally{i++;}}finally{i++;}}finally{i++;}}finally{i++;}
	}finally{i++;}}finally{i++;}}finally{i++;}}finally{i++;}}finally{i++;}
	}finally{i++;}}finally{i++;}}finally{i++;}}finally{i++;}}finally{i++;}
	}finally{i++;}}finally{i++;}}finally{i++;}}finally{i++;}}finally{i++;}
	}finally{i++;}}finally{i++;}}finally{i++;}}finally{i++;}}finally{i++;}
	}finally{i++;}}finally{i++;}}finally{i++;}}finally{i++;}}finally{i++;}
	}finally{i++;}}finally{i++;}}finally{i++;}}finally{i++;}}finally{i++;}
	}
	catch(last x)
	{
		return i+x;
	}
	return -1;
}

int imbrication2()
{
	int i;
	int j;
	i = 678;
	j = 345;
	try
	{
		int i;
		i = 5;
		j = j + 1;
		throw E 7;
	}
	catch (E x)
	{
		if (i!=678)
			return -3;
		if (j!=346)
			return -4;
		{
			int j;
			j = 42;
			i = i + 2;
		}
	}
	finally
	{
		int k;
		k = 43;
		if (i!=680)
			return -5;
		if (j!=346)
			return -6;
		{
			int i;
			i = 16;
			j = j + 4;
		}
		try
		{
			i = i + 1;
		}
		finally
		{
			if (i!=681)
				return -9;
			if (j!=350)
				return -10;
			{
				int j;
				j = 9;
				i = i + 9;
				k = 62;
			}
		}
		if (k!=62)
			return  -11;
	}
	if (i!=690)
		return -7;
	if (j!=350)
		return -8;

	try
	{
		try
		{
			throw E 42;
		}
		catch (E x)
		{
			return -12;
		}
	}
	finally
	{
		return 42;
	}

	return -13;
}

int pourRomain()
{
	try
	{
		throw err 42;
	}
	finally
	{
		int *a;
		a = malloc(4);
		a[1] = 15*18/10+15;
		if (a[1] == 42)
			printf("Exception :\tSuccess");
		else
			printf("Exception :\tFailed(operation ?? )");
	}
}
int exception()
{
	int y;
	y=0;
	try
	{
		recursif(250000);
	}
	catch(Except x)
	{
		y = x;
	}
	if (y != 42)
	{
		printf("Exception :\tFailed(recursif %i)\n", y);
		return;
	}

	y = pouressayerdegagner(10000);
	if (y != 42)
	{
		printf("Exception :\tFailed(Mouhahaha %i)\n", y);
		return;
	}

	y = imbrication();
	y = y + imbrication2();
	if (y != 84)
	{
		printf("Exception :\tFailed(imbrication %i)\n", y);
		return;
	}
	try
	{
		pourRomain();
	}
	catch (err x)
	{
		printf("\n");
		return;
	}
	printf(" Ou pas\n");
}


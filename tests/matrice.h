int matrice()
{
	int i, j;
	int *t;
	int **a;
	a = malloc(10*SIZEOF(int*));
	for (i=0;i<10;i++)
	{
		a[i] = malloc(10*SIZEOF(int));
		for (j=0;j<10;j++)
		{
			t = a[i];
			t[j] = 42;
		}
	}
	for (i=0;i<10;i++)
	{
		for (j=0;j<10;j++)
		{
			if (a[i][j] != 42)
			{
				printf("Matrice : Fail\n");
			}
		}
	}
	printf("Matrice : Success\n");
	for (i=0;i<10;i++)
		free(a[i]);
	free(a);
}

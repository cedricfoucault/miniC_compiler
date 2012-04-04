#define MAXM 10
#define MAXN 1000000

int **a;

int malloc_a()
{
	int i,j;
	int *t;
	a = malloc(MAXM*SIZEOF(int*));
	for (i=0;i<MAXM;i++)
	{
		t = a[i] = malloc(MAXN*SIZEOF(int));
		for (j=0;j<MAXN;j++)
			t[j] = -1;
	}
}

int free_a()
{
	int i;
	for (i=0;i<MAXM;i++)
		free(a[i]);
	free(a);
}

int ack(int m, int n,int i)
{
	int r;
	int *t;
	
	if (m >= MAXM)
	{
		printf("M depasse\n");
		exit(0);
	}
	if (n >= MAXN)
	{
		printf("N depasse\n");
		exit(0);
	}
	t = a[m];
	if (t[n] != -1)
		return a[m][n];
	
	if (m == 0)
	{
		r = n+1;
	}
	else
	{
		if (n==0)
			r = ack(m-1,1,i);
		else
			r = ack(m-1,ack(m,n-1,i+1),i);
	}
	
	t[n] = r;
	return r;
}

int ackermann()
{
	int r;
	malloc_a();
	r = ack(4,1,0);
	if (r == 65533)
		printf("Ackermann : Success\n");
	else
		printf("Ackermann : Fail (%i)\n",r);
	free_a();
}

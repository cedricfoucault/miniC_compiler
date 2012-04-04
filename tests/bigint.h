#define SIZE 20
#define BASE 100000000

int *new()
{
	return malloc(SIZE*SIZEOFINT);
}

int* big(int a)
{
	int *n;
	int i;
	
	n = new();
	for (i=0;i<SIZE;i++)
	{
		n[i] = a % BASE;
		a = a / BASE;
	}
	
	return n;
}

int *add(int* a, int *b)
{
	int *n;
	int i;
	int r;
	int t;
	
	r=0;
	n = new();
	for (i=0;i<SIZE;i++)
	{
		t = a[i] + b[i] + r;
		n[i] = t % BASE;
		r = t / BASE;
	}
	
	return n;
}

int *mul(int* a, int *b)
{
	int *n;
	int i;
	
	/*
	n = big(0);
	for (i=big(0);i<big;i++)
		add(a,n);
	return n;
	*/
}

int inf(int *a,int *b)
{
	int i;
	int g;
	g=0;
	for (i=SIZE-1;i>=0;i--)
	{
		if (a[i] < b[i])
		{
			return 1;
		}
	}
	return 0;
}

int *poww(int* a, int *b)
{
	int *n;
	int *i;
	
	n = big(1);
	for (i=big(0);inf(i,b);i=add(i,big(1)))
		mul(n,a);
	
	return n;
}

int print(int *a)
{
	int i;
	for (i=SIZE-1;i>=0;i--)
		printf("%.8i",a[i]);
}

int bigInt()
{
	print(poww(big(2),big(32)));
	printf("\n");
}


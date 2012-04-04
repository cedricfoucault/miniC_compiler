int f(int r) {
	int k; k = 0;
	try {
		try {
			try {
				throw Exn 42;
			}
			catch (Exn x) {
				int m;
				m = x * x;
				k = m + 3 * x;
				return m + k + r;
			}
			finally {
				puts("Erreur: le finally ne doit pas s'exécuter en cas de return dans le catch.");
			}
		}
		finally {
			printf("%d == 1890 ", k);
            throw Danstapomme 0;
		}
	}
	finally {
		printf("&& ");
		if (!(r % 2))
			return r * k;
	}
	return -1;
}
int main()
{
    try {
        printf("%d == 3695\n", f(41));
    } catch (Danstapomme n) {
        printf("Danstapomme rattrapée");
    }
	printf("%d == 79380\n", f(42));
	return 0;
}

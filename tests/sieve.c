#ifdef MCC
#define NULL 0
#else
#include <stdio.h>
#include <stdlib.h>
#endif

int main (int argc, char **argv)
{
  if (argc!=2)
    {
      fprintf (stderr, "Usage: ./sieve <n>\ncalcule et affiche les nombres premiers inferieurs a <n>.\n");
      fflush (stderr);
      exit (10); /* non mais! */
    }
  {
    int n;
    int *bits;

    n = atoi (argv[1]); // conversion chaine -> entier.
    if (n<2)
      {
	fprintf (stderr, "Ah non, quand meme, un nombre >=2, s'il-vous-plait...\n");
	fflush (stderr);
	exit (10);
      }
    bits = malloc (4*n); // allouer de la place pour n entiers (booleens).
    // Ca prend 32 fois trop de place.  Mais C-- n'a pas les operations &, |,
    // qui nous permettraient de manipuler des bits individuellement...
    if (bits==NULL)
      {
	fprintf (stderr, "%d est trop gros, je n'ai pas assez de place memoire...\n");
	fflush (stderr);
	exit (10);
      }
    zero_sieve (bits, n);
    bits[0] = bits[1] = 1;
    fill_sieve (bits, n);
    print_sieve (bits, n);
    free (bits); // et on libere la place memoire allouee pour bits[].
  }
  return 0;
}

int zero_sieve (int *bits, int n)
{
  int i;

  for (i=0; i<n; i++)
    bits[i] = 0;
  return 0;
}

int fill_sieve (int *bits, int n)
{
  int last_prime;

  for (last_prime = 2; last_prime<n; )
    {
      cross_out_prime (bits, n, last_prime);
      while (++last_prime<n && bits[last_prime]);
    }
  return 0;
}

int cross_out_prime (int *bits, int n, int prime)
{
  int delta;

  for (delta = prime; (prime = prime + delta) < n; )
    bits[prime] = 1;
  return 0;
}

int print_sieve (int *bits, int n)
{
  char *delim;
  int i;
  int k;
  char *buf;

  printf ("Les nombres premiers inferieurs a %d sont:\n", n);
  delim = "  ";
  k = 0;
  for (i=0; i<n; i++)
    {
      if (bits[i]==0)
	{
	  printf ("%s%8d", delim, i);
	  if (++k>=4)
	    {
	      printf ("\n"); // retour à la ligne.
	      k = 0;
	      delim = "  ";
	    }
	  else
	    printf (" "); // espace.
	}
    }
  fflush (stdout); // on vide le tampon de stdout, utilise par printf().
  return 0;
}

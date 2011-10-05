#ifdef MCC
#define NULL 0
#else
#include <stdio.h>
#include <stdlib.h>
#endif

int f (int n, int i)
{
  if (i==0)
    throw Zero (n);
  if (i==1)
    throw Trouve (n);
  if (i%2)
    return f (n+1, 3*i+1);
  else return f (n+1, i/2);
}

int main (int argc, char **argv)
{
  int j;

  if (argc!=2)
    {
      fprintf (stderr, "Usage: ./exc1 <n>\ncalcule a quelle iteration une suite mysterieuse termine, en partant de <n>.\n");
      fflush (stderr);
      exit (10); /* non mais! */
    }
  j = atoi (argv[1]);
  try {
    f (0, j);
    fprintf (stderr, "Pas trouve...\n");
  }
  catch (Trouve n) {
    fprintf (stderr, "La suite termine apres %d iterations en partant de %d.\n", n, j);
  }
  fflush (stderr);
  return 0;
}

#ifdef MCC
#define NULL 0
#else
#include <stdio.h>
#include <stdlib.h>
#endif

/* teste si un return dans un bloc try engendre bien le comportement désiré
 * (les clauses finally internes à la fonction doivent être exécutées) */

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
    if (j<0) {
        fprintf (stderr, "Pas trouve...\n");
        return 0;
    }
    else
      f (0, j);
  }
  catch (Trouve n) {
    fprintf (stderr, "La suite termine apres %d iterations en partant de %d.\n", n, j);
  }
  catch (Zero n) {
    fprintf (stderr, "Le nombre d'entree est nul.\n");
  }
  finally {
    fprintf (stderr, "*Fin* (ce message doit toujours s'afficher).\n");
  }
  fflush (stderr);
  return 0;
}

#ifdef MCC
#define FILE char
// pipeau: un FILE est quelque chose de plus complique, normalement...
#define EOF (-1)
// ca, par contre, c'est la vraie valeur de EOF.

#else
#include <stdio.h>
#include <stdlib.h>
#endif

int main (int argc, char **argv)
{
  int i, c;

  for (i=1; i<argc; i++)
    {
      FILE *f;

      f = fopen (argv[i], "r");
      while ((c = fgetc (f))!=EOF)
	fputc (c, stdout);
      fclose (f);
    }
  fflush (stdout);
  exit (0);
}

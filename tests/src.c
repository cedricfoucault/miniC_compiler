#ifdef MCC
#define NULL 0
#define SIZEOF(a) 4
#else
#include <stdio.h>
#include <stdlib.h>
#define SIZEOF(a) sizeof(a)
#endif

#include "testsuite.h"
#include "matrice.h"
#include "ackermann.h"
#include "exception.h"

int main (int argc, char **argv)
{
	testSuite();
	matrice();
	ackermann();
	exception();
	return 0;
}

#include <math.h>
#include <stdio.h>

int main()
{
  int i;
  double a,b,c;

  printf("-------------------------------------\n");
  printf("| A second order recurrent sequence |\n");
  printf("-------------------------------------\n");

  a = 5.5;
  b = 61./11.;
  for(i=2;i<=30;i++){
    c = b;
    b = 111. - 1130./b + 3000./(a*b);
    a = c;
    printf("U(%d) = %+.15e\n",i,b);
  }
  return 0;
}


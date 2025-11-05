#include <math.h>
#include <stdio.h>
#include <cadna.h>

int main()
{
  cadna_init(-1);
  int i;
  double_st a,b,c;

  printf("-------------------------------------\n");
  printf("| A second order recurrent sequence |\n");
  printf("-------------------------------------\n");

  a = 5.5;
  b = 61./11.;
  for(i=2;i<=30;i++){
    c = b;
    b = 111. - 1130./b + 3000./(a*b);
    a = c;
    printf("U(%d) = %s\n",i,strp(b));
  }

  cadna_end();
  return 0;
}


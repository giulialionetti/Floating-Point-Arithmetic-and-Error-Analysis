#include <math.h>
#include <stdio.h>
#include <cadna.h>

int main()
{
  cadna_init(-1);
  int i, nmax=100;
  double_st y, x, diff, eps=1.e-12; 
  printf("-------------------------------------------------------------\n");
  printf("|  Computation of a root of a polynomial by Newton's method |\n");
  printf("-------------------------------------------------------------\n");
  
  y = 0.5;
  for(i = 1;x!=y;i++){
    x = y;
    y = x-(1.47*pow(x,3)+1.19*pow(x,2)-1.83*x+0.45)/
      (4.41*pow(x,2)+2.38*x-1.83);
    diff = fabs(x-y);
    printf("x(%3d) = %s, diff = %s\n", i, strp(y), strp(diff));     
    if (diff<eps) break;
  }
  cadna_end();
  return 0;
}

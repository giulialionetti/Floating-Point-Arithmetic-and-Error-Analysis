#include <math.h>
#include <stdio.h>

int main()
{
  int i, nmax=100;
  double y, x, diff, eps=1.e-12; 
  printf("-------------------------------------------------------------\n");
  printf("|  Computation of a root of a polynomial by Newton's method |\n");
  printf("-------------------------------------------------------------\n");
  
  y = 0.5;
  for(i = 1;i<=nmax;i++){
    x = y;
    y = x-(1.47*pow(x,3)+1.19*pow(x,2)-1.83*x+0.45)/
      (4.41*pow(x,2)+2.38*x-1.83);
    diff = fabs(x-y);
    printf("x(%3d) = %.14e, diff = %.2e\n", i, y, diff);     
    if (diff<eps) break;
  }
  return 0;
}

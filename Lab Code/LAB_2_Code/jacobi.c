#include <math.h>
#include <stdio.h>

static int  nrand;

float random1()
{
  nrand = (nrand*5363 + 143) % 1387;
  return((float)(2.0*nrand/1387.0 - 1.0));
}

int main()
{
  
  // const float eps = 1.e-4;
  // const float eps = 1.e-3;  // ε = 0.001
  // const float eps = 5.e-3;  // ε = 0.005  
  const float eps = 1.e-2;  // ε = 0.01
  const int ndim = 20, niter = 1000;

  float a[ndim][ndim];
  float b[ndim];
  float x[ndim];
  float y[ndim];
  float xsol[]={  1.7, -4746.89, 50.23, -245.32,
		       4778.29, -75.73, 3495.43, 4.35,
		       452.98, -2.76, 8239.24, 3.46,
		       1000.0, -5.0, 3642.4, 735.36,
		       1.7, -2349.17, -8247.52, 9843.57 };
  int i, j, k;
  float aux, anorm;
  nrand = 23;
  printf("-----------------------------------------------------------\n");
  printf("|                 Jacobi iteration                        |\n");
  printf("-----------------------------------------------------------\n");
  
 
  for(i=0;i<ndim;i++){
    for (j=0;j<ndim;j++){
          a[i][j] = random1();
    }
    a[i][i] = a[i][i] + 4.500002;
  }
  for (i=0;i<ndim;i++){
    aux = 0.0;
    for (j=0;j<ndim;j++)
      aux = aux + a[i][j]*xsol[j];
    b[i] = aux;
    y[i] = 10.0;
  }

  for (i=1;i<=niter;i++){
    anorm = 0.0;
    for (j=0;j<ndim;j++)  x[j] = y[j];
        
    for (j=0;j<ndim;j++){
      aux = b[j];
      for (k=0;k<ndim;k++) 
	if (k!=j) aux = aux - a[j][k]*x[k];
      y[j] = aux/a[j][j];
      if (fabsf(x[j]-y[j])>anorm) anorm = fabsf(x[j]-y[j]);
    }
    if (anorm<eps) break;
  }
  printf("niter = %d\n",i-1);

  for (i=0;i<ndim;i++){
    aux = -b[i];
    for (j=0;j<ndim;j++)
      aux = aux + a[i][j]*y[j];
    printf("x_sol(%2d) = %+.6e (correct value: %+.6e), error(%2d) = %+.6e\n",i,y[i],xsol[i],i,aux);    
  }
  return 0;
}

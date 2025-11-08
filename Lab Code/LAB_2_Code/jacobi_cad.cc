#include <math.h>
#include <stdio.h>
#include <cadna.h>

static int nrand;

float random1()
{
  nrand = (nrand*5363 + 143) % 1387;
  return((float)(2.0*nrand/1387.0 - 1.0));
}

int main()
{
  cadna_init(-1);
  // const float eps = 1.e-2;  // ε = 0.01
  // const float eps = 5.e-3;  // ε = 0.005  
  // const float eps = 1.e-3;  // ε = 0.001
  const float eps = 1.e-4; 
  const int ndim = 20, niter = 1000;

  float_st a[ndim][ndim];
  float_st b[ndim];
  float_st x[ndim];
  float_st y[ndim];
  float_st xsol[] = { 1.7, -4746.89, 50.23, -245.32,
                      4778.29, -75.73, 3495.43, 4.35,
                      452.98, -2.76, 8239.24, 3.46,
                      1000.0, -5.0, 3642.4, 735.36,
                      1.7, -2349.17, -8247.52, 9843.57 };
  int i, j, k;
  float_st aux, anorm;
  
  nrand = 23;
  printf("-----------------------------------------------------------\n");
  printf("|                 Jacobi iteration                        |\n");
  printf("-----------------------------------------------------------\n");
  
  // Inizializza matrice A
  for(i=0; i<ndim; i++){
    for(j=0; j<ndim; j++){
      a[i][j] = random1();
    }
    a[i][i] = a[i][i] + 4.500002;
  }
  
  // Calcola b e inizializza y
  for(i=0; i<ndim; i++){
    aux = 0.0;
    for(j=0; j<ndim; j++)
      aux = aux + a[i][j]*xsol[j];
    b[i] = aux;
    y[i] = 10.0;
  }

  // Iterazione di Jacobi
  for(i=1; i<=niter; i++){
    anorm = 0.0;
    for(j=0; j<ndim; j++) x[j] = y[j];
        
    for(j=0; j<ndim; j++){
      aux = b[j];
      for(k=0; k<ndim; k++) 
        if(k!=j) aux = aux - a[j][k]*x[k];
      y[j] = aux/a[j][j];
      if(fabs(x[j]-y[j]) > anorm) anorm = fabs(x[j]-y[j]);
    }
    
    // Test di convergenza migliorato
    if(anorm < eps || anorm == 0.0) {
      if(anorm == 0.0)
        printf("WARNING: Reached numerical precision limit at iter %d\n", i);
      else
        printf("Converged to tolerance at iter %d\n", i);
      break;
    }
  }  // ✓ Parentesi graffa mancante aggiunta!
  
  printf("\nniter = %d\n", i-1);
  printf("Final anorm = %s\n", strp(anorm));
  printf("eps = %.1e\n\n", eps);

  // Stampa risultati
  for(i=0; i<ndim; i++){
    aux = -b[i];
    for(j=0; j<ndim; j++)
      aux = aux + a[i][j]*y[j];
    printf("x_sol(%2d) = %s (correct value: %s), error(%2d) = %s\n",
           i, strp(y[i]), strp(xsol[i]), i, strp(aux));    
  }
  
  cadna_end();
  return 0;
}
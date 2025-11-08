#include <cadna.h>
#include <stdio.h>
#include <math.h>

#define IDIM 4

int main()
{
  cadna_init(-1);
  
  float_st a[IDIM][IDIM+1]={
    {  21.0, 130.0,       0.0,    2.1,  153.1},
    {  13.0,  80.0,   4.74e+8,  752.0, 849.74},
    {   0.0,  -0.4, 3.9816e+8,    4.2, 7.7816},
    {   0.0,   0.0,       1.7, 9.0E-9, 2.6e-8}};

  float_st xsol[IDIM]={1., 1., 1.e-8, 1.};

  printf("------------------------------------------------------\n");
  printf("| Solving a linear system using Gaussian elimination |\n");
  printf("| with partial pivoting                              |\n");
  printf("------------------------------------------------------\n");
  
  int i,j,k,ll;
  float_st pmax, aux;

  // ============ FORWARD ELIMINATION ============
  for(i=0; i<IDIM-1;i++){
    
    // Trova pivot
    pmax = 0.0;
    for(j=i; j<IDIM;j++){
      if(fabs(a[j][i])>pmax){
        pmax = fabs(a[j][i]);
        ll = j;
      }
    }
    
    printf("\n=== Step %d: Pivot selection ===\n", i);
    printf("Pivot max = %s at row %d\n", strp(pmax), ll);
    
    // Scambia righe se necessario
    if (ll!=i) {
      printf("Swapping rows %d and %d\n", i, ll);
      for(j=i; j<IDIM+1;j++){ 
        aux = a[i][j];
        a[i][j] = a[ll][j];
        a[ll][j] = aux;
      }
    }
    
    // Normalizza riga pivot
    aux = a[i][i];
    printf("Pivot element a[%d][%d] = %s\n", i, i, strp(aux));
    for(j=i+1; j<IDIM+1;j++)
      a[i][j] = a[i][j]/aux;
    
    // Eliminazione
    for (k=i+1;k<IDIM;k++){
      aux = a[k][i];
      printf("Multiplier for row %d: %s\n", k, strp(aux));
      for(j=i+1;j<IDIM+1;j++)
        a[k][j]=a[k][j] - aux*a[i][j];
    }
    
    // Stampa matrice dopo questo step
    printf("\nMatrix after step %d:\n", i);
    for(int row=0; row<IDIM; row++){
      for(int col=0; col<IDIM+1; col++)
        printf("%s ", strp(a[row][col]));
      printf("\n");
    }
  }

  // ============ BACK SUBSTITUTION ============
  printf("\n=== Back substitution ===\n");
  
  a[IDIM-1][IDIM] = a[IDIM-1][IDIM]/a[IDIM-1][IDIM-1];
  printf("x[%d] = %s / %s = %s\n", IDIM-1, 
         strp(a[IDIM-1][IDIM]), strp(a[IDIM-1][IDIM-1]), strp(a[IDIM-1][IDIM]));
  
  for(i=IDIM-2;i>=0;i--){
    printf("\nComputing x[%d]:\n", i);
    printf("Starting value: %s\n", strp(a[i][IDIM]));
    for(j=i+1;j<IDIM;j++){
      printf("  Subtracting a[%d][%d] * x[%d] = %s * %s\n", 
             i, j, j, strp(a[i][j]), strp(a[j][IDIM]));
      a[i][IDIM] = a[i][IDIM] - a[i][j]*a[j][IDIM];
    }
    printf("Final x[%d] = %s\n", i, strp(a[i][IDIM]));
  }
  
  // ============ RESULTS ============
  printf("\n=== Final results ===\n");
  for(i=0;i<IDIM;i++)
    printf("xsol(%d) = %s (exact solution: xsol(%d)= %s)\n",
           i, strp(a[i][IDIM]), i, strp(xsol[i]));

  cadna_end();
  return 0;  
}
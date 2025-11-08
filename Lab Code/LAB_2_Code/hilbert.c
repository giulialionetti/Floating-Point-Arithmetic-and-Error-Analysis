#include <stdio.h>
#include <math.h>

int main()
{
  double amat[11][11];
  int i,j,k;
  double aux, det;

  printf("----------------------------------------------------------\n");
  printf("|      determinant of Hilbert’s matrix of size 11         |\n");
  printf("----------------------------------------------------------\n");

  for(i=1;i<=11;i++)
    for(j=1;j<=11;j++)
      amat[i-1][j-1] = 1./(double)(i+j-1);
  
  det = 1.;

  for(i=0;i<10;i++){
    printf("Pivot %3d   = %+.15e\n",i,amat[i][i]);
    det = det*amat[i][i];
    aux = 1./amat[i][i];
    for(j=i+1;j<11;j++)
      amat[i][j] = amat[i][j]*aux;
    
    for(j=i+1;j<11;j++){
      aux = amat[j][i];
      for(k=i+1;k<11;k++)
	amat[j][k] = amat[j][k] - aux*amat[i][k];
    }
  }
  printf("Pivot %3d   = %+.15e\n",i,amat[i][i]);
  det = det*amat[i][i];
  printf("Determinant = %+.15e\n",det);
  return 0;
}

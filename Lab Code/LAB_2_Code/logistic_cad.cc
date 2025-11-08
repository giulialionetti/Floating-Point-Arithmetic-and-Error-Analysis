#include <cadna.h>
#include <stdio.h>
#include <math.h>

int main(){
  cadna_init(-1);
  
  double_st x, x_old, a;
  int i = 0;
  
  printf("-----------------------------\n");
  printf("|  Logistic iteration       |\n");
  printf("-----------------------------\n");
  
  a = 3.6;
  
  // ========== PRIMA FORMULA ==========
  printf("\n=== First formula: x = a*x*(1-x) ===\n");
  x = 0.6;
  i = 0;
  
  do {
    x_old = x;
    x = a*x*(1-x);
    i = i+1;
    
    if (!(i%50)) printf("i=%3d x=%s\n", i, strp(x));
    
    // Stopping criterion: x diventa non significativo o non cambia più
    if (x == 0.0 || x == x_old) {
      printf("STOPPED at iteration %d: x=%s\n", i, strp(x));
      if (x == 0.0)
        printf("  Reason: x lost all significant digits\n");
      else
        printf("  Reason: x no longer changes (numerical stagnation)\n");
      break;
    }
  }  
  while (i < 200);
  
  if (i == 200) 
    printf("Reached max iterations. Last x=%s\n", strp(x));
  
  // ========== SECONDA FORMULA ==========
  printf("\n=== Second formula: x = a*0.25 - a*(x-0.5)^2 ===\n");
  x = 0.6;
  i = 0;
  
  do {
    x_old = x;
    x = a*0.25 - a*pow((x-0.5), 2);
    i = i+1;
    
    if (!(i%50)) printf("i=%3d x=%s\n", i, strp(x));
    
    // Stopping criterion
    if (x == 0.0 || x == x_old) {
      printf("STOPPED at iteration %d: x=%s\n", i, strp(x));
      if (x == 0.0)
        printf("  Reason: x lost all significant digits\n");
      else
        printf("  Reason: x no longer changes (numerical stagnation)\n");
      break;
    }
  }  
  while (i < 200);
  
  if (i == 200)
    printf("Reached max iterations. Last x=%s\n", strp(x));
  
  cadna_end();
  return 0;
}
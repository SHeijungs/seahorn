/* based on example at https://www.guru99.com/malloc-in-c-example.html */

#include <stdlib.h>
#include <stdio.h>

int main(){
  int *ptr;
  int *ptr2;
  ptr = malloc(15 * sizeof(*ptr)); /* a block of 15 integers */
  ptr2 = malloc(12 * sizeof(*ptr2)); /* a block of 15 integers */
  if (ptr != NULL && ptr2 != NULL) {
    free(ptr);
    free(ptr2);
  }
}

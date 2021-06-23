/* based on example at https://www.guru99.com/malloc-in-c-example.html */

#include <stdlib.h>
#include <stdio.h>

int main(){
  int *ptr;
  ptr = malloc(15 * sizeof(*ptr)); /* a block of 15 integers */
  if (ptr != NULL) {
    *(ptr + 5) = 480; /* assign 480 to sixth integer */
    printf("Value of the 6th integer is %d\n",*(ptr + 5));
    free(ptr);
    free(ptr);
  }
}

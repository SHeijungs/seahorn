/* based on example at https://www.guru99.com/malloc-in-c-example.html */

#include <stdlib.h>
#include <stdio.h>

int main(){
  int *ptr;
  int *ptr2;
  ptr = malloc(15 * sizeof(*ptr)); /* a block of 15 integers */
  ptr2 = malloc(12 * sizeof(*ptr2)); /* a block of 15 integers */
  if (ptr != NULL && ptr2 != NULL) {
    *(ptr + 5) = 480; /* assign 480 to sixth integer */
    *(ptr2 + 3) = 13;
    printf("Value of the 6th integer is %d\n",*(ptr + 5));
    printf("Value of the 3rd integer in second array is %d\n",*(ptr2 + 3));
    free(ptr2);
    free(ptr2);
  }
}

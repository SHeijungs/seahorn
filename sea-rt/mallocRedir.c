#include <stdlib.h>

char *__seahorn_UAF_malloc_redir(size_t size){
  return malloc(size);
}

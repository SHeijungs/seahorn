#include "seahorn/seahorn.h"
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/mman.h>
#include <string.h> 
const uint64_t __seahorn_UAF_HEAP_SIZE=1LL<<16; //SeaHorn can reason about absurdly large arrays. 
char __seahorn_UAF_heap[__seahorn_UAF_HEAP_SIZE];
uint64_t __seahorn_UAF_firstFree=0;
extern bool __seahorn_UAF_nondet();
/*based on implementations from https://git.busybox.net/uClibc/tree/libc/stdlib/malloc-simple/alloc.c*/

char *__seahorn_UAF_malloc(size_t size){
	char *result;
	if(size == 0)
	  return NULL;
	if (__seahorn_UAF_nondet()) {
		/*As per the specification malloc can fail at any time.
		We model this non-deterministically*/
		return NULL;
	}
  if(size>__seahorn_UAF_HEAP_SIZE-__seahorn_UAF_firstFree-sizeof(size_t))
  /*safely check whether we have enough memory.*/
    return NULL;
  result=&__seahorn_UAF_heap[__seahorn_UAF_firstFree];
  __seahorn_UAF_firstFree+=size+sizeof(size_t);
	* (size_t *) result = size;
	return(result + sizeof(size_t));
}

char *__seahorn_UAF_calloc(size_t nmemb, size_t lsize)
{
	char *result;
	size_t size = lsize*nmemb;

	/* guard vs integer overflow, but allow nmemb
	 * to fall through and call malloc(0) */
	if(nmemb&&lsize != (size/nmemb)){
		return NULL;
	}
	result = __seahorn_UAF_malloc(size);/*
	if (result != NULL) { // either slows down the analysis too much or gets turned into memset by the compiler
		for(char *i=result; i<result+size; ++i)
		  *i=0;
	}*/
	return result;
}

void __seahorn_UAF_free(char*ptr){
  if (ptr == NULL)
		return;
	ptr -= sizeof(size_t);
	sassert(* (size_t *) ptr!=0);
	*(size_t *)ptr = 0;
}

char *__seahorn_UAF_realloc(void *ptr, size_t size)
{
	void *newptr = NULL;

	if(!ptr)
		return __seahorn_UAF_malloc(size);
	if(!size){
		__seahorn_UAF_free(ptr);
		return __seahorn_UAF_malloc(0);
	}

	newptr = __seahorn_UAF_malloc(size);
	if(newptr){
		size_t old_size = *((size_t *) (ptr - sizeof(size_t)));
		memcpy(newptr, ptr, (old_size < size ? old_size : size));
		__seahorn_UAF_free(ptr);
	}
	return newptr;
}

void __seahorn_UAF_use_prehook(char*ptr){
  //printf("using address %p\n", ptr);
	//if(ptr < &__seahorn_UAF_heap[0] || ptr > &__seahorn_UAF_heap[__seahorn_UAF_HEAP_SIZE-1])
	ptr -= sizeof(size_t);
	sassert(* (size_t *) ptr!=0);
}

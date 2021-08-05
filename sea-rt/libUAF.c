#include "seahorn/seahorn.h"
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/mman.h>
#include <string.h> 
const size_t __seahorn_UAF_HEAP_SIZE=1LL<<20; //SeaHorn can reason about absurdly large arrays. 
const size_t __seahorn_MAX_ALLOCATIONS=100;
char __seahorn_UAF_heap[__seahorn_UAF_HEAP_SIZE];
size_t __seahorn_UAF_heap_sizes[__seahorn_MAX_ALLOCATIONS];
char __seahorn_UAF_shadow_heap[__seahorn_UAF_HEAP_SIZE];
uint64_t __seahorn_UAF_firstFree=0;
size_t __seahorn_allocationCount=0;
char* __seahorn_allocationStarts[__seahorn_MAX_ALLOCATIONS];
extern bool __seahorn_UAF_nondet(void);
extern char *__seahorn_UAF_nondet_ptr(void);
/*based on implementations from https://git.busybox.net/uClibc/tree/libc/stdlib/malloc-simple/alloc.c*/
char *__seahorn_UAF_malloc_redir(size_t size);
bool __seahorn_UAF_active=0;
char *__seahorn_UAF_bgn;
char *__seahorn_UAF_end;
bool __seahorn_UAF_freed=0;

void __seahorn_UAF_init(void){
  __seahorn_UAF_bgn=__seahorn_UAF_nondet_ptr();
  __seahorn_UAF_end=__seahorn_UAF_nondet_ptr();
}

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

char *__seahorn_UAF_malloc2(size_t size){ 
	char *result;

  if(size==0)
    return NULL;
  /*safely check whether we have enough memory.*/
  assume(size<=__seahorn_UAF_HEAP_SIZE-__seahorn_UAF_firstFree);
  result=&__seahorn_UAF_heap[__seahorn_UAF_firstFree];
  __seahorn_UAF_heap_sizes[__seahorn_UAF_firstFree]=size;
  for(int i=0;i<size;++i){
	  __seahorn_UAF_shadow_heap[__seahorn_UAF_firstFree+i]=1;
	}
  __seahorn_UAF_firstFree+=size;
	return(result);
}

char *__seahorn_UAF_malloc3(size_t size){ 
	char *result;

  if(size==0)
    return NULL;
  assume(size<__seahorn_UAF_HEAP_SIZE-__seahorn_UAF_firstFree);
  assume(__seahorn_allocationCount<__seahorn_MAX_ALLOCATIONS);
  result=&__seahorn_UAF_heap[__seahorn_UAF_firstFree];
  __seahorn_UAF_heap_sizes[__seahorn_allocationCount]=1;
  __seahorn_allocationStarts[__seahorn_allocationCount]=result;
  __seahorn_UAF_firstFree+=size;
  ++__seahorn_allocationCount;
  __seahorn_allocationStarts[__seahorn_allocationCount]=NULL;
  printf("memory allocated at address %p\n", result);
	return(result);
}

char * __seahorn_UAF_malloc4(size_t size){
  assume(size<__seahorn_UAF_HEAP_SIZE-__seahorn_UAF_firstFree);
  /*char *result;
  result=&__seahorn_UAF_heap[__seahorn_UAF_firstFree];
  __seahorn_UAF_firstFree+=size;
  */
  char *result=__seahorn_UAF_malloc_redir(size);
  if(!__seahorn_UAF_active&&__seahorn_UAF_nondet()){
    __seahorn_UAF_active=1;
    assume(__seahorn_UAF_bgn==result);
    assume(__seahorn_UAF_end=result+size);
  } else {
    assume(result<__seahorn_UAF_bgn);
  }
	return result;
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

void __seahorn_UAF_free2(char*ptr){
  if (ptr == NULL)
		return;
	//ptr -= sizeof(size_t);
	size_t index = ptr-__seahorn_UAF_heap;
	size_t size=__seahorn_UAF_heap_sizes[index];
	sassert(size!=0);
	for(int i=0;i<size;++i){
	  sassert(__seahorn_UAF_shadow_heap[index+i]!=0);
	  __seahorn_UAF_shadow_heap[index+i] = 0;
	}
}

void __seahorn_UAF_free3(char*ptr){
  printf("freeing memory at address %p\n", ptr);
  if (ptr == NULL)
		return;
  int index=0;
  while((size_t)ptr>=(size_t)__seahorn_allocationStarts[index]&&index<__seahorn_allocationCount){
    ++index;
  }
  --index;
	sassert(ptr==__seahorn_allocationStarts[index]);
	size_t size=__seahorn_UAF_heap_sizes[index];
	sassert(size!=0);
	__seahorn_UAF_heap_sizes[index]=0;
}

void __seahorn_UAF_free4(char*ptr){
  if(__seahorn_UAF_active&&ptr==__seahorn_UAF_bgn){
    assume(ptr<=__seahorn_UAF_end);
    sassert(!__seahorn_UAF_freed);
    __seahorn_UAF_freed=true;
  }
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

void __seahorn_UAF_use_prehook2(char*ptr){ 
  //printf("using address %p\n", ptr);
	//if(ptr < &__seahorn_UAF_heap[0] || ptr > &__seahorn_UAF_heap[__seahorn_UAF_HEAP_SIZE-1])
	sassert(__seahorn_UAF_shadow_heap[ptr-__seahorn_UAF_heap]!=0);
}

void __seahorn_UAF_use_prehook3(char*ptr){
  printf("using address %p\n", ptr);
  unsigned int index=0;
  bool t=0;
  while((size_t)ptr>=(size_t)__seahorn_allocationStarts[index]&&index<__seahorn_allocationCount){
    ++index;
    t=1;
  }
  sassert(t);
  --index;
  size_t size=__seahorn_UAF_heap_sizes[index];
	sassert(size!=0);
}

void __seahorn_UAF_use_prehook4(char*ptr){
  if(__seahorn_UAF_active&&ptr>=__seahorn_UAF_bgn&ptr<=__seahorn_UAF_end){
    assume(ptr<=__seahorn_UAF_end);
    sassert(!__seahorn_UAF_freed);
  }
}

void __seahorn_UAF_memset_fake(char *str, char c, size_t n, bool x){
  __seahorn_UAF_use_prehook4(str);
}

void __seahorn_UAF_memset_real(char *str, char c, size_t n, bool x){
  __seahorn_UAF_use_prehook4(str);
  for(int i=0;i<n;++i)
    str[i]=c;
}

void __seahorn_UAF_memcpy_fake(char *str, char *str2, size_t n, bool x){
  __seahorn_UAF_use_prehook4(str);
  __seahorn_UAF_use_prehook4(str2);
}

void __seahorn_UAF_memcpy_real(char *str, char *str2, size_t n, bool x){
  __seahorn_UAF_use_prehook4(str);
  __seahorn_UAF_use_prehook4(str2);
  for(int i=0;i<n;++i)
    str[i]=str2[i];
}

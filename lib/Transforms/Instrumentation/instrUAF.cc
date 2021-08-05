/* based on tutorial at https://www.cs.cornell.edu/~asampson/blog/llvm.html*/

#include "llvm/Pass.h"
#include "llvm/Transforms/Instrumentation.h"
#include "llvm/Transforms/Utils/BasicBlockUtils.h"
#include "llvm/Transforms/IPO/PassManagerBuilder.h"
#include <vector>
#include <stack>
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/InstIterator.h"
#include "llvm/IR/InstrTypes.h"
#include "llvm/Support/CommandLine.h"

using namespace llvm;

cl::opt<bool> doubleFreeOnly ("doubleFreeOnly", cl::desc("Only check for double free bugs, not use-after-free."));
cl::opt<bool> moveStackAllocs ("moveStackAllocs", cl::desc("Move all stack allocations to the heap"));
cl::opt<bool> replaceMemset ("replaceMemset", cl::desc("Replace memset and memcpy calls with code that simulates the memory use. Currently only for version 4"));


enum bitWidthEnum {
  m32, m64
};

enum versionEnum {
  UAF1, UAF2, UAF3, UAF4
};

/*enum memsetWidthEnum {
  memset, m64
};*/

cl::opt<bitWidthEnum> bitWidth(cl::desc("Choose the bit width:"),
  cl::values(
    clEnumVal(m32, "32 bits"),
    clEnumVal(m64, "64 bits")
  )
);

cl::opt<versionEnum> UAFversion(cl::desc("Choose instrumentation version:"),
  cl::values(
    clEnumVal(UAF1, "Version 1"),
    clEnumVal(UAF2, "Version 2"),
    clEnumVal(UAF3, "Version 3"),
    clEnumVal(UAF4, "Version 4")
  )
);

namespace {
  struct instrUAF : public ModulePass {
    static char ID;
    instrUAF() : ModulePass(ID) {}
    private:
    //BuilderTy builder;
    Instruction *toRemove;
    Function *use_prehook;
    Function *instrumentedMalloc;
    Function *mallocPostHook;
    Function *instrumentedFree;
    Function *instrumentedMemset;
    Function *instrumentedMemcpy;
    void instrumentUse(Value *ptr, IRBuilder<> builder){
      if(isa<Constant>(ptr))
        return;
      auto *ArgPtr=builder.CreateBitCast(ptr, builder.getInt8PtrTy());
      //errs() << ArgPtr << "\n";
      builder.CreateCall(use_prehook, ArgPtr);
    }
    
    CallInst *instrumentAlloca(AllocaInst *AI, IRBuilder<> builder, Module &M){
      Type *allocatedType=AI->getAllocatedType();
      DataLayout layout(&M);
      int typeSize = layout.getTypeAllocSize(allocatedType);
      //errs() << "\ntype size: " << typeSize << "\n";
      CallInst *callInst;
      if(bitWidth==m32){
        FunctionType *ft=FunctionType::get(builder.getInt8PtrTy(), builder.getInt32Ty(), false);
        callInst = builder.CreateCall(ft, instrumentedMalloc, ConstantInt::get(M.getContext(), APInt(32, typeSize, 10)));
      } else {
        FunctionType *ft=FunctionType::get(builder.getInt8PtrTy(), builder.getInt64Ty(), false);
        callInst = builder.CreateCall(ft, instrumentedMalloc, ConstantInt::get(M.getContext(), APInt(64, typeSize, 10)));
      }
      Value *castedCall;
      if(allocatedType == builder.getInt8Ty()) //typecast if a different type is needed
        castedCall = callInst;
      else
        castedCall = builder.CreateBitCast(callInst, allocatedType->getPointerTo());
      AI->replaceAllUsesWith(castedCall);
      toRemove=AI;
      return callInst;
    }
    
    void freeStackVariables(IRBuilder<> builder, std::stack<CallInst*> &freeList){
      while(!freeList.empty()){
        CallInst* allocedVar = freeList.top();
        freeList.pop();
        builder.CreateCall(instrumentedFree, allocedVar);
      }
    }
    
    public:
    int instrumentFunction(Function &F, Module &M){
      toRemove=NULL;
      //errs() << "Instrumenting function" << F.getName(); 
      std::stack<CallInst*> freeList;
      for (auto i = inst_begin(F), e = inst_end(F); i != e; ++i) {
        if(toRemove){
          toRemove->removeFromParent();
          toRemove=NULL;
        }
        Instruction *I = &*i;
        IRBuilder<> builder(I);
        builder.SetInsertPoint(I);
        
        if(!doubleFreeOnly){
          if (LoadInst *LI = dyn_cast<LoadInst>(I)) {
            instrumentUse(LI->getPointerOperand(), builder);
          }
        
          else if(StoreInst *SI = dyn_cast<StoreInst>(I)){
            instrumentUse(SI->getPointerOperand(), builder);
          }
        }
        if(moveStackAllocs){
          if(AllocaInst *AI = dyn_cast<AllocaInst>(I)) { //we want to move all allocations to the heap so we can analyse them using our shadow memory
            freeList.push(instrumentAlloca(AI, builder, M));
          }
          else if(ReturnInst *RI = dyn_cast<ReturnInst>(I)) {
            freeStackVariables(builder, freeList);
          }
        }
      }
      if(toRemove){
        toRemove->removeFromParent();
        toRemove=NULL;
      }
      return 0;
    }
    virtual bool runOnModule(Module &M) {
      unsigned version;
      DataLayout layout(&M);
      switch(UAFversion){
        case UAF1:
          instrumentedMalloc = M.getFunction("__seahorn_UAF_malloc");
          use_prehook = M.getFunction("__seahorn_UAF_use_prehook");
          instrumentedFree = M.getFunction("__seahorn_UAF_free");
          printf("using version 1\n");
          break;
        case UAF2:
          instrumentedMalloc = M.getFunction("__seahorn_UAF_malloc2");
          use_prehook = M.getFunction("__seahorn_UAF_use_prehook2");
          instrumentedFree = M.getFunction("__seahorn_UAF_free2");
          printf("using version 2\n");
          break;
        case UAF3:
          instrumentedMalloc = M.getFunction("__seahorn_UAF_malloc3");
          use_prehook = M.getFunction("__seahorn_UAF_use_prehook3");
          instrumentedFree = M.getFunction("__seahorn_UAF_free3");
          printf("using version 3\n");
          break;
        case UAF4:
          instrumentedMalloc = M.getFunction("__seahorn_UAF_malloc4");
          use_prehook = M.getFunction("__seahorn_UAF_use_prehook4");
          instrumentedFree = M.getFunction("__seahorn_UAF_free4");
          printf("using version 4\n");
          break;
        default:
          printf("unknown version\n");
          break;
      }
      //mallocPostHook = M.getFunction("__seahorn_UAF_mallocPostHook");
      instrumentedMemset = M.getFunction("__seahorn_UAF_memset_fake");
      instrumentedMemcpy = M.getFunction("__seahorn_UAF_memcpy_fake");
      if(Function *malloc = M.getFunction("malloc")){
        malloc->replaceAllUsesWith(instrumentedMalloc);
        malloc->eraseFromParent();
      }
      if(replaceMemset){
        if(Function *memset = M.getFunction("llvm.memset.p0i8.i32")){
          memset->replaceAllUsesWith(instrumentedMemset);
          memset->eraseFromParent();
        }
        if(Function *memset = M.getFunction("llvm.memset.p0i8.i64")){
          memset->replaceAllUsesWith(instrumentedMemset);
          memset->eraseFromParent();
        }
        if(Function *memcpy = M.getFunction("llvm.memcpy.p0i8.p0i8.i32")){
          memcpy->replaceAllUsesWith(instrumentedMemcpy);
          memcpy->eraseFromParent();
        }
        if(Function *memcpy = M.getFunction("llvm.memcpy.p0i8.p0i8.i64")){
          memcpy->replaceAllUsesWith(instrumentedMemcpy);
          memcpy->eraseFromParent();
        }
      }
      /*if(Function *calloc = M.getFunction("calloc"))
        calloc->replaceAllUsesWith(M.getFunction("__seahorn_UAF_calloc"));
      if(Function *realloc = M.getFunction("realloc"))
        realloc->replaceAllUsesWith(M.getFunction("__seahorn_UAF_realloc"));*/
      if(Function *free = M.getFunction("free")){
        free->replaceAllUsesWith(instrumentedFree);
        free->eraseFromParent();
      }
      //use_prehook = M.getFunction("__seahorn_UAF_use_prehook");
      for (auto& F : M) {
        if(!F.getName().startswith("__seahorn")){ //don't instrument our own instrumentation functions
          //if(F.getName().startswith("llvm."))
            //errs()<<F.getName()<<"\n";
          if(UAFversion==UAF4&&F.getName().startswith("main")){
            auto i = inst_begin(F);
            Instruction *I = &*i;
            IRBuilder<> builder(I);
            builder.CreateCall(M.getFunction("__seahorn_UAF_init"));
          }
          instrumentFunction(F, M);
        }
      }
      return true;
    }
  };
}

namespace seahorn {
Pass *createUAFPass() {
  return new instrUAF();
}
} // namespace seahorn

char instrUAF::ID = 0;

static RegisterPass<instrUAF> X("instrUAF", "instrument for detection of UAF and double free bugs",
                             false /* Only looks at CFG */,
                             false /* Analysis Pass */);

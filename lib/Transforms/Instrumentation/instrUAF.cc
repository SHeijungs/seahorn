/* based on tutorial at https://www.cs.cornell.edu/~asampson/blog/llvm.html*/

#include "llvm/Pass.h"
#include "llvm/Transforms/Instrumentation.h"
#include "llvm/Transforms/Utils/BasicBlockUtils.h"
#include "llvm/Transforms/IPO/PassManagerBuilder.h"

using namespace llvm;

namespace {
  struct instrUAF : public ModulePass {
    static char ID;
    instrUAF() : ModulePass(ID) {}
    private:
    virtual bool runOnModule(Module &M) {
      if(Function *malloc = M.getFunction("malloc"))
        malloc->replaceAllUsesWith(M.getFunction("__seahorn_UAF_malloc"));
      if(Function *calloc = M.getFunction("calloc"))
        calloc->replaceAllUsesWith(M.getFunction("__seahorn_UAF_calloc"));
      if(Function *realloc = M.getFunction("realloc"))
        realloc->replaceAllUsesWith(M.getFunction("__seahorn_UAF_realloc"));
      if(Function *free = M.getFunction("free"))
        free->replaceAllUsesWith(M.getFunction("__seahorn_UAF_free")); 
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

# Writing a Pass
In this section, we will be going over a few example MEMOIR passes, including analysis and transformation.

MEMOIR is built atop the LLVM compiler infrastructure, we will assume _some_ knowledge of writing LLVM passes.
If you need more information about LLVM you can start with their <a href=https://llvm.org/docs/WritingAnLLVMPass.html target="_blank">writing an LLVM pass guide</a>.

Additionally, MEMOIR makes use of NOELLE abstractions, for more information about NOELLE, <a href=https://github.com/arcana-lab/noelle target="_blank">see their repository</a>.

## _Example:_ Counting MEMOIR Instructions
Let's start off with the simplest example, count MEMOIR instructions in a program.

For this example, you will need to include the following header:
```cpp
#include <memoir/ir/Instructions.hpp>
```
This header includes the definition of MEMOIR instructions and methods to analyze them within an LLVM pass.

Let's implement our `runOnModule` method:
```cpp
bool runOnModule(llvm::Module &M) override {
    // We will keep track of MEMOIR instructions with this:
    uint32_t memoir_inst_count = 0;

    // Analyze the program.
    for (llvm::Function &F : M) {
        for (llvm::BasicBlock &BB : F) {
            for (llvm::Instruction &I : BB) {
                // Try to convert the LLVM Instruction to a MEMOIR Instruction.
                // NOTE: as is equivalent to LLVM's dyn_cast
                llvm::memoir::MemOIRInst *MI = dyn_cast_into<llvm::memoir::MemOIRInst>(&I);
                
                // If @MI is null, then @I is NOT a MEMOIR instruction.
                if (MI == nullptr) {
                    continue;
                }
                
                // Otherwise, @I is a MEMOIR instruction! Let's count it:
                ++memoir_inst_count;
            }
        }
    }
    
    // Print the number of MEMOIR instructions that we found.
    llvm::errs() << memoir_inst_count << "\n";
    
    // We did not modify the program, so we return false.
    return false;
}
```

The main difference between this pass and your run-of-the-mill LLVM pass is the use of `llvm::memoir::MemOIRInst` _via_ the `as` function.
`dyn_cast_into` is identical to LLVM's `dyn_cast`, but is necessary when converting from an LLVM instruction to a MEMOIR instruction and vice versa.
For more information about MEMOIR instructions, see [instructions](/compiler/instructions.md).

**Congratulations!** You wrote your first **MEMOIR** pass!


## _Example:_ Counting Types of MEMOIR Instructions
So far our pass isn't much to write home about, but it's a great start!
Let's kick it up a notch by updating the pass to count the _type_ of MEMOIR instructions in our program.

For this, we can use a visitor.
Add the following includes to your program:
```cpp
#include <memoir/ir/InstVisitor.hpp>
#include <map>
```

The MEMOIR `InstVisitor` gives us similar functionality to LLVM's `InstVisitor`, in fact, anything you can do in an LLVM `InstVisitor` can be done in MEMOIR's!
We can start by definining out visitor class:
```cpp
class MyVisitor : public llvm::memoir::InstVisitor<MyVisitor, void> {
    // In order for the wrapper to work, we need to declare our parent classes as friends.
    friend class llvm::memoir::InstVisitor<MyVisitor, void>;
    friend class llvm::InstVisitor<MyVisitor, void>;
}
```

Great! Now that we have our boilerplate, let's fill it in:
```cpp
class MyVisitor : ... {
    ...
    
public:

    // We will store the results of our analysis here:
    std::map<std::string, uint32_t> instruction_counts;

    // We _always_ need to implement visitInstruction!
    void visitInstruction(llvm::Instruction &I) {
        // Do nothing.
        return;
    }
    
    // Count all access instructions (read, write, get) together:
    void visitAccessInst(llvm::memoir::AccessInst &I) {
        this->instruction_counts["access"]++;
        return;
    }
    
    // Let's do the same for allocation instructions:
    void visitAllocInst(llvm::memoir::AllocInst &I) {
        this->instruction_counts["alloc"]++;
        return;
    }
    
    // Put everything else into an "other" bucket.
    // NOTE: since visitAllocInst and visitAccessInst are 
    //       implemented, visitMemOIRInst will _never_ be
    //       passed an AllocInst nor an AccessInst.
    void visitMemOIRInst(llvm::memoir::MemOIRInst &I) {
        this->instruction_counts["other"]++;
        return;
    }
```

Now we can use the visitor in our `runOnModule` pass:
```cpp
bool runOnModule(llvm::Module &M) override {
    // Initialize our visitor:
    MyVisitor visitor;

    // Analyze the program.
    for (llvm::Function &F : M) {
        for (llvm::BasicBlock &BB : F) {
            for (llvm::Instruction &I : BB) {
                visitor.visit(I);
            }
        }
    }
    
    // Print the results of our visitor:
    for (const auto &[type, count] : visitor.instruction_counts) {
        llvm::errs() << type << " -> " << count << "\n";
    }
    
    // We did not modify the program, so we return false.
    return false;
}
```

Now this is starting to look like a compiler pass!
As an exercise, try adding a couple more counters like `InsertInst` and `RemoveInst`!

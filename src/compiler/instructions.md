# Instructions
MEMOIR instructions can be operated on within the compiler with the `MemOIRInst` class.
In this section, we will detail what you are provided with in `MemOIRInst` and how to obtain them from within the LLVM compiler infrastructure.

## Bitcode Representation
All MEMOIR instructions are implemented as _quasi-intrinsics_, this allows us to extend the LLVM compiler without having to make changes to its internals.
There are various benefits and drawbacks to this approach, but that will not be the focus of this section.
When inspecting a LLVM+MEMOIR bitcode, you can easily spot MEMOIR instructions by their function prefix `memoir__<INSTRUCTION>`.

## Dynamic Casting
To retrieve a `MemOIRInst` from an `llvm::Instruction`, use the `into` function:
```cpp
llvm::Instruction *llvm_inst = ...;
MemOIRInst *memoir_inst = into<MemOIRInst>(llvm_inst);
```
This behaves similarly to LLVM's `dyn_cast`, attempting to cast the `llvm_inst` to `MemOIRInst`, returning `NULL` on failure.
The primary difference between the two is that, while `(void *)dyn_cast<T>(i) == (void *)i`, `(void *)into<T>(i) != (void *)i`.

When you have a `MemOIRInst` the LLVM RTTI functions `isa`, `dyn_cast`, `cast`, etc. can be used to convert between subclasses of `MemOIRInst`.
An overview of the subclasses are below.
For more information, see `memoir/ir/Instructions.hpp` in your install directory _or_ under the top-level `compiler/` directory of the repository.

## Additional Information
For more information, see the [Doxygen](https://mcmichen.cc/memoir-docs/doxygen).

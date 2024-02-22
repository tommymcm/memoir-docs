# Instructions
MEMOIR instructions can be operated on within the compiler with the `MemOIRInst` class.
In this section, we will detail what you are provided with in `MemOIRInst` and how to obtain them from within the LLVM compiler infrastructure.

## Bitcode Representation
All MEMOIR instructions are implemented as _quasi-intrinsics_, this allows us to extend the LLVM compiler without having to make changes to its internals.
There are various benefits and drawbacks to this approach, but that will not be the focus of this section.
When inspecting a LLVM+MEMOIR bitcode, you can easily spot MEMOIR instructions by their function prefix `memoir__<INSTRUCTION>`.

## Dynamic Casting
To retrieve a `MemOIRInst` from an `llvm::Instruction`, use the `as` function:
```cpp
llvm::Instruction *llvm_inst = ...;
MemOIRInst *memoir_inst = as<MemOIRInst>(llvm_inst);
```
This behaves similarly to LLVM's `dyn_cast`.

When you have `MemOIRInst` the LLVM RTTI functions `isa`, `dyn_cast`, `cast`, etc. can be used to convert between subclasses of `MemOIRInst`.
An overview of the subclasses are below.
For more information, see `memoir/ir/Instructions.hpp` in your install directory _or_ under the top-level `compiler/` directory of the repository.

## `MemOIRInst`
`MemOIRInst` is implemented as a wrapper of `llvm::CallInst`.
If you are inspecting a `MemOIRInst` and want to obtain LLVM-specific information about it, you can obtain the underlying `llvm::CallInst` with the `getCallInst` method.
Additionally, common getter methods of `llvm::Instruction` are provided by `MemOIRInst`, such as `getModule`, `getFunction`, and `getParent`.

### `TypeInst`
`TypeInst` is an abstract class for MEMOIR instructions that define types.
There are instructions for each of the primitive types, collection types, reference types, and struct types.
For all of these types, you can obtain the `Type` of them with the `getType` method (see the [Types chapter](compiler/types.md) for more information on how the MEMOIR compiler represents MEMOIR types.

### `AllocInst`
`AllocInst` are provided for each of the generic collection types and struct types in MEMOIR.
For any `AllocInst`, you can retrieve the `Type` of the allocation with `getType` and the `llvm::Value` of the allocation with `getAllocation`.

#### `CollectionAllocInst`
`CollectionAllocInst` provides an additional method to retrieve the `CollectionType` of the resultant with `getCollectionType`.

### `AccessInst`
`AccessInst` describes any read/write/get from MEMOIR collections and structs.
It provides the `getObjectOperand` and `getObjectOperandAsUse` methods to query the collection/struct being accessed.

#### `ReadInst`
`ReadInst` provides the `getValueRead` method to query the result of the read operation.

#### `WriteInst`
`WriteInst` provides the `getValueWritten` method to query the value written to the element.

#### `GetInst`
`GetInst` is used to obtain references for nested objects.
The resultant can be queried with `getNestedObject`.

#### `Index*Inst`
For each of the aforementioned access instructions the `Index*Inst` specializes it for accessing sequential collections.
The representation permits multiple dimensions of indexing, the number of dimensions can be queried with the `getNumberOfDimensions` method.
The index for a given dimension can be queried with the `getIndexOfDimension(dimension_index)` method.

#### `Assoc*Inst`
For each of the aforementioned access instructions the `Assoc*Inst` specializes it for accessing associative collections.
The key being accessed can be queried with the `getKeyOperand` method.

#### `Struct*Inst`
For each of the aforementioned access instructions the `Struct*Inst` specializes it for accessing struct objects.
The field index can be acquired with the `getFieldIndex` method.
Note that the field index is _guaranteed to be statically known_.

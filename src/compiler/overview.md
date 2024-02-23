# Compiler

In this chapter we will go over the structure of the MEMOIR compiler infrastructure.

## LLVM
MEMOIR is built using LLVM compiler infrastructure.
For information about the LLVM IR, see the [LLVM Language Reference Manual](https://llvm.org/docs/LangRef.html).
For information about how to use the LLVM compiler API, see the [LLVM Doxygen](http://mcmichen.cc/llvm/9.0.1/).

## NOELLE
The MEMOIR compiler infrastructure makes use of NOELLE abstractions and utilities.
For information about NOELLE, see the [NOELLE Paper](http://mcmichen.cc/files/NOELLE_CGO_2022.pdf).
For guides on how to use NOELLE, Simone Campanoni has put together YouTube videos explaining different NOELLE features, they can be found in his [Advanced Topics in Compilers materials](https://users.cs.northwestern.edu/~simonec/ATC.html).
Lastly, for detailed information about the NOELLE source code, you can reference the [GitHub repository](https://github.com/arcana-lab/noelle).

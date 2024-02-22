# Writing a Program

In this section, we will be going over a few example C++ programs using MEMOIR collections.

## _Example:_ Sequences
Let's start on a basic statistics program.

To get started, we need to include the `cmemoir` headers.
```cpp
#include <cmemoir/cmemoir.h>

using namespace memoir;
```

Now, let's make our `main` function, where we will read the arguments into a MEMOIR sequence.

To start off with, we need to allocate a sequence.
Sequences can be allocated with the `memoir_allocate_sequence` function.
The first argument to the function is the type of elements within the sequence and the second is the initial length of the sequence, for example:
```cpp
#include <cmemoir/cmemoir.h>

using namespace memoir;

int main(int argc, char *argv[]) {
    collection_ref input = memoir_allocate_sequence(memoir_i32_t, argc - 1);
}
```

Now let's populate the sequence!
To write to the sequence, we use the function `memoir_index_write(T, v, s, i)`.
`T` is the shorthand element type, `v` is the value to write to `s[i]`.
With this, we can update our `main` function:
```cpp
#include <cmemoir/cmemoir.h>
#include <stdlib.h>

using namespace memoir;

int main(int argc, char *argv[]) {
    collection_ref input = memoir_allocate_sequence(memoir_i32_t, argc - 1);
    
    for (int i = 0; i < argc - 1; ++i) {
        memoir_index_write(i32, atoi(argv[i+1]), input, i);
    }
}
```

Let's go ahead and use the sequence for something now!
To do that, we can create a new function to compute the sum of the sequence:
```cpp
int sum(collection_ref input) {
    int32_t sum = 0;
    for (int i = 0; i < memoir_size(input); ++i) {
        sum += memoir_index_read(i32, input, i);
    }
    return sum;
}
```
In `sum` we use two new MEMOIR functions: `memoir_index_read` and `memoir_size`.
`memoir_index_read(T, s, i)` reads `s[i]`, which has element type `T`.
`memoir_size(s)` returns the size of the sequence as a `size_t`.

Now we can call our `sum` function in `main`:
```cpp
#include <stdio.h>
...
int main(int argc, char *argv[]) {
    collection_ref input = memoir_allocate_sequence(memoir_i32_t, argc - 1);
    
    for (int i = 0; i < argc - 1; ++i) {
        memoir_index_write(i32, atoi(argv[i+1]), input, i);
    }
    
    int result = sum(input);
    
    printf("sum = %d\n", result);
    
    return 0;
}
```

## _Example:_ Associative Array
Let's extend our statistics program to provide a histogram!

First off, we will need to create a new associative array, which can be done with `memoir_allocate_assoc_array(K, V)`, where `K` is the key rtype and `V` is the value type:
```cpp
collection_ref hist(collection_ref input) {
    collection_ref histogram = memoir_allocate_assoc_array(memoir_i32_t, memoir_u32_t);
}
```

Following this, we need to populate it with values from the input sequence.
```cpp
collection_ref hist(collection_ref input) {
    collection_ref histogram = memoir_allocate_assoc_array(memoir_i32_t, memoir_u32_t);
    
    for (int i = 0; i < memoir_size(input); ++i) {
        int32_t value = memoir_index_read(i32, input, i);
        if (memoir_assoc_has(histogram, value)) {
            uint32_t current = memoir_assoc_read(u32, histogram, value);
            memoir_assoc_write(u32, current + 1, histogram, value);
        } else {
            memoir_assoc_insert(histogram, value);
            memoir_assoc_write(u32, 1, histogram, value);
        }
    }
    
    return histogram;
}
```
Note that we must explicitly insert keys into the associative array before writing to it, it is undefined behavior to write a value to a key which doesn't exist in the associative array.

Now, let's use the new `hist` function and see how to iterate over it:
```cpp
int main(...) {
    collection_ref input = ...;
    
    { ... }
    
    collection_ref histogram = hist(input);
    
    collection_ref keys = memoir_assoc_keys(histogram);
    for (int i = 0; i < memoir_size(keys); ++i) {
        int32_t key = memoir_index_read(i32, keys, i);
        uint32_t count = memoir_assoc_read(u32, histogram, key);
        printf("%d -> %ld\n", key, count);
    }
    
    return 0;
}
```
To iterate over the associative array, we need to collect its keys with the `memoir_keys` function.
`memoir_assoc_keys(a)` returns a sequence of the keys present in `a`.
Note that their is no guarantee on the order of keys in the resultant.


## Compiling your program
Compiling C/C++ programs using MEMOIR collections is straightforward.
The `memoir-clang` and `memoir-clang++` command-line tools provide similar functionality to `clang`/`clang++`.
_**NOTE:** These should not be considered drop-in replacements_.

To compile the program you just wrote, simply run:
```
memoir-clang++ my_program.cpp -o my_program
```

The result of this command is `my_program` which can be executed, for example, if you run:
```
./my_program 123 123 321
```
The following will be printed on your command line:
```
sum = 567
123 -> 2
321 -> 1
```

**Congratulations!** You have now written and ran your first program in **MEMOIR!**

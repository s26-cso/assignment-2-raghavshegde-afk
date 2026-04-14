#include <stdio.h>
#include <stdlib.h>
#include <string.h>                         // Header for string manipulation (like sprintf)
#include <dlfcn.h>                          // The "Dynamic Loading" library; essential for dlopen/dlsym
//compile using :gcc main.c -ldl
int main() {
    char op[6];
    int a, b;
    while (scanf("%s %d %d", op, &a, &b)==3) {          // Reads till EOF or if wrong datatype, not in separate scanfs with input !=eof since it might still read and return values
        char libname[20];
        sprintf(libname, "./lib%s.so", op);             // Constructs the filename string for library, e.g., "add" becomes "./libadd.so"
        void *handle = dlopen(libname, RTLD_LAZY);      // dlopen attempts to load the shared library into memory.
                                                        // RTLD_LAZY means "resolve symbols only when they are needed."
        if (!handle) {                                  //if handle is NULL, the file wasn't found or couldn't be opened.
            printf("Error loading %s\n", libname);
            continue;
        }
        int (*func)(int, int);                              // Declare a function pointer 'func' that takes two ints and returns an int.
        func = dlsym(handle, op);                           // dlsym searches the loaded library (handle) for a symbol matching the string 'op'.
                                                            // We cast the result to our function pointer type.
        if (!func) {                                        //if dlsym returns NULL, the function name doesn't exist in the .so file.
            printf("Error finding function %s\n", op);
            dlclose(handle);                                // Close the library handle before skipping to the next iteration.
            continue;
        }
        int ans = func(a, b);                               // Call the function via the pointer and print the result.
        printf("%d\n", ans);
        dlclose(handle);                                    // Close the library handle to prevent memory leaks.
    }
    return 0;
}
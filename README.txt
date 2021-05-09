Usage instructions:

The main directory has a Makefile which can be used to build and clean the project

----------------------------------------------------------------------------------

For building the project and getting the executable `a.exe` in the command line, use:

make

----------------------------------------------------------------------------------

For compiling the code from `test/factorial.hhps` (could be any path)

a.exe < test/factorial.hhps

The output ```MIPS``` code will be generated in ```asmb.asm```

----------------------------------------------------------------------------------

For deleting the build:

- Linux

make clean

- Windows

make clean_win

----------------------------------------------------------------------------------

For further details about the project check out README.md
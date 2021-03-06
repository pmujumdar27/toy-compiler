## Compiler for HHPS
### đģ

---

**Course project for _CS327-Compilers_ course at IITGN.**

Contributors :\
[Harsh Patel](https://github.com/Harshp1802) - 18110062\
[Harshit Kumar](https://github.com/harshitkumar825) - 18110063\
[Pushkar Mujumdar](https://github.com/pmujumdar27) - 18110132\
[Shivam Sahni](https://github.com/shivam15s) - 18110159


This is a compiler - a toy of sorts - written using ```flex```, ```bison``` and ```C``` for our custom defined language ```HHPS```.

---

## Contents
## đ
- [About the Language](#about-the-language)
- [Usage instructions](#usage-instructions)
- [Feature Checklist](#feature-checklist)
- [Basic Structure](#basic-structure)
- [Lexicon and Syntax](#lexicon-and-syntax)
   - [Keywords](#keywords)
   - [Special Characters](#special-characters)
   - [Arithmetic Operators](#arithmetic-operators)
   - [Logical Operators](#logical-operators)
   - [Reserved names](#reserved-names)
- [Grammar](#grammar)
- [Directory Structure](#directory-structure)
- [Sample Programs](#sample-programs)
- [References](#references)

---

## About the Language
## âšī¸

```HHPS``` is a language based on the 2 most widely used programming languages : ```C``` and ```Python``` . ```HHPS``` is an attempt to bring out the best of both these languages and combine them into a single, easy to use language.

It is a language with simple and intuitive syntax and grammar. It can be used by coders of any level, be it beginner, intermediate or experienced.

---

## Usage instructions

For building the project and getting the executable `a.exe` (`a.out` in case of Linux)
```
make
```

For compiling the code from `test/factorial.hhps` (could be any path)
```
a.exe < test/factorial.hhps
```
The output ```MIPS``` code will be generated in ```asmb.asm```

For deleting the build:
- Linux
```
make clean
```
- Windows
```
make clean_win
```

---

## Feature checklist:
## â

- âī¸ Integer data type
- âī¸ Relational operators
- âī¸ Arithmetic operators
- âī¸ If-else conditionals
- âī¸ Nested conditionals
- âī¸ While loop
- âī¸ Nested while loops
- âī¸ For loop (similar to python)
- âī¸ Nested For loop
- âī¸ Arrays
- âī¸ Function calls
- âī¸ Recursion
- âī¸ Return statements
- âī¸ Verbose error reporting (with line number) â
- âī¸ Multi-line comments
- âī¸ Input feature
- âī¸ Print statement for output
- âī¸ Print statement with newline

---

## Basic structure
## đ ī¸

Any program written in ```HHPS``` has 2 major blocks :

```
** Function Declaration Block**
Any user-defined functions needed in the program should be declared here.
If none, this block can be skipped.
```
```
** Main Function **
The main function is similar to the one in C.
The main function is the first piece of code that is executed by the operating system when it runs the program.
```

---

## Lexicon and Syntax
## â

For the Lexical Analyser, refer [tok.l](./tok.l)

Identifiers : Combination of lower and upper case alphabets and _ (except the keywords).

Multi-line comments : Anything between ```/*``` and ```*/```

## Keywords

- ```if``` Conditional statement
- ```else``` Alternate Condition
- ```for``` Iterative Loop
- ```while``` Conditional Loop
- ```range``` Range
- ```array``` Array
- ```int``` Integer
- ```decl``` Declare function
- ```main``` Main function
- ```return``` Function Return
- ```print``` Print to console
- ```println``` Print with newline

## Reserved names

- ```fun_``` Should be the prefix of the function names

Any function should have the above stated prefix in the function name, and any lexeme with the prefix will be treated as a function name.

## Special Characters

- ```\n``` Newline Character (error reporting)
- ```;``` End of Statement

## Arithmetic Operators

- ```+``` Addition
- ```-``` Subtraction / Unary Minus
- ```*``` Multiplication
- ```/``` Division
- ```%``` Modulo
- ```&``` Bitwise AND
- ```|``` Bitwise OR

## Logical Operators

- ```<``` Less than
- ```>``` Greater than
- ```<=``` Less than or Equal to
- ```>=``` Greater than or Equal to
- ```!=``` Not equal to
- ```==``` Equal to
- ```&&``` Logical AND
- ```||``` Logical OR

---

## Grammar
## đ

For the complete Grammar rules, refer the Parser Generator [hhps.y](./hhps.y)

A statement can be :
- Variable Declaration ```int b = 5;```
- Variable Assignment ```a = b + 1;```
- Print Statement ```print(c);```
- Return Statement ```return 0;```
- Conditional Statement (If-Else) ```if(x < 10){```
- For Loop ```for i range(0,10){```
- While Loop ```while(i < j){```
- Array Declaration ```array (int, 10) a;```
- Function Declaration ``` decl int fun_square(){```
- Function call with parameters `x` and `y` \
 ```fun_test(x=5, y=4);```

---

## Directory Structure:
## đ

```
âââhhps.y
âââhhps.h
âââmain.c
âââMakefile
âââREADME.md
âââREADME.txt
âââtok.l
ââââtest
    âââarray_print_expressions.hhps
    âââarray_with_while.hhps
    âââarray_with_while_input.hhps
    âââbubblesort.hhps
    âââconditionals.hhps
    âââerror.hhps
    âââfactorial.hhps
    âââfor_loop.hhps
    âââfunc_test.hhps
    âââif-else.hhps
    âââif-else_input.hhps
    ââânested_for.hhps
    ââânested_while.hhps
    âââremainder.hhps
    âââreturn_test.hhps
    âââwhile_loop.hhps
```

---

## Sample Programs:
## â¨ī¸

Sample code for **Bubblesort** written in `HHPS`
```
int main(){
    array (int, 10) a;
    for i range(0, 10){
        a[i] = 10-i;
    } 
    for i range(0, 10){
        int t = 9-i;
        for j range(0, t){
            if (a[j] > a[j+1]){
                int temp = a[j];
                a[j] = a[j+1];
                a[j+1] = temp;
            }
        }
    }

    for i range(0, 10){
        println(a[i]);
    }

    return 0;
}
```

For sample programs covering all features, refer the [test](./test/) folder.

## References:

- Code used in Compilers Labs {9,10,11}
- https://www.gnu.org/software/bison/manual/html_node/Mfcalc-Symbol-Table.html
- MIPS_Instruction_Set.pdf (unive.it)
- Compiler Construction using Flex and Bison, Anthony A. Aaby

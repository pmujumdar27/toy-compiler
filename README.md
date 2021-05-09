## Compiler for HHPS
### 💻

---

**Course project for _CS327-Compilers_ course at IITGN.**

Contributors :\
[Harsh Patel](https://github.com/Harshp1802)\
[Harshit Kumar](https://github.com/harshitkumar825)\
[Pushkar Mujumdar](https://github.com/pmujumdar27)\
[Shivam Sahni](https://github.com/shivam15s)


This is a compiler - a toy of sorts - written using ```flex```, ```bison``` and ```C``` for our custom defined language ```HHPS```.

---

## Contents
## 📄
- [About the Language](#about-the-language)
- [Feature Checklist](#feature-checklist)
- [Basic Structure](#basic-structure)
- [Lexicon and Syntax](#lexicon-and-syntax)
   - [Keywords](#keywords)
   - [Special Characters](#special-characters)
   - [Arithmetic Operators](#arithmetic-operators)
   - [Logical Operators](#logical-operators)
- [Grammar](#grammar)
- [Directory Structure](#directory-structure)
- [References](#references)

---

## About the Language
## ℹ️

```HHPS``` is a language based on the 2 most widely used programming languages : ```C``` and ```Python``` . ```HHPS``` is an attempt to bring out the best of both these languages and combine them into a single, easy to use language.

It is a language with simple and intuitive syntax and grammar. It can be used by coders of any level, be it beginner, intermediate or experienced.

---

## Feature checklist:
## ✅

- ✔️ Integer data type
- ✔️ Relational operators
- ✔️ Arithmetic operators
- ✔️ If-else conditionals
- ✔️ Nested conditionals
- ✔️ While loop
- ✔️ Nested while loops
- ✔️ For loop (similar to python)
- ✔️ Nested For loop
- ✔️ Arrays
- ✔️ Function calls
- ✔️ Return statements
- ✔️ Verbose error reporting (with line number) ❗
- ✔️ Multi-line comments
- ✔️ Input feature
- ✔️ Print statement for output
- ✔️ Print statement with newline

---

# Basic structure
# 🛠️

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
## ❓

For the Lexical Analyser, refer [tok.l](./tok.l)

Identifiers : Combination of lower and upper case alphabets and _ (except the keywords).

Multi-line comments : Anything between /* and */

# Keywords

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

# Special Characters

- ```\n``` Newline Character (error reporting)
- ```;``` End of Statement

# Arithmetic Operators

- ```+``` Addition
- ```-``` Subtraction / Unary Minus
- ```*``` Multiplication
- ```/``` Division
- ```%``` Modulo
- ```&``` Bitwise AND
- ```|``` Bitwise OR

# Logical Operators

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
## 📖

For the complete Parser, refer [hhps.y](./hhps.y)

A statement can be :
- Variable Declaration ```int b = 5```
- Variable Assignment ```a = b + 1```
- Print Statement ```print(c)```
- Return Statement ```return 0```
- Conditional Statement (If-Else) ```if(x < 10){```
- For Loop ```for i range(0,10){```
- While Loop ```while(i < j){```

---

## Directory Structure:
## 📁

```
toy-compiler
├──Makefile
├──README.md
├──hhps.y
├──hhps.h
├──main.c
├──tok.l
└──test
    ├──array_with_while.hhps
    ├──factorial.hhps
    ├──for_loop.hhps
    ├──func_test.hhps
    ├──if-else.hhps
    ├──nested_while.hhps
    └──while_loop.hhps
```

---

## Sample Programs:
## ⌨️

Sample code for Bubblesort written in `HHPS`
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

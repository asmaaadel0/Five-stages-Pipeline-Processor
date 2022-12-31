# Five-stages-Pipeline-Processor
The processor in this project has a RISC-like instruction set architecture. There are eight 2-bytes general
purpose registers[ R0 to R7]. These registers are separate from the program counter and the stack pointer
registers.
The program counter (PC) spans the instructions memory address space that has a total size of 2
Megabytes. Each memory address has a 16-bit width (i.e., is word addressable). The instructions memory
starts with the interrupts area (the very first address space from [0 down to 2^5-1]), followed by the instructions area (starting from [2^5 and down to 2^20]) as shown in Figure.1. By default, the PC is initialized with a value of (2^5) where the program code starts.

# <div><img src="processor.jpg" width="50" draggable="false" > Five stages Pipeline Processor </div>

## 📝 Table of Contents

- [About <a name = "about"></a>](#about-)
- [Implemented Instructions <a name = "screen-video"></a>](#implemented-instructions-)
- [Contributors <a name = "Contributors"></a>](#contributors-)


## About <a name = "about"></a>

The processor in this project has a RISC-like instruction set architecture. There are eight 2-bytes general
purpose registers[ R0 to R7]. These registers are separate from the program counter and the stack pointer
registers.
The program counter (PC) spans the instructions memory address space that has a total size of 2
Megabytes. Each memory address has a 16-bit width (i.e., is word addressable). The instructions memory
starts with the interrupts area (the very first address space from [0 down to 2^5-1]), followed by the instructions area (starting from [2^5 and down to 2^20]) as shown in Figure.1. By default, the PC is initialized with a value of (2^5) where the program code starts.


## Implemented Instructions <a name = "implemented-instructions"></a>

## Implemented Instructions
### ☝️ One Operand
```
NOP
SETC
CLRC
NOT Rdst
INC Rdst
DEC Rdst
OUT Rdst
IN Rdst
```
### ✌️ Two Operands
```
MOV Rsrc, Rdst
ADD Rsrc, Rdst
SUB Rsrc, Rdst
AND Rsrc, Rdst
OR Rsrc, Rdst
SHL Rsrc, Imm
SHR Rsrc, Imm
```

### 💾 Memory
```
PUSH  Rdst
POP  Rdst
LDM  Rdst, Imm
LDD Rsrc, Rdst
STD Rsrc, Rdst
```

### 🦘 Jumps
```
JZ  Rdst
JN  Rdst
JC Rdst
JMP  Rdst
CALL Rdst
RET
RTI
```
### 💾 Input Signals
```
Reset
Interrupt
```



### Contributors <a name = "Contributors"></a>

<table>
  <tr>
    <td align="center">
    <a href="https://github.com/asmaaadel0" target="_black">
    <img src="https://avatars.githubusercontent.com/u/88618793?s=400&u=886a14dc5ef5c205a8e51942efe9665ed8fd4717&v=4" width="150px;" alt="Asmaa Adel"/>
    <br />
    <sub><b>Asmaa Adel</b></sub></a>
    </td>
    <td align="center">
    <a href="https://github.com/Samaa-Hazem2001" target="_black">
    <img src="https://avatars.githubusercontent.com/u/82514924?v=4" width="150px;" alt="Asmaa Adel"/>
    <br />
    <sub><b>Samaa Hazem</b></sub></a>
    </td>
    <td align="center">
    <a href="https://github.com/norhanreda" target="_black">
    <img src="https://avatars.githubusercontent.com/u/88630231?v=4" width="150px;" alt="norhan reda"/>
    <br />
    <sub><b>norhan reda</b></sub></a>
    </td>
    <td align="center">
    <a href="https://github.com/Hoda233" target="_black">
    <img src="https://avatars.githubusercontent.com/u/77369927?v=4" width="150px;" alt="HodaGamal"/>
    <br />
    <sub><b>HodaGamal</b></sub></a>
    </td>
  </tr>
 </table>

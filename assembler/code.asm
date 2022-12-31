; #this is a comment 
; #all numbers are in hexadecimal
; #the reset signal is raised before this code is executed and the flags and the registers are set to zeros.
.ORG 0 ;#this is the interrupt code
NOP
SETC
CLRC
RTI
.ORG 32 ;#this is the interrupt code
NOT R1
INC R1
DEC R1
OUT R2
IN R1
MOV R1,R2
ADD R1,R3
SUB R3,R4
AND R1,R2
OR R3,R4
SHL R4,4
SHR R5,2
PUSH R1
POP R4
LDM R3,5
LDD R1,R4
STD R5,R4
JZ R2
JN R5
JC R4
JMP R1
CALL R1
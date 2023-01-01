#this is a comment 
#all numbers are in hexadecimal
#the reset signal is raised before this code is executed and the flags and the registers are set to zeros.
.ORG 0 #this is the interrupt code
AND R3,R4
ADD R1,R4
OUT R4
RTI
.ORG 20 #this is the instructions code
LDM R5,3
LDM R6,4
LDM R1,1
STD R1,R5       ;store value of r1 in address of r5
STD R1,R6       ;store value of r1 in address of r6
LDD R5,R1       ;R1=1     load address of r5 put it in r1
LDD R6,R2       ;R2=1     load address of r6 put it in r2
ADD R2,R1       ;R1=2
STD R1,R4       ;M[4]=50
Push R2         ;M[1023]=30 Sp=1022 assume von Neumann arch
Push R1         ;M[1022]=50 Sp=1021
LDD R1,R4       ;R1=60
LDD R2,R4       ;R2=70
ADD R2,R1       ;R1=130
Pop R1          ;R1=50
pop R2          ;R2=30

SETC            ;C=1

NOT R1          ;R1=-5=1111111111111011b   N=1 Z=0
CLRC    
INC R0          ;R0=17
DEC R1          ;R1=-6 N=1 Z=0

.ORG 100
SETC
LDM R1,5
LDM R3,5
NOP
NOP
Sub R3,R1       ;R1=0 Z=1
#this is a comment 
#all numbers are in hexadecimal
#the reset signal is raised before this code is executed and the flags and the registers are set to zeros.
.ORG 0 #this is the interrupt code
AND R3,R4
ADD R1,R4
OUT R4
RTI
.ORG 20 #this is the instructions code
IN R1                   #add 00000005 in R1 R1 = 5
IN R2                   #add 00000019 in R2 R2 = 25
IN R3                   #FFFFFFFF           R3 = -1    
IN R5                   #FFFFF320
NOP
STD R1,R2  ;store value of r1 in address of r2
STD R1,R3  ;store value of r1 in address of r3
NOP
NOP
NOP
NOP
LDD R2,R3                   #R3= 00000005 M[R2]    ;load address of r2 put it in r3
LDD R3,R5           #R5= 0000000 M[R3]  not 00000005 ;load address of r3 put it in r5
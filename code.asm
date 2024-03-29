#branch.asm
#this is a comment 
#all numbers are in hexadecimal
#the reset signal is raised before this code is executed and the flags and the registers are set to zeros.
.ORG 0 #this is the interrupt code
LDM R7,15  #R7=00000015
ADD R7,R4
STD R4,R7
RTI
.ORG 20 #this is the instructions code
IN R6   #R6=300
Push R6   #SP=000007FE, M[000007FF]=300
IN R1   #R1=40
IN R2   #R2=500
IN R3  #R3=100
IN R4 #R4=07FF
LDD R4,R5
call R5
INC R1  #this statement shouldn't be executed
#check flag fowarding  
.ORG 400
AND R1,R5   #R5=0 , Z = 1
JZ R2  #Jump taken, Z = 0
SETC  # this statement shouldn't be executed, C-->1
#check on flag updated on jump
.ORG 300
MOV R5,R3  #R3=300, flag no change
JC R5  #shouldn't be taken
#check destination forwarding
NOT R7   #R5=FFFFFFFF, Z= 0, C--> not change, N=1
## raise interrupt here
IN   R6   #R6=700, flag no change
MOV R5,R6 #R5=700, flag no change
INC R1 
RET
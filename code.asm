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

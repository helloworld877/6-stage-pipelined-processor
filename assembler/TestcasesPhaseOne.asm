﻿#        All numbers are in hex format
#        We always start by reset signal (in phase one, it just reset all registers)
#         This is a commented line
#        You should ignore empty lines and commented ones
#         add as much NOPs as you want to avoid hazards (as a software solution, just in 
#          phase one)
# ---------- Don't forget to Reset before you start anything ---------- #
.org 0
IN R5
INC R5,R5
INC R5,R5
IN R1
IN R2
IN R3
IN R4
IN R5
NOP
STD R1,R2
STD R3,R4
STD R2,R5
INC R2,R1
LDD R0, R1
LDD R7, R3
AND R1,R2,R6
INC R1,R1
NOP
AND R5,R3,R4
NOP
NOP
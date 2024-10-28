#THIS IS A BASIC SANITY
#It is the most basic program I could think of 
.data

.text
lw $t2 45 #This is a test for in line comments
alabel 
lw $t3 10
lw $t4 5($t3)
add $t5 $t4 $t2
sw $t5 1

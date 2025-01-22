#Sample code - Invert the least significant X bits of Y
#Based off lab questions in:
#https://www.udemy.com/course/the-complete-mips-programming-course

	.data
	.text
	.globl main

main:
	li $s1 23		#X 
	li $s0 8		#Y
	
	li $t0 1		#t0 = 1
	sllv $t1 $t0 $s0		#t1 = t0*2^X
	addiu $t1 $t1 -1	#t1 = t1 +(-1) 	(Twos compliment)
	xor $s1 $s1 $t1		#s1 = s1 xor t1
	jr $ra
	
	
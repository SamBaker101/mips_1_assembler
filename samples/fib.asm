#Sample code
#Based off lab questions in:
#https://www.udemy.com/course/the-complete-mips-programming-course

.data
fib:	.space 320 

.text
main:
	li $s0 2
	li $t0 0
	li $t1 1
	la $s1 fib
	sw $t0 ($s1)
	sw $t1 4($s1)
	
loop:
	bge $s0 10 break_loop
	sll $t2 $s0 2
	addu  $t2 $t2 $s1
	lw $t3 -4($t2)
	lw $t4 -8($t2)
	addu $t5 $t3 $t4
	sw $t5 ($t2)
	addiu $s0 $s0 1
	j loop
	
break_loop:
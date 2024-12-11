#Sample code
#Based off lab questions in:
#https://www.udemy.com/course/the-complete-mips-programming-course

.data
A: 		.word 3 5 7
pointer:	.word 0

.text
main:
	la $t0 A
	addi $t1 $t0 8
	sw $t1 pointer
	
	lw $s0 ($t1)
	addi $s0 $s0 2
	
	subi $t2 $t1 8
	lw $t3 ($t2)
	add $s0 $s0 $t3
	
	addi $t4 $t0 4
	sw   $s0 ($t4)
	
	move $a0 $s0
	li   $v0 1
	syscall
	
	li $v0 10
	syscall
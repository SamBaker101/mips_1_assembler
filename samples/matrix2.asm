#Sample code - Matrix math 2
#Based off lab questions in:
#https://www.udemy.com/course/the-complete-mips-programming-course

#int mat[4][6] = {{0, 0, 2, 0, 0, 0}, 
#		  {0, 0, 4, 0, 0, 0},
#		  {0, 0, 6, 0, 0, 0},
#		  {0, 0, 8, 0, 0, 0}};

#int result;

#main()
#{
#	result = suma_col(mat);
#}

#int suma_col(int m[][6])
#{
#	int i, suma = 0;
	
#	for (i = 0; i < 4; i++)
#		suma += m[i][2];	//Use sequential accesses
		
#	return suma;
#}

####################################

.data
mat:	.word	0 0 2 0 0 0
	.word 	0 0 4 0 0 0 
	.word 	0 0 6 0 0 0
	.word	0 0 8 0 0 0
	
result: .word 0

.text
main:

	addiu $sp $sp -4
	sw $ra 0($sp)
	
	la $a0 mat
	jal suma_col
	la $t0 result
	sw $v0 0($t0)

	lw $ra 0($sp)
	addiu $sp $sp 4
	jr $ra

suma_col:
	addiu $sp $sp 16
	sw $ra 12($sp)
	sw $s0 8($sp)
	sw $s1 4($sp)
	sw $s2 0($sp)
	
	li $s0 0
	li $s1 0
	la $t0 0($a0)
	addi $t0 $t0 8
	move $s2 $t0

loop:
	lw $t1 0($s2)
	add $s1 $s1 $t1
	addi $s0 $s0 1
	addi $s2 $s2 24
	blt $s0 4 loop
	
	lw $s2 0($sp)
	lw $s1 4($sp)
	lw $s0 8($sp)
	lw $ra 12($sp)
	addiu $sp $sp 16
	
	jr $ra


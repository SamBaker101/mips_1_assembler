#Sample code - Matrix math 1
#Based off lab questions in:
#https://www.udemy.com/course/the-complete-mips-programming-course

# int mat1[5][6];
# int mat4[2][3] = {{2, 3, 1}, {2, 4, 3}};
# int col = 2;

# main()
# {
# 	mat1[4][3] = subr(mat4, mat4[0][2], col);
# 	mat1[0][0] = subr(mat4, 1, 1)
# }

# subr(int x[][3], int i, int j)
# {
# 	mat1[j][5] = x[i][j];
# 	return i;
# }

.data
mat1: 	.space 120
mat4: 	.word 2, 3, 1
	.word 2, 4, 3
col: 	.word 2

.text 
.globl main

main: 
	addiu $sp $sp -4
	sw $ra 0($sp)
	
	la $a0 mat4
	lw $a1 8($a0)
	la $a2 col
	lw $a2 0($a2)
	
	jal subr
	la $t0 mat1
	sw $v0 108($t0)
	
	la $a0 mat4
	addiu $a1 $zero 1
	addiu $a1 $zero 1
	
	jal subr
	la $t0 mat1
	sw $v0 0($t0)
	
	lw $ra 0($sp)
	addiu $sp $sp 4
	jr $ra

subr:
	addiu $t2 $zero 6
	addiu $t0 $zero 3
	mult $t0 $a1
	mflo $t1
	addu $t1 $t1 $a2
	sll $t1 $t1 2
	addu $t1 $t1 $a0
	lw $t1 0($t1)
	
	mult $a2 $t2
	mflo $t2
	addiu $t2 $t2 5
	sll $t2 $t2 2
	
	la $t0 mat1
	addu $t0 $t0 $t2
	sw $t1 0($t0)
	addu $v0 $zero $a1
	jr $ra	
	
	
	
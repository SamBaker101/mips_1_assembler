#Sample code - Matrix math 3
#Based off lab questions in:
#https://www.udemy.com/course/the-complete-mips-programming-course

#int update(int mat[][10], int l, int t){

#int a = 2;
#mat[0][5] = a + t;
#int i = l;
#while (a < 10) {
#	mat[i][a] = i + a;
#	++a;
#	++i;
#}
#return i + a + l
#}

################################


.data
.text

update: 
	addi $sp $sp 12
	sw $ra 8($sp)
	addi $t0 $zero 2
	sw $t0 4($sp)
	addi $t0 $a0 20
	lw $t1 4($sp)
	add $t1 $t1 $a2
	sw $t1 ($t0)
	li $t2 1
	
loop:
	bge $t1 10 endloop
	add $t5 $t2 $t1
	mul $t3 $t2 40
	sll $t4 $t1 2
	add $t0 $t3 $t4
	add $t0 $a0 $t0
	sw $t5 ($t0)
	addi $t1 $t1 1
	addi $t2 $t2 1
	j loop
endloop:
	
	add $t0 $t0 $t1
	add $v0 $t0 $a1
	lw $ra 8($sp)
	addi $sp $sp 12
	jr $ra 

	
	
	
#Sample code - ASCII Conversion
#Based off lab questions in:
#https://www.udemy.com/course/the-complete-mips-programming-course

#char chain[6] = {-1,-1,-1,-1,-1,-1};
#unsigned int vec[5] = {5, 6, 8, 9, 1};
#void main(){
#	int i = 0; 
#	while (i < 5){
#		chain[i]=vec[4-i] + '0';
#		i ++
#	}
#	chain[5] = 0;
#	print_chain(chain);
#}

.data
chain:	.byte -1, -1, -1, -1, -1, -1
vec;	.word  5, 6, 8, 9, 1

.text
.globl main
main:
	li $s0 0		# i = 0
while:
	li $t0 5
	bge $s0 $t0 end 	#while(i<5)
	
	li $ti 4
	sub $t1 $t1 $s0		#4 - i
	la $s1 vec
	sll $t1 $t1 2		#4(4 - i)
	addu $s1 $s1 $t1	#&vec + 4(4 - i)
	
	lbu $s2 0($s1)		
	addiu $s2 $s2 48
	la $s3 chain		
	addu $s3 $s3 $s0	#chain + i
	sb $s2 0($s3)		#chain[i] = vec[4-1] + '0'
	addiu $s0 $s0 1
	b while
	
fi:
	la $t5 chain
	sb $zero 5($t5)
	li $v0 4
	la $a0 chain
	
	jr $ra
	
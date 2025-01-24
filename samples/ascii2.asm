#Sample code - Check if num is an ascii char or digit
#Based off lab questions in:
#https://www.udemy.com/course/the-complete-mips-programming-course

#int result = 0
#char num = '7'
#main() {
#	if (((num >= 'a')&&(num <='z'))||((num >= 'A')&&(num <='Z')))
#		result = num;
#	else{
#		if ((num >= '0') && (num <= '9'))
#			result = num - '0';
#		else
#			result = -1;
#	}
#}

.data
result: .word 0
num: byte '7'

.text
.globl main
main:
	la $s0 result
	lbu $t0 num
	
	#is letter?
	addiu $t1 $zero 'a'
	blt $t0 $t1 is_not_letter_lower
	addiu $t1 $zero 'z'
	bgt $t0 $t1 is_not_letter_lower
is_not_letter_lower:
	addiu $t1 $zero 'A'
	blt $t0 $t1 is_not_letter
	addiu $t1 $zero 'Z'
	bgt $t0 $t1 is_not_letter
	
	#Set result
	addu $t2 $zero $t0
	sw $t2 ($s0)
	j exit
	
	
	
	
#Hello World

.data
	Message: .asciiz "Hello World"

.text
	li $v0 4
	la $a0 Message #This instruction is not implemented ...
	syscall
	
	
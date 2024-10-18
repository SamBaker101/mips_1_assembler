#Hello World

.data
	Message: .asciiz "Hello World"

.text
	li $v0 4
	la $a0 Message
	syscall
	
	
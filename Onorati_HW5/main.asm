# Kristin Onorati
# CPTS 260
# HW 5

# Main function for testing palindrome function
.data
str1:  .asciiz "Number of tests passed: "

.text
main: 
	# Stack Push
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	jal testPal
	
	# Stack Pop
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	move $t0, $v0
	# Print results of tests
	la $a0, str1
	li $v0, 4
	syscall
	move $a0, $t0
	li $v0, 1
	syscall
	
	# Halt
	li $v0, 10
	syscall

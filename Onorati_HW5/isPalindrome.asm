# Kristin Onorati
# CPTS 260
# HW 5


.globl isPalindrome

# Determines if given string is a palindrome
# bool isPalindrome (char *P)

isPalindrome: 
	#Stack Push
	addi $sp, $sp, -4
	sw $ra, 0($sp)

	move $t1, $a0	# $t1 = start
	jal strlen		# $v0 = strlen
	addi $v0, $v0, -1	# $v0 = strlen - 1 = end
	add $t2, $v0, $t1	# $t2 = last char of P
	li $v0, 1		# $v0 = true
	
While1: bgeu $t1, $t2 Wend1	# while( $t1 < $t2)

While2: lbu $t3, 0($t1)		# $t3 = *Start
	addi $t1, $t1, 1		# Start++
	beq $t3, 32, While2	# Skip spaces

While3: lbu $t4, 0($t2)		# $t4 = *End
	addi $t2, $t2 -1		# End--
	beq $t4, 32, While3	# Skip spaces

	move $a0, $t3		# Set characters to lowercase
	jal toLower		
	move $t3, $v0
	move $a0, $t4
	jal toLower
	move $t4, $v0
	
	beq $t3, $t4, While1	# Compare *start to *end
	
	li $v0, 0		# Not a palindrome, return 0
	# Stack Pop
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra

Wend1: li $v0, 1		# Palindrome, return 1
	# Stack Pop
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra

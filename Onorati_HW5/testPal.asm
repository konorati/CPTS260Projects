.globl testPal

# Kristin Onorati
# CPTS 260
# HW 5

# Test harness for testing palindrome function

.data
T:
#[0]
.word 1
.asciiz ""
.space 11

#[1]
.word 1
.asciiz "a"
.space 10

#[2]
.word 1
.asciiz "eve"
.space 8

#[3]
.word 0
.asciiz "abcd"
.space 7

#[4]
.word 1
.asciiz "A BC cb a"
.space 2

U:
str1: .asciiz "Palindrome ("
str2: .asciiz ") Returned: "
str3: .asciiz "-Passed\n"
str4: .asciiz "-Failed: expected "

.text
testPal: # Stack Push
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	la $a0, T	# Set $a0 to beginning of array (T)
	la $a1, U	# Set $a1 to one past end of array (U)
	jal testPal_TU
	
	# Stack Pop
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra

testPal_TU: 
	# Stack Push
	addi $sp, $sp, -16
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)

	move $s0, $a0	# Set $s0 to start of test array (T[0])
	move $s1, $a1	# Set $s1 to one past end of test array (U)
	li $s2, 0	# Set $s2 to 0 ($s2 = # of tests passed)
	
runTest: bgeu $s0, $s1, testEnd	# End testing when pointer has reached end of test array
	addi $a0, $s0, 4	# set $a0 to start of first word to test
	jal isPalindrome	# test word
	
	# Print results of function
	move $t0, $v0
	
	# Print: Palindrome (word) returned: value
	li $v0, 4
	la $a0, str1
	syscall			
	la $a0, 4($s0)
	syscall
	la $a0, str2
	syscall
	li $v0, 1
	move $a0, $t0
	syscall
	
	# Print results of test
	lw $t1, ($s0)
	beq $t0, $t1, pass
	
	li $v0, 4
	la $a0, str4
	syscall
	li $v0, 1
	move $a0, $t1
	syscall
	j next

pass: 	li $v0, 4
	la $a0, str3
	syscall
	addi $s2, $s2, 1 	# Increment # of tests passed ($s2)
next:	addi $s0, $s0, 16	# Advance $s0 to next test in array 
	j runTest

testEnd: move $v0, $s2		# Set $v0 to # of tests passed (to return)
	
	#Stack Pop
	lw $s2, 12($sp)
	lw $s1, 8($sp)
	lw $s0, 4($sp)
	lw $ra, 0($sp)
	addi $sp, $sp, 16
	
	jr $ra			# Return # of tests passed
	

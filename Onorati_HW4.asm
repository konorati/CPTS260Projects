# Kristin Onorati HW4

main:	li $a0, 4	# Load function paramater into $a0
	jal gibbon	# gib(4)
	move $a0, $v0
	li $v0, 1	# print result of coubs(2)
	syscall
	li $v0, 10
	syscall

coubs:	move $t0, $a0 	# i = 0 (set i to $t0)  t0=2
	li $t1, 0	# sum = 0 (set sum to 0) t1=0
while1:	beqz $t0, wend	# if (i == 0) exit while loop
	mult $t0, $t0	# temp ($t2) = i^3   
	mflo $t2	
	mult $t2, $t0	
	mflo $t2	
	add $t1, $t1, $t2	# sum = sum + temp 
	addi $t0, $t0, -1	# i--		 
	j while1
wend:	move $v0, $t1
	jr $ra
	
gib:	
	# Base cases
	bgt $a0, 1, gibRecur	 # if ( n <= 1)
	li $v0, 0
	beqz $a0, return	# if( n == 0) return 0
	addi $v0, $v0, 1	# if ( n == 1) return 1
return:	jr $ra
gibRecur: 
	# Stack Push
	addi $sp, $sp, -12
	sw $a0, 4($sp)
	sw $ra 0($sp)
	
	# gib(n) = 3gib(n-1) + 2gib(n-2) + 1
	addi $a0, $a0, -1
	jal gib 	# gib(n-1)
	li $t2, 3
	mult $v0, $t2	# 3 * gib(n-1)
	mflo $t0
	lw $a0, 4($sp)	# Load $a0 from stack
	sw $t0, 8($sp)
	
	addi $a0, $a0, -2
	jal gib		# gib(n-2)
	li $t2, 2
	mult $v0, $t2	# 2 * gib(n-2)
	mflo $t1
	lw $t0, 8($sp)
	add $t0, $t0, $t1	# 3gib(n-1) + 2gib(n-2)
	addi $t0, $t0, 1	# 3gib(n-1) + 2gib(n-2) + 1
	
	# Stack Pop
	lw $ra, 0($sp)
	lw $a0, 4($sp)
	addi $sp, $sp, 12
	
	move $v0, $t0
	jr $ra

gibbon: 
	# Stack push
	addi $sp, $sp, -8
	sw $ra, 0($sp)
	
	# gibbon(n) = gib(n) + coubs(n)
	
	# gib(n)
	sw $a0, 4($sp)
	jal gib
	lw $a0, 4($sp)
	sw $v0, 4($sp)
	
	# coubs(n)
	jal coubs
	lw $t0, 4($sp)		# load gib(n) to temp
	add $v0, $v0, $t0	# gib(n) + coubs(n)
	
	# Stack Pop
	lw $ra, 0($sp)
	addi $sp, $sp 8
	
	jr $ra

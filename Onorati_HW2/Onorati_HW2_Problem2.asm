# Kristin Onroati
# CPTS 260
# HW 2 Problem 2
# Compute the sum of i*2 + 1 for i = 0 to i = 4

.data
res: .word 1		# Global variable res = 1

.text
li $t0, 0		# $t0: i = 0
lw $t1, res		# Load res from memory into $t0

for: bge $t0, 5, fend   # Exit for loop if i >= 5
sll $t1, $t1, 1		# Multiply res by 2 (by shifting bits left by 1)
addi $t1, $t1, 1	# Add 1 to res
addi $t0, $t0, 1	# i++
j for			# jump to beginning of for loop
fend: sw $t1, res	# Store res

#Print result
lw $a0, res
li $v0, 1
syscall  

#Halt
li $v0, 10
syscall

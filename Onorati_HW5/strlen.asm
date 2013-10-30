# Kristin Onorati
# CPTS 260
# HW 5

.globl strlen

# int strlen(char const *P)

strlen: li $v0, 0	#int len = 0
WHILE: lbu $t0, 0($a0)	# $t0 = *P
	addi $a0, $a0, 1 # P++
	beqz $t0, WEND
	
	addi $v0, $v0, 1	# ++len
	j WHILE
WEND: jr $ra 		# Return length of string

# Kristin Onorati
# CPTS 260
# HW 2 Problem 3
# Count length of string "hello, class" ending at 's'

.data
A: .asciiz "hello, class"	# char A[] = "hello, class"
len: .word 0		# int len = 0

.text
lw $t0, len		#load len into $t0 register
la $t1, A		# Load address of beginning a A char array   char* P = A
la $t2, A		# Load address of A (will not change)

while:
lb $t3, ($t1)		# Dereference p to load the byte (not the address)
beqz $t3, wend		# Exit while loop if *P = null character
beq $t3, 115, wend	# Exit while loop if *P = 's' (ascii = 115)
addi $t1, $t1, 1		# ++P
sub $t0, $t1, $t2 		# len = P - A
j while			# Jump back to beginning of while loop
wend: sw $t0, len	# Store len back in memory


# Print result
move $a0, $t0
li $v0, 1
syscall

# Halt
li $v0, 10
syscall




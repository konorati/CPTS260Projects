.globl swap

# Swap function - Swaps 2 integers in array
# swap (int *a, int *b)

swap:	lw $t0, ($a0)		# int temp = *a;
	lw $t1, ($a1)		# int temp2 = *b;
	sw $t0, ($a1)		# *b = temp;
	sw $t1, ($a0)		# *a = temp2;
	
	jr $ra
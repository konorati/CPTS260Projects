.globl quicksort
#---------------------------
# Quick Sort
# Quicksort(int *arr, int length)
# Changes length to pointer to one past end of array
# then calls quicksort_hilo
#----------------------------

quicksort:
	sll $a1, $a1, 2		# Convert $a0 & $a1 to pointers
	add $a1, $a0, $a1
	j quicksort_hiLo

#---------------------------------------------------
# QuickSort_hiLo(int *lo, int *hi)
# Partitions array from lo to hi, then recursively
# sorts array from lo to mid & from mid to hi
#---------------------------------------------------
quicksort_hiLo:
# Base Case
# If (Hi-Lo <= 1) { return}
	sub $t0, $a1, $a0
	ble $t0, 4, return
# Recursive Step
	addi $sp, $sp, -16		# Stack Push
	sw $ra, 0($sp)
	sw $a0, 4($sp)
	sw $a1, 8($sp)
	
	jal partition			# Partition from lo to hi
	
	sw $v1, 12($sp)
	lw $a0, 4($sp)
	move $a1, $v0			# Set $a1 to mid
	jal quicksort_hiLo			# Sort first half of array
	
	lw $a0, 12($sp)			# Set $a0 to mid & $a1 to end
	lw $a1, 8($sp)
	jal quicksort_hiLo			# Sort second half of array

	lw $ra, 0($sp)			# Stack Pop
	addi $sp, $sp, 16

return:	jr $ra
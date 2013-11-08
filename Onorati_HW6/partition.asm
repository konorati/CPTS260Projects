.globl partition

#------------------------------------------
# Partition Function
# Using end of array as pivot, sorts array 
# so everything < pivot is on the left &
# everything >= pivot is on the right
#------------------------------------------

# int* int* partition(int* lo, int* hi)
partition:	
	# Check for degenerate cases
	sub $t0, $a1, $a0
	ble $t0, 4, return
	
	addi $sp, $sp, -20		# Stack Push
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	sw $a1, 16($sp)

	lw $s0, -4($a1)		# int pivot = *hi
	move $s1, $a0		# int *left = lo
	move $s2, $a1		# int *right = hi-1
	addi $s2, $s2, -8
	
				
while2: lw $t0, ($s1)		# while arr[left] < pivot { left++;}
	bge $t0, $s0, while3
	addi $s1, $s1, 4
	j while2

while3: ble $s2, $s1, wend1
	lw $t0, ($s2)		# while (arr[right] >= pivot && right > lo{ right--;}
	blt $t0, $s0, wend2
	addi $s2, $s2, -4
	j while3

wend2: bge $s1, $s2, wend1	# if left < right {
	move $a0, $s1		# 	swap(arr[left], arr[right]) }
	move $a1, $s2
	jal swap
	j while2
		
wend1:  move $a0, $s1		# swap (arr[left], hi)
	lw $a1, 16($sp)
	addi $a1, $a1, -4
	jal swap
	
	move $v0, $s1		# v0 = left (start of region equal to pivot)
while4: addi $s1, $s1, 4	# while(*left == pivot) {left++}
	lw $t0, ($s1)
	beq $t0, $s0, while4
	move $v1, $s1		# v1 = left (start of region > pivot)
	
wend4:
	lw $s2, 12($sp)		# stack pop
	lw $s1, 8($sp)
	lw $s0, 4($sp)
	lw $ra, 0($sp)
	addi $sp, $sp, 20
	
return:	jr $ra
	
	

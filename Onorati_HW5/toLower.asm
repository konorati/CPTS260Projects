# Kristin Onorati
# CPTS 260
# HW 5

.globl toLower

# Converts character to lowercase
# char toLower(char)

toLower: move $v0, $a0
	bgt $v0, 96, end	# Return char if already lowercase
	
	addi $v0, $v0, 32		# Convert uppercase to lowercase

end:	jr $ra

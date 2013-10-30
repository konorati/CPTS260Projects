# Kristin Onorati
# CPTS 260
# HW 2 Problem 1
# Convert integer from celsius to fahrenheit

.data
str1: .asciiz "Enter degrees celsius to convert: "
.text

#Print instruction to console
li $v0, 4  #system call code for print string
la $a0, str1 #address of str1
syscall #print str1

#Get user input and put into $t0
li $v0, 5 		#system call code for get int input
syscall 		#read int from console into $v0
move $t0, $v0		 #Move int into $t0 register

#compute calculation
div $t0, $t0, 5		#divide user input $t0 by 5 and store in $t0
mul $t0, $t0, 9 	#multiply previous result ($t0) by 9
add $t0, $t0, 32	#Add 32 to previous result and store back in $t0

#print result
move $a0, $t0 		 #Store result in $a0
li $v0, 1
syscall

#halt
li $v0, 10
syscall






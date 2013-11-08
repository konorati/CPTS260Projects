# You may call these functions
.globl print_array_wpipes
.globl brutepart_t
#========================================================================
	.data
# degenerate
T0:	.word 0

# trivial: An array of length 1 is already partitioned
T1:	.word 1, 1

# ascending
Ta:	.word 3, 1 3 5

# descending
Td:	.word 5, 5 4 3 2 1

# i've got your test case
Tj:	.word 7, 8 6 7 5 3 0 9

# repeated pivots
Tp:	.word 8, 8 1 5 5 7 3 9 5

# Wikipedia
Tw:	.word 9, 3 7 8 5 2 1 9 5 4

#========================================================================
# brutepart(void)
# Does a "brute-force" sequence of 4 calls to quicksort().
#
# This does prove the following correct:
#  +1.  your `.globl` declaration
#  +2.  your quicksort(A[], len) signature
#  +3.  degenerate-case handling
#
# It does not prove the following:
#  -4.  that your quicksort() is fully working -- that's your job!
#  -5.  This is not a test harness!!
#------------------------------------------------------------------------
.globl brutepart
	.text
brutepart:
  # non-leaf
  addi	$sp, $sp, -4
  sw	$ra, 0($sp)

  la	$a0, T0
  jal	brutepart_t

  la	$a0, T1
  jal	brutepart_t

  la	$a0, Ta
  jal	brutepart_t

  la	$a0, Td
  jal	brutepart_t

  la	$a0, Tj
  jal	brutepart_t

  la	$a0, Tp
  jal	brutepart_t

  la	$a0, Tw
  jal	brutepart_t

  # pop
  lw	$ra, 0($sp)
  addi	$sp, $sp, 4
  jr	$ra

#------------------------------------------------------------------------
# void (J)
#   $a0		TestCase * T	for struct TestCase { int len; int A[]; };
# 1.  prints T->A[] before
# 2.  Calls partition(T->A, T->A + len - 1)
# 3.  prints T->A[] after
# 4.  prints a newline
#........................................................................

brutepart_t:
  # non-leaf
  addi	$sp, $sp, -16
  sw	$ra, 0($sp)

  #	T --->	[_] T.len
  #	        [_] T.A   \
  #		    ...	   | == len words
  #		[_]	  /

  lw	$t0, 0($a0)		# T->len  ==      * (T + 0)
  addi	$t1, $a0, 4		# T->A	  == <int *>(T + 4)

  # save args while we have them
  sw	$t0, 4($sp)		# [04] =  T->len
  sw	$t1, 8($sp)		# [08] =  T->A[]

  # compute &A[last] = &A[len - 1] in bytes ...
  addi	$t2, $t0, -1		#  ... &[last]
  sll	$t2, $t2,  2		#  ... in bytes
  add	$t2, $t2, $a0		# E = &T->A[last] (not 1-past-end!)
  # ... and save it
  sw	$t2, 12($sp)		# [12] = &T->A[last]

  # 1.
  lw	$a0, 4($sp)		# T->len
  lw	$a1, 8($sp)		# T->A[]
  li	$a2, 0			# not using $v0
  li	$a3, 0			# not using $v1
  jal	print_array_wpipes

  # 2.
  lw	$a0,  8($sp)		# &T->A[0]
  lw	$a1, 12($sp)		# &T->A[last]
  jal	partition

  # 3.
  #~~~~~~~~~~~~~~~~
  # << "[ (@ ... | ... ; ...) ]" << endl;
  #~~~~~~~~~~~~~~~~
  lw	$a0,  4($sp)		# T->len
  lw	$a1,  8($sp)		# T->A[]
  move	$a2, $v0		# S^<
  move	$a3, $v1		# S^=
  jal	print_array_wpipes
  
  # 4.
  jal	endl

  # pop
  lw	$ra, 0($sp)
  addi	$sp, $sp, 16
  jr	$ra

#========================================================================
# endl(void)
# Prints "\n".
# Returns nothing.
#------------------------------------------------------------------------
endl:
  li	$a0, '\n'
  li	$v0, 11		# print_char('\n');
  syscall

  # frameless leaf
  jr	$ra

#========================================================================
# void (_, _, int * P1, int * P2)
#	$t0			[NONSTD] I
#	$a2			if == I, prints "|"
#	$a3			if == I, prints ";"
# Prints:	P1	P2
#	""		!=  !=
#   "| "	==  !=
#   "; "	!=  ==
#   "|; "	==  ==
#........................................................................
# 4.0.0 erw 111219

print_pipettes_:
	# frameless leaf
	li		$v0,  0		# space-elision: 0 means neither pipe
	#~~~~
	# "|"
	#~~~~
	bne		$t0, $a2, print_pipettes_not2
	li		$a0, '|'
	li		$v0, 11		# pipe
	syscall
    
  print_pipettes_not2:
	#~~~~
	# ";"
	#~~~~
	bne		$t0, $a3, print_pipettes_not3
	li		$a0, ';'
	li		$v0, 11
	syscall
    
  print_pipettes_not3:
	#~~~~
	# " " if either or both pipes
	#~~~~
	beqz	$v0, print_pipettes_none
	li		$a0, ' '
	li		$v0, 11
	syscall

	#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  print_pipettes_none:
	jr		$ra
		
#========================================================================
# void (int len, int A[], int * P1, int * P2);
#	$a0			$len of $a1
#	$a1			array of $len 4-byte elements
#	$a2			if in [A, A + len), prints "| "
#	$a3			if in [A, A + len), prints "; "
# Prints:
#	"[ (@$a1) ]"				if ~P1,    ~P2
#									where ~ means 0 or out
#	"[ ... | ... ]"				if  P1 in, ~P2
#	"[ ... | ... ; ... ]"		if  P1 in,  P2 in
#	"[ ... |; ... ]"			if  P1 == P2 in
# Uses:
#	$t0			J = $a1
#	$t1			E = $a1 + $a0
#........................................................................

	.data
RA_QAWP:	.word 0
	.text
print_array_wpipes:
	sw		$ra, RA_QAWP

	move	$t0, $a1	#   (J = A, ...			; ...; ...)
	sll		$t1, $a0, 2	#	(..., E = $a1 + $a0	; ...; ...)
	add		$t1, $t0, $t1

	li		$a0, '['
	li		$v0, 11		#	  cerr << '[';
	syscall
	li		$a0, ' '
	li		$v0, 11		#	  cerr << ' ';
	syscall

  print_array_for:
	jal		print_pipettes_
						# for
						#   (...; J != E; ...)
	beq		$t0, $t1, print_array_end

	lw		$a0, 0($t0)
	li		$v0,  1		#     cerr << *$t0;
	syscall

	li		$a0, ' '
	li		$v0, 11		#	  cerr << ' ';
	syscall

	addi	$t0, $t0, 4	#	(...; ...; ++J)
	j		print_array_for

  print_array_end:
	jal		print_pipettes_

	li		$a0, ']'
	li		$v0, 11		#	  cerr << ']';
	syscall

	jal		endl

	lw		$ra, RA_QAWP
	jr		$ra

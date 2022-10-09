.include "./cs47_macro.asm"

.data
msg1: .asciiz "Enter a +ve number : "
msg2: .asciiz "Enter another +ve number : "
msg3: .asciiz "LCM of "
s_is: .asciiz "is"
s_and: .asciiz "and"
s_space: .asciiz " "
s_cr: .asciiz "\n"

.text
.globl main
main:
	print_str(msg1)
	read_int($s0)
	print_str(msg2)
	read_int($s1)
	
	move $v0, $zero
	move $a0, $s0
	move $a1, $s1
	move $a2, $s0
	move $a3, $s1
	jal  lcm_recursive
	move $s3, $v0
	
	print_str(msg3)
	print_reg_int($s0)
	print_str(s_space)
	print_str(s_and)
	print_str(s_space)
	print_reg_int($s1)
	print_str(s_space)
	print_str(s_is)
	print_str(s_space)
	print_reg_int($s3)
	print_str(s_cr)
	exit

#------------------------------------------------------------------------------
# Function: lcm_recursive 
# Argument:
#	$a0 : +ve integer number m
#       $a1 : +ve integer number n
#       $a2 : temporary LCM by increamenting m, initial is m
#       $a3 : temporary LCM by increamenting n, initial is n
# Returns
#	$v0 : lcm of m,n 
#
# Purpose: Implementing LCM function using recursive call.
# 
#------------------------------------------------------------------------------
lcm_recursive:
	# Store frame
	addi $sp, $sp, -28 #clear spaces for stack
	sw $fp, 28($sp) #frame pointer
	sw $ra, 24($sp) #return adress
	sw $a0, 20($sp) #m
	sw $a1, 16($sp) #n
	sw $a2, 12($sp) #lcm_m
	sw $a3, 8($sp)  #lcm_n
	addi $fp, $sp, 28 #set $fp to $sp's previous position
	
        # Body
        beq $a2, $a3, END # if (lcm_m == lcm_n) jump to END
	bgt $a2, $a3, LCMN # if (lcm_m > lcm_n) jump to LCMN 
	add $a2, $a2, $a0 # else lcm_m = lcm_m + m;
	jal  lcm_recursive #return m, n, lcm_m, lcm_n
        j RETURN #jump to restore frame to prevent an infinite loop
        #After call to recursion, restore frame to prevent it from overflowing/going out of range
        
LCMN: add $a3, $a3, $a1 #lcm_n = lcm_n + n;
      j lcm_recursive #return m, n, lcm_m, lcm_n
      j RETURN #jump to restore frame 
      
END:    move $v0, $a2 #save $a2 in $v0

RETURN: # Restore frame
	lw $fp, 28($sp) #frame pointer
	lw $ra, 24($sp) #return address
	lw $a0, 20($sp) #m
	lw $a1, 16($sp) #n
	lw $a2, 12($sp) #lcm_m
	lw $a3, 8($sp) #lcm_n
	addi $sp, $sp, 28 #restore 4 spaces in stack
	jr $ra #jump to statememt whose adress is in $ra; original function call
	

# #####################################################################
# CSCB58 Summer 2023 Assembly Final Project
# University of Toronto, Scarborough
#
# Student: Yatin Malhotra,  1009083135, malho351, yatin.malhotra@mail.utoronto.ca
# Bitmap Display Configuration:
# - Unit width in pixels: 8 
# - Unit height in pixels: 8 
# - Display width in pixels: 512 
# - Display height in pixels: 512 
# - Base Address for Display: 0x10008000 ($gp)
#
# Which milestones have been reached in this submission?
# (See the assignment handout for descriptions of the milestones) 
# - Milestone 1 and 2
#
# Which approved features have been implemented for milestone 3?
# (See the assignment handout for the list of additional features) 
# 1. (fill in the feature, if any)
# 2. (fill in the feature, if any)
# 3. (fill in the feature, if any)
# ... (add more if necessary)
#
# Link to video demonstration for final submission:
# - (insert YouTube / MyMedia / other URL here). Make sure we can view it! 
# Are you OK with us sharing the video with people outside course staff?
# - yes / no / yes, and please share this project github link as well! 
# Any additional information that the TA needs to know:
# - (write here, if any)
# #####################################################################

.eqv BASE_ADDRESS 0x10008000
.eqv GREEN 0x0ff00
.eqv BROWN 0x964B00
.eqv YELLOW 0x00ffff
.eqv BLUE 0xADD8E6

.text

main:
	li $t1, BLUE 			# Center portion color
	li $t2, BROWN			# Border color
	j create_background		# Create the background

create_background:
	move $a0, $gp			# Set $a0 to the place to write
	li $a1, 65			# 65 pixels (full top row + one pixel on the left column)
	move $a2, $t2			# BROWN
	jal set_pixels			# set_pixels
	li $t0, 62			# 62 rows of blue
	j blue_rows_loop

blue_rows_loop:
	li $a1, 62
	move $a2, $t1
	jal set_pixels			# Set the 62 middle pixels to blue
	j finish_border			# Finish the border after done
	
finish_border:
	sw $t2, ($a0)
	sw $t2, 4($a0)
	addi $a0, $a0, 8
	addi $t0, $t0, -1
	bnez $t0, blue_rows_loop
	
	li $a1, 63
	move $a2, $t2
	jal set_pixels
	
	li $t0, BASE_ADDRESS    	# Set $t0 to BASE_ADDRESS
    
    	move $a0, $t0 			# Set a0 to BASE_ADDRESS (will be changed to the current position)
    	move $a1, $t0 			# Set a1 to BASE_ADDRESS (will be changed to the new position)
	
	jal character
	j input_checker

set_pixels:
	sw      $a2, ($a0)      	# set pixel
    	addi    $a0, $a0, 4     	# advance memory pointer
    	addi    $a1, $a1, -1    	# count-down loop
    	bnez    $a1, set_pixels
    	jr      $ra             	# return
    
input_checker:
	li $t9, 0xffff0000
    	lw $t8, 0($t9)
    	beq $t8, 1, input_detected      # if any input, go to the input function
    	j input_checker             	# else go keep checking for any input

input_detected:
	lw $t5, 4($t9)
    	beq $t5, 0x61, move_left	# if input is 'a', move left
    	beq $t5, 0x77, top_check	# if input is 'w', move up
    	beq $t5, 0x73, climb_down	# if input is 's', move down
    	beq $t5, 0x64, move_right	# if input is 'd', move right
    	beq $t5, 0x71, exit		# if input is 'p', restart the game (currently exiting)

	j input_checker

top_check:
	li $t2, BASE_ADDRESS		# Set $t2 to the BASE_ADDRESS
	move $a0, $t0
	addi $t0, $t0, -256         	# Update the value of $t0 (moving left means -256 pixels)

	ble $t2, $t0, climb_up
	bgt $t2, $t0, reset_top_val

reset_top_val:
	addi $t0, $t0, 256
    
	jal character
    
	j input_checker

move_left:
	move $a0, $t0               	# Set $a0 to the current position
	addi $t0, $t0, -4           	# Update the value of $t0 (moving left means -4 pixels)
	move $a1, $t0               	# Set $a1 to $t0 (the new position)

	jal character

	j input_checker

move_right:
 	move $a0, $t0               	# Set $a0 to the current position
	addi $t0, $t0, 4            	# Update the value of $t0 (moving right means +4 pixels)
	move $a1, $t0               	# Set $a1 to $t0 (the new position)

	jal character

	j input_checker

climb_up:
 	move $a1, $t0               	# Set $a1 to $t0 (the new position)

	jal character

	j input_checker

climb_down:
	move $a0, $t0               	# Set $a0 to the current position
	addi $t0, $t0, 256          	# Update the value of $t0 (moving left means +256 pixels)
	move $a1, $t0               	# Set $a1 to $t0 (the new position)

	jal character

	j input_checker

character:
	li $t1, YELLOW			# Set $t1 to YELLOW
    	li $t3, BLUE        		# Set $t7 to BLUE

    	sw $t3, 0($a0)          	# Change the current pixel to BLUE
    	sw $t1, 0($a1)          	# Change the newer pixel to the character

    	jr $ra

exit:
	li $v0, 10
    	syscall
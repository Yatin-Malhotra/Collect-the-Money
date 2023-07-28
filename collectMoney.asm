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

.text
    li $t0, BASE_ADDRESS    # Set $t0 to BASE_ADDRESS
    
    move $a0, $t0 # Set a0 to BASE_ADDRESS (will be changed to the current position)
    move $a1, $t0 # Set a1 to BASE_ADDRESS (will be changed to the new position)

    # Call a function that creates the basic layout of the level

    jal character

main:
    # Check for any keyboard input
    li $t9, 0xffff0000
    lw $t8, 0($t9)
    beq $t8, 1, input           # if any input, go to the input function
    j main                      # else go keep checking for any input

input:
    lw $t5, 4($t9)
    beq $t5, 0x61, move_left    # if input is 'a', move left
    beq $t5, 0x77, climb_up     # if input is 'w', move up
    beq $t5, 0x73, climb_down   # if input is 's', move down
    beq $t5, 0x64, move_right   # if input is 'd', move right
    beq $t5, 0x71, exit         # if input is 'p', restart the game (currently exiting)

    j main                      # jump to main 

move_left:
    move $a0, $t0               # Set $a0 to the current position
    addi $t0, $t0, -4           # Update the value of $t0 (moving left means -4 pixels)
    move $a1, $t0               # Set $a1 to $t0 (the new position)

    # Check to make sure that the person doesn't go out of the bounds

    jal character

    j main

move_right:
    move $a0, $t0               # Set $a0 to the current position
    addi $t0, $t0, 4            # Update the value of $t0 (moving right means +4 pixels)
    move $a1, $t0               # Set $a1 to $t0 (the new position)

    jal character

    j main

climb_up:
    move $a0, $t0               # Set $a0 to the current position
    addi $t0, $t0, -256         # Update the value of $t0 (moving left means -256 pixels)
    move $a1, $t0               # Set $a1 to $t0 (the new position)

    jal character

    j main

climb_down:
    move $a0, $t0               # Set $a0 to the current position
    addi $t0, $t0, 256          # Update the value of $t0 (moving left means +256 pixels)
    move $a1, $t0               # Set $a1 to $t0 (the new position)

    jal character

    j main

character:
    li $t1, 0xffff00        # Set $t1 to YELLOW
    li $t3, 0x000000        # Set $t7 to BLACK

    sw $t3, 0($a0)          # Change the current pixel to BLACK
    sw $t1, 0($a1)          # Change the newer pixel to the character

    jr $ra

exit:
    li $v0, 10
    syscall

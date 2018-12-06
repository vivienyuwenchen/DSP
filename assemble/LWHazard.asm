addi $t3, $zero, 2
addi $sp, $sp, -4
sw $t3, 0($sp)
addi $t4, $zero, 3
addi $t5, $zero, 5

lw $s0, 0($sp)
addi  $sp, $sp, 4
add $t0, $s0, $t4
add $t0, $s0, $t5
sub $t2, $s0, $t3
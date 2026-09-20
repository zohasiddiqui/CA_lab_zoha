.text 
main:
# using below values for testing purposes
li x10,2 #x10=g=2
li x11,3 #x11=h=3
li x12,7 #x10=i=7
li x13,4 #x11=j=4

li sp,0x100 # making the stack pointer point to memory address 0x100

jal x1, leaf_example
j exit

leaf_example:
addi sp,sp, -16
sw x20, 8(sp)
sw x18, 4(sp)
sw x19, 0(sp)

add x18,x10,x11 # adds g and h and stores the result in x18
add x19,x12,x13 # adds i and j and stores the result in x19
sub x20,x18,x19 # subtracts value in x19 from value in x18 and stores the result in x20

#f is in x20 but in order to return its value, need to move it to a0
addi x10,x20,0

# need to retrieve values from stack and restore them in registers x18-x20
lw x19, 0(sp)
lw x18, 4(sp)
lw x20, 8(sp)
addi sp,sp,16 # moves back the stack pointer in its original position

jalr x0,0(x1)

exit:


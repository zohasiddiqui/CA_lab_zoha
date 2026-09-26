.text
main:
li sp, 0x100 # for testing setting the sp at 0x100
li x10, 6 # num = 6
jal x1, ntri
j exit 

ntri:
addi sp,sp,-8 # creates the stack frame for 2 elements 
sw x10, 4(sp)
sw x1, 0(sp)

li x5, 1 # 1 is needed to check base case

blt x5, x10, else 
addi sp,sp, 8 # need to move stack pointer back 
li x10, 1 # need to return if if condition met
jalr x0, 0(x1)

else:
addi x10,x10,-1
jal x1, ntri 

lw x6, 0(sp) # x6=return address of caller
lw x7, 4(sp) # x7= num
addi sp,sp,8

add x10,x10,x7
jalr x0, 0(x6)

exit: j exit 


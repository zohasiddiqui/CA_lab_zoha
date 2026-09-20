.text 
main:
# base addresses of x and y in x10,x11
li x10,0x100
li x11,0x200

# creating the array y[] just to test code
li x5,72          # H
sb x5,0(x11)

li x5,69          # E
sb x5,1(x11)

li x5,76          # L
sb x5,2(x11)

li x5,76          # L
sb x5,3(x11)

li x5,79          # O
sb x5,4(x11)

li x5,0           # null terminator
sb x5,5(x11)

#function call
jal x1, strcpy 
j exit 

strcpy:
addi sp,sp,-8
sw x19, 0(sp) # stores the contents of the saved reg x19 on the stack so that x19 can be used by strcpy

li x19, 0 # x19=i, i initialized as 0

loop:
# each character is 1 byte 
add x5,x19,x10 # calculates address of x[i]
add x6,x19,x11 #calculates address of y[i]

lb x6, 0(x6) # x6=y[i]
sb x6, 0(x5)
beq x6,x0, return
addi x19,x19,1
j loop

return:
lw x19, 0(sp) # restores value of x19 from stack 
addi sp,sp,8
jalr x0, 0(x1)

exit:
j exit 
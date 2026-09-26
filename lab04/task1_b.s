.text
main:
li x10, 5 # n=5
jal x1, fact #function call with argument n=5
j exit 

fact:
li x5, 1 # x5= acc, initialized with 1

loop:
bge x0, x10, return
mul x5,x5,x10 # acc = acc*n
addi x10,x10,-1 # n = n-1
j loop

return:
add x10,x0,x5 # puts the final value of acc in which is the result of the factorial in x10 before returning
jalr x0,0(x1) # returns to main

exit: j exit 

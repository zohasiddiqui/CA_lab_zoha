.text
main:
# using below values for testing purposes
# x10 = base address of array v
# x11 = k

li x10,0x100          # x10 = starting address of array v
li x11,1              # x11 = k = 1

# assigning some values to v[k] and v[k+1] for testing
li x5,3
li x6,4
sw x5,4(x10) # v[1] = 3
sw x6,8(x10) # v[2] = 4

# calling the swap function
jal x1,swap
j exit

swap:
# using temporary registers so no need for stack 

slli x5,x11,2 # offset of k
add x5,x5,x10 # adds offset to base adress so now x18 stores address of v[k]
lw x6,0(x5) # x6=temp = v[k]
lw x7,4(x5) # x7 = v[k+1]

# swap the values
sw x7, 0(x5) # v[k] = v[k+1]
sw x6, 4(x5) # v[k+1] = temp

jalr x0,0(x1) # return to caller 

exit:



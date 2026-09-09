# the variables i and sum are in x22 and x23
# array a located at address 0x200 is of 4-byte integers

.text
main:

li x21,10 # storing constant 10 in x21
li x22,0 # x22 stores i. initialising it with 0
li x20, 0x200 # stores base address of a in x20

for1:
bge x22,x21, reset 
slli x24,x22,2 # stores offset from base address of a in x24
add x24,x24,x20 #adds base address to offset 
sw x22, 0(x24) # a[i] = i
addi x22,x22,1 # increments i by 1
j for1


reset:
li x22,0 # resets i to 0
li x23,0 # initializes sum as 0

for2:
bge x22,x21, end
slli x24,x22,2 # stores offset from base address of a in x24
add x24,x24,x20 #adds base address to offset 
lw x25, 0(x24) #loads value from a[i] in x25
add x23,x23,x25 # sum = sum + a[i]
addi x22,x22,1 # increments i by 1
j for2

end: j end



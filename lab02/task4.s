# a, b, i, and j are in registers x5, x6, x7, x29
# x10 holds the base address of the array D

.text
main:

li x5,2 # x5 stores a=2
li x6,3 # x6 stores b=3
li x10, 0x100 # x10 holds base address of array D

#initialize i and j with 0
li x7,0
li x29,0

for1:
bge x7,x5, end 
for2:
bge x29,x6, ipp
slli x8,x29, 4 # x8 stores offset. this assumes that D is an int arr 
add x8,x8,x10 # adds offset to base address
add x9,x7,x29 # stores i+j in x9
sw x9, 0(x8)
addi x29,x29,1 # increments j by 1
j for2

ipp:
addi x7,x7,1
li x29, 0 #resets j
j for1

end: j end
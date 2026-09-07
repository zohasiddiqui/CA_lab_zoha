# task 4b
.text
.globl main 
main: 
li x5, 0x100        # x5 = address of a
li x6, 0x200        # x6 = address of b
li x7, 0x300        # x7 = address of c

# i = 0
lb x28, 0(x5)      # x28 stores a[0]
lh  x29, 0(x6)      # x29 stores b[0]
add x30, x28, x29   # x30 stores a[0] + b[0]
sw  x30, 0(x7)      # stores value in x30 at c[o]  

# i = 1
lb x28, 1(x5)      # x28 stores a[1]
lh  x29, 2(x6)      # x29 stores b[1]
add x30, x28, x29   # x30 stores a[1] + b[1]
sw  x30, 4(x7)      # stores value in x30 at c[1]

# i = 2
lb x28, 2(x5)      # x28 stores a[2]
lh  x29, 4(x6)      # x29 stores b[2]
add x30, x28, x29   # x30 stores a[2] + b[2]
sw  x30, 8(x7)      # stores value in x30 at c[2]

# i = 3
lb x28, 3(x5)      # x28 stores a[3]
lh  x29, 6(x6)      # x29 stores b[3]
add x30, x28, x29   # x30 stores a[3] + b[3]
sw  x30, 12(x7)     # stores value in x30 at c[3]


# ALTERNATIVE METHOD USING LOOP

# li x5, 0x100        # x5 = address of a
# li x6, 0x200        # x6 = address of b
# li x7, 0x300        # x7 = address of c

# li x8,0 # x8 = i
# li x9,4

# for:
# bge x8,x9, end 

# # since a is a char array and each char is 1 byte, the offset is just i so we add it to base adress of a 
# add x20,x5,x8 # x20 has the address for the ith element of a
# lb x21, 0(x20) # x21 stores a[i]

# # b is a short array. each short takes 2 bytes so to calculate offset we need to multiply by 2 so we use slli where imm is 1 to shift left once
# slli x22,x8,1 #x22 stores the offset for b (i*2)
# add x23,x22,x6 #x23 stores the address for the  ith element of b by adding offset to base address of b in x6
# lh x24, 0(x23) # x24 stores b[i]

# add x25,x21,x24 #x25 stores the value of c[i]

# # c is an unsigned integer array so to calculate offset we multiply by 4 so use slli wih imm=2
# slli x26,x8,2 # x26 stores offset for c (i*4)
# add x27,x7,x26 # x27 stores the address of the ith element of c
# sw x25, 0(x27) # stores the value of c[i] in memory 

# addi x8,x8,1
# j for 

end:
    j end 
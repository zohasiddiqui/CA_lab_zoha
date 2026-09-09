.text
main:
li x25, 0x100 #base address of save array

# storing array elements in temporary registers
li x5,10
li x6,10
li x7,10
li x8,20
li x9,30

#loading elements in save array in memory
sw x5, 0(x25)
sw x6, 4(x25)
sw x7, 8(x25)
sw x8, 12(x25)
sw x9, 16(x25)

li x24, 10 # x24 stores k=10
li x22, 0 # x22 stores i

loop:
    slli x10,x22,2
    add x10,x10,x25
    lw x9,0(x10)
    bne x9,x24, Exit 
    addi x22,x22,1
    beq x0,x0, loop
Exit:
    j Exit 
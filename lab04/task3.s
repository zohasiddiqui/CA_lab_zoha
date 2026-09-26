.text
.globl main
main:
    li x11, 4       # len = 4
    li x10, 0x100    # Base address of a 
    
    li x5, 9
    sw x5, 0(x10)
    li x5, 6
    sw x5, 4(x10)
    li x5, 8
    sw x5, 8(x10) 
    li x5, 2
    sw x5, 12(x10) 
    # a = [9,6,8,2]

    jal x1, bubble_sort

    end: j end

bubble_sort:
    beq x10, x0, return  #if a == NULL return 
    beq x11, x0, return  #if len == 0 return 

    li x5, 0            # x5 = i, initialized with 0 
outer_loop:
    bge x5, x11, return         # if i >= len return
    addi x6, x5, 0            # x6 = j, initialized as j=i
    slli x29, x5, 2          # offset = i * 4
    add x29, x29, x10        # x29 gets address of a[i]
    lw x31, 0(x29)           # x31 = a[i] = temp 
inner_loop:
    bge x6, x11, ipp         # if j >= len, j loop has ended so increment i
    slli x28, x6, 2          # offset = j * 4
    add x28, x28, x10        # x28 gets address of a[j]
    lw x30, 0(x28)           # x30 = a[j] 
    
    bge x31, x30, jpp    # if a[i] >= a[j] go to no_swap
    sw x31, 0(x28)           # a[j] = a[i]
    sw x30, 0(x29)           # a[i] = a[j]
jpp: 
    addi x6, x6, 1           # j++
    j inner_loop             # repeats inner loop
ipp:
    addi x5, x5, 1           # i++
    j outer_loop             # repeats outer loop

return:
jalr x0, 0(x1)



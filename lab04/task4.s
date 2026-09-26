.text
.globl main

main:
li x10, 0x100          # x10 = base address of array
li x11, 5              # x11 = length
# array [10,20,30,40,50] for testing
li x5, 10
sw x5, 0(x10)
li x5, 20
sw x5, 4(x10)
li x5, 30
sw x5, 8(x10)
li x5, 40
sw x5, 12(x10)
li x5, 50
sw x5, 16(x10)

jal x1, average # function call to calculate average of the elements of the array

#when program returns to main from average x10 now contains average = 30
end:
    j end

# average(array, length)
average:
    # Save return address and length on the stack 
    addi sp, sp, -8 #creating stack frame
    sw ra, 4(sp)
    sw x11, 0(sp)

    # Call array_sum with array in x10 and length in x11
    jal x1, array_sum

    # when program return here from sum, x10 now contains the sum
    # Restore length
    lw x11, 0(sp)
    # Restore return address
    lw ra, 4(sp)
    addi sp, sp, 8

    # Calculate average = sum / length
    div x10, x10, x11 
    # x10 now contain value of average with which it now returns to main
    ret


# array_sum(array, length)
array_sum:
    li x5, 0              # i = 0
    li x6, 0              # sum = 0

loop:
    bge x5, x11, return1 # if i >= length, stop

    # Calculate address of array[i]
    slli x7, x5, 2        # offset = i * 4
    add x7, x10, x7       # address = base + offset

    # Load array[i]
    lw x8, 0(x7)

    # Add array[i] to sum
    add x6, x6, x8

    # i++
    addi x5, x5, 1
    j loop


return1: # return to average with the value of sum in x10
    addi x10, x6, 0
    ret
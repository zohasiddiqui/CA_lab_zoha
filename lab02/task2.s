.text
main:
# x,a,b,c in registers x20-x23

# assigning values to b and c
li x22, 5
li x23, 10

# assigning a value to x to test
li x20, 3

#initialising a register with 1 for comparison with x
li x5,1

case1:
    bne x20,x5, case2
    add x21,x22,x23
    j end
case2:
    li x5,2
    bne x5,x20,case3
    sub x21,x22,x23
    j end
case3:
    li x5,3
    bne x20,x5,case4
    slli x21,x22,1
    j end
case4:
    li x5,4
    bne x5,x20,default 
    srli x21,x22,1
    j end 
default:
    li x21,0

end:
    j end
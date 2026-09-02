.text
.globl main 
main:
    li x5,5 #a=5
    li x8,5 #stores 5
    add x6, x0, x0 #b=0+0
    addi x5,x6,32 # a=b+32

    add x7,x5,x6 # d= a+b
    sub x7,x7,x8 #d= a+b - 5

    sub x9,x5,x7 # e is x9
    sub x10,x6,x5 #x10 is temperory 
    add x9,x9,x10
    add x9,x9,x7

    #a=x5, b=x6, d=x7, e=x9

    add x11,x6,x5
    add x11,x11,x7
    add x11,x11,x9
    add x9,x11,x0

end:
    j end 


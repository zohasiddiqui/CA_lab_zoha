.text
main:
    li x22, 22 #x22 is i
    li x23, 23 #x23 is j
    li x20, 20 #x20 is g
    li x21, 21 #x21 is h

    bne x22,x23, Else
    add x19,x20,x21
    beq x0,x0, Exit

Else:
    sub x19,x20,x21

Exit:
    j Exit 
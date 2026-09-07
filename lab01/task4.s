# task 4a

.text
.globl main 
main:    
    li x10,0x78786464
    li x11, 0xA8A81919

    li x21, 0x100
    li x22, 0x1F0

    sw x10, 0(x21)

    sw x11, 0(x22)

    lhu x12, 0(x21)

    lh x13, 0(x22)

    lb x14, 0(x22)


end:
    j end
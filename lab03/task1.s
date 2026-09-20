.text
main:

addi x10,x0,12 # first puts a=12 in the the argument register a0
addi x11,x0,12 # then puts b=12 in a1
# now a and b are in the argument registers before the function sum is called 
jal x1, sum # calls the function sum and stores the return address to main in x1

# after the program returns to main from sum, a0 contain the result of sum
addi x11,x10,0 # this line moves the result of sum to x11 so that it can be printed  
li x10,1 # puts the id of print_int ecall in x10
ecall # prints the sum 
j exit 

sum:
add x10,x10,x11 # adds a and b and stores the result in x10 so that it can be returned 
jalr x0,0(x1) # returns to main

exit:
j exit
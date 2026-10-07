`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/06/2026 01:45:39 PM
// Design Name: 
// Module Name: ALUtb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ALUtb(

    );
    reg [31:0] A;
reg [31:0] B;
reg [3:0] ALUControl;

wire [31:0] ALUResult;
wire Zero;

// Instantiate the ALU
ALU A1 (A,B,ALUControl,ALUResult,Zero);

initial begin

    // ADD
    A = 32'd10; //a=10
    B = 32'd5; //b=5
    ALUControl = 4'b0000;  
    #10;

    // SUB
    ALUControl = 4'b0001; 
    #10;

    // AND
    ALUControl = 4'b0010; 
    #10;

    // OR
    ALUControl = 4'b0011;
    #10;

    // XOR
    ALUControl = 4'b0100;
    #10;

    // SLL
    A = 32'd1;
    B = 32'd2;
    ALUControl = 4'b0101; // A<<B[4:0] THAT IS 0001 << 2= 0100
    #10;

    // SRL
    A = 32'd16;
    B = 32'd2;
    ALUControl = 4'b0110; // A>>B[4:0]
    #10;
     
    // Zero (BEQ type check)
    A = 32'd10;
    B = 32'd10;
    ALUControl = 4'b0001; // TO CHECK BEQ WE PERFORM SUB OP  10-10=0
    #10;

    $finish;

end
endmodule

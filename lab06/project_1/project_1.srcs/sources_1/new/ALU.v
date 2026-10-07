`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/06/2026 01:04:26 PM
// Design Name: 
// Module Name: ALU
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

module ALU(
    input [31:0] A,
    input [31:0] B,
    input [3:0] ALUControl,
    output reg [31:0] ALUResult,
    output Zero
);
//we have reg ALUresult because it is assigned inside an always block
always @(*) begin // running this block whenever any input used changes
    case (ALUControl) // checks the value of ALU control compare it then perform respective operATION

        4'b0000: ALUResult = A + B;        // ADD

        4'b0001: ALUResult = A - B;        // SUB

        4'b0010: ALUResult = A & B;        // AND

        4'b0011: ALUResult = A | B;        // OR

        4'b0100: ALUResult = A ^ B;        // XOR

        4'b0101: ALUResult = A << B[4:0];  // SLL 
       // taking B[4:0] because for a 32 bit value the shift amount only needs 5 bits

        4'b0110: ALUResult = A >> B[4:0];  // SRL

        default: ALUResult = 32'b0;

    endcase
end

assign Zero = (ALUResult == 32'b0); //if aluresult==0 then Zero=1

endmodule
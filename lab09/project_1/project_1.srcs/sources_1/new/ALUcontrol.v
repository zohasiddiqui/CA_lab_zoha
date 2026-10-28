`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/28/2026 01:47:16 PM
// Design Name: 
// Module Name: ALUcontrol
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


module ALUControl(
    input [1:0] ALUOp,
    input [2:0] funct3,
    input [6:0] funct7,
    output reg [3:0] ALUControl
);

always @(*) begin
    ALUControl = 4'b0000; // Default ADD

    case (ALUOp)

        2'b00: begin
            ALUControl = 4'b0000; // ADD
        end

        2'b01: begin
            ALUControl = 4'b0001; // SUB (BEQ)
        end

        2'b10: begin
            // R-type instructions
            case (funct3)

                3'b000: begin
                    if (funct7 == 7'b0100000)
                        ALUControl = 4'b0001; // SUB
                    else
                        ALUControl = 4'b0000; // ADD
                end

                3'b001: ALUControl = 4'b0101; // SLL

                3'b101: ALUControl = 4'b0110; // SRL

                3'b111: ALUControl = 4'b0010; // AND

                3'b110: ALUControl = 4'b0011; // OR

                3'b100: ALUControl = 4'b0100; // XOR

                default: ALUControl = 4'b0000;
            endcase
        end

        default: ALUControl = 4'b0000;

    endcase
end

endmodule


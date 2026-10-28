`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/28/2026 02:12:17 PM
// Design Name: 
// Module Name: ControlUnit_tb
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


module tb_ControlUnit;

reg [6:0] opcode;
reg [2:0] funct3;
reg [6:0] funct7;

wire RegWrite, MemRead, MemWrite;
wire ALUSrc, MemtoReg, Branch;
wire [1:0] ALUOp;
wire [3:0] ALUControl;

// Main Control Unit
MainControl main_unit (
    .opcode(opcode),
    .RegWrite(RegWrite),
    .ALUOp(ALUOp),
    .MemRead(MemRead),
    .MemWrite(MemWrite),
    .ALUSrc(ALUSrc),
    .MemtoReg(MemtoReg),
    .Branch(Branch)
);

// ALU Control Unit
ALUControl alu_unit (
    .ALUOp(ALUOp),
    .funct3(funct3),
    .funct7(funct7),
    .ALUControl(ALUControl)
);

initial begin
    opcode = 0;
    funct3 = 0;
    funct7 = 0;

    // ADD
    #10;
    opcode = 7'b0110011;
    funct3 = 3'b000;
    funct7 = 7'b0000000;

    // ADDI
    #10;
    opcode = 7'b0010011;
    funct3 = 3'b000;
    funct7 = 7'b0000000;

    // SUB
    #10;
    opcode = 7'b0110011;
    funct3 = 3'b000;
    funct7 = 7'b0100000;

    // SLL
    #10;
    opcode = 7'b0110011;
    funct3 = 3'b001;
    funct7 = 7'b0000000;

    // SRL
    #10;
    opcode = 7'b0110011;
    funct3 = 3'b101;
    funct7 = 7'b0000000;

    // AND
    #10;
    opcode = 7'b0110011;
    funct3 = 3'b111;
    funct7 = 7'b0000000;

    // OR
    #10;
    opcode = 7'b0110011;
    funct3 = 3'b110;
    funct7 = 7'b0000000;

    // XOR
    #10;
    opcode = 7'b0110011;
    funct3 = 3'b100;
    funct7 = 7'b0000000;

    // LW
    #10;
    opcode = 7'b0000011;
    funct3 = 3'b010;
    funct7 = 7'b0000000;

    // LH
    #10;
    opcode = 7'b0000011;
    funct3 = 3'b001;
    funct7 = 7'b0000000;

    // LB
    #10;
    opcode = 7'b0000011;
    funct3 = 3'b000;
    funct7 = 7'b0000000;

    // SW
    #10;
    opcode = 7'b0100011;
    funct3 = 3'b010;
    funct7 = 7'b0000000;

    // SH
    #10;
    opcode = 7'b0100011;
    funct3 = 3'b001;
    funct7 = 7'b0000000;

    // SB
    #10;
    opcode = 7'b0100011;
    funct3 = 3'b000;
    funct7 = 7'b0000000;

    // BEQ
    #10;
    opcode = 7'b1100011;
    funct3 = 3'b000;
    funct7 = 7'b0000000;

    #10;
    $finish;
end

endmodule

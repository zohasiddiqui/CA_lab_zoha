`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/16/2026 03:21:06 PM
// Design Name: 
// Module Name: registerfile
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


module registerfile(
input clk,
    input rst,
    input WriteEnable,
    input [4:0] rs1,
    input [4:0] rs2,
    input [4:0] rd,
    input [31:0] WriteData,
    output [31:0] ReadData1,
    output [31:0] ReadData2
    );
    reg [31:0] regs [0:31];  //reg[31:0] tells that each register stores 32 bits and regs[31:0] tells that we are using total 32 registers
    integer i; //loop counter used to access each of the 32 registers

    // Synchronous write and reset
    always @(posedge clk) begin //it runs whenver clock changes from 0-1
        if (rst) begin
            for (i = 0; i < 32; i = i + 1) begin
                regs[i] <= 32'b0; //is rst-1 then all 32 registers are cleared to 0 at next rising edge
            end
        end
        else if (WriteEnable && rd != 5'd0) begin //this makes sure that writeenable=1 and rd is not x0 since x0 doesnt allow writes
            regs[rd] <= WriteData;
        end
    end

    // Asynchronous read ports
    assign ReadData1 = (rs1 == 5'd0) ? 32'b0 : regs[rs1]; //if rs1==0 output zero other wise output value stored in rs2
    assign ReadData2 = (rs2 == 5'd0) ? 32'b0 : regs[rs2];

endmodule
    
    


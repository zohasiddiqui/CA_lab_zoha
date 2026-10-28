
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/21/2026 01:56:12 PM
// Design Name: 
// Module Name: DataMemory
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



`timescale 1ns / 1ps

module DataMemory(
    input clk,
    input MemWrite,
    input [8:0] address,
    input [31:0] write_data,
    output [31:0] read_data
);

    reg [31:0] memory [0:511];

    // Write data on the rising clock edge
    always @(posedge clk) begin
        if (MemWrite)
            memory[address] <= write_data;
    end

    // Read data from the selected address
    assign read_data = memory[address];

endmodule
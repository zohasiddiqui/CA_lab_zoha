
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/21/2026 01:59:05 PM
// Design Name: 
// Module Name: AddressDecoder
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

module AddressDecoder(
    input [31:0] address,
    input readEnable,
    input writeEnable,

    output reg DataMemWrite,
    output reg DataMemRead,
    output reg LEDWrite,
    output reg SwitchReadEnable
);

always @(*) begin

    DataMemWrite = 0;
    DataMemRead = 0;
    LEDWrite = 0;
    SwitchReadEnable = 0;

    if (address <= 32'd1023) begin

        if (address[9] == 1'b0) begin
            DataMemWrite = writeEnable;
            DataMemRead = readEnable;
        end

        else if (address[9:8] == 2'b10) begin
            LEDWrite = writeEnable;
        end

        else if (address[9:8] == 2'b11) begin
            SwitchReadEnable = readEnable;
        end

    end

end

endmodule

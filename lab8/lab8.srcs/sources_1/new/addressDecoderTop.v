
`timescale 1ns / 1ps

module addressDecoderTop(
    input clk,
    input rst,
    input [31:0] address,
    input readEnable,
    input writeEnable,
    input [31:0] writeData,
    input [15:0] switches,

    output reg [31:0] readData,
    output [15:0] leds
);

    // Internal enable signals
    wire DataMemWrite;
    wire DataMemRead;
    wire LEDWrite;
    wire SwitchReadEnable;

    // Data coming from memory and switches
    wire [31:0] memoryReadData;
    wire [31:0] switchReadData;

    // Address decoder
    AddressDecoder decoder(
        .address(address),
        .readEnable(readEnable),
        .writeEnable(writeEnable),
        .DataMemWrite(DataMemWrite),
        .DataMemRead(DataMemRead),
        .LEDWrite(LEDWrite),
        .SwitchReadEnable(SwitchReadEnable)
    );

    // Data Memory
    DataMemory data_mem(
        .clk(clk),
        .MemWrite(DataMemWrite),
        .address(address[8:0]),
        .write_data(writeData),
        .read_data(memoryReadData)
    );

    // LED module
    leds led_unit(
        .clk(clk),
        .rst(rst),
        .writeData(writeData),
        .writeEnable(LEDWrite),
        .readEnable(1'b0),
        .memAddress(address[31:2]),
        .readData(),
        .leds(leds)
    );

    // Switch module
    switches switch_unit(
        .clk(clk),
        .rst(rst),
        .btns(16'b0),
        .writeData(32'b0),
        .writeEnable(1'b0),
        .readEnable(SwitchReadEnable),
        .memAddress(address[31:2]),
        .switches(switches),
        .readData(switchReadData)
    );

    // Select data returned to the CPU
    always @(*) begin
        readData = 32'b0;

        if (DataMemRead)
            readData = memoryReadData;
        else if (SwitchReadEnable)
            readData = switchReadData;
    end

endmodule

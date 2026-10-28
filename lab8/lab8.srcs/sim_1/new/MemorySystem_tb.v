
`timescale 1ns / 1ps

module MemorySystem_tb;

    reg clk = 0;
    reg rst = 0;
    reg [31:0] address = 0;
    reg readEnable = 0;
    reg writeEnable = 0;
    reg [31:0] writeData = 0;
    reg [15:0] switches = 0;

    wire [31:0] readData;
    wire [15:0] leds;

    // Generate clock: 10 ns period
    always #5 clk = ~clk;

    // Connect testbench to our memory system
    addressDecoderTop uut(
        .clk(clk),
        .rst(rst),
        .address(address),
        .readEnable(readEnable),
        .writeEnable(writeEnable),
        .writeData(writeData),
        .switches(switches),
        .readData(readData),
        .leds(leds)
    );

    initial begin

        // Reset LED module
        rst = 1;
        #10;
        rst = 0;

        // TEST 1: Write 250 to memory address 10
        @(negedge clk);
        address = 32'd10;
        writeData = 32'd250;
        writeEnable = 1;
        #10;
        writeEnable = 0;

        // TEST 2: Read memory address 10
        readEnable = 1;
        #10;
        if (readData !== 32'd250)
            $display("FAIL: Memory read");
        else
            $display("PASS: Memory read");
        readEnable = 0;

        // TEST 3: Write value 5 to LEDs
        @(negedge clk);
        address = 32'd600;
        writeData = 32'd5;
        writeEnable = 1;
        #10;
        writeEnable = 0;

        if (leds !== 16'd5)
            $display("FAIL: LED write");
        else
            $display("PASS: LED write");

        // TEST 4: Read switches
        switches = 16'd9;
        address = 32'd800;
        readEnable = 1;
        #10;

        if (readData !== 32'd9)
            $display("FAIL: Switch read");
        else
            $display("PASS: Switch read");

        readEnable = 0;

        $finish;
    end

endmodule

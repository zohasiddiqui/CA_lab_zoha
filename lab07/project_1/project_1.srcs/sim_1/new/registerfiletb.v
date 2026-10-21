`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/21/2026 12:16:07 PM
// Design Name: 
// Module Name: registerfiletb
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

module registerfiletb();

    reg clk;
    reg rst;
    reg WriteEnable;
    reg [4:0] rs1;
    reg [4:0] rs2;
    reg [4:0] rd;
    reg [31:0] WriteData;

    wire [31:0] ReadData1;
    wire [31:0] ReadData2;

    // Connect testbench to RegisterFile
    registerFile uut (
        .clk(clk),
        .rst(rst),
        .WriteEnable(WriteEnable),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .WriteData(WriteData),
        .ReadData1(ReadData1),
        .ReadData2(ReadData2)
    );

    // Clock generation: 10 ns period
    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst = 1;
        WriteEnable = 0;
        rs1 = 0;
        rs2 = 0;
        rd = 0;
        WriteData = 0;

        // Test 1: Reset
        @(posedge clk);
        #1;
        rst = 0;
        rs1 = 5;
        #1;

        if (ReadData1 === 32'b0)
            $display("Test 1 Passed: Reset");
        else
            $display("Test 1 Failed: Reset");

        // Test 2: Write to x5
        @(negedge clk);
        WriteEnable = 1;
        rd = 5;
        WriteData = 32'hDEADBEEF;

        @(posedge clk);
        #1;
        WriteEnable = 0;
        rs1 = 5;
        #1;

        if (ReadData1 === 32'hDEADBEEF)
            $display("Test 2 Passed: Write to x5");
        else
            $display("Test 2 Failed: Write to x5");

        // Test 3: Attempt to write x0
        @(negedge clk);
        WriteEnable = 1;
        rd = 0;
        WriteData = 32'd100;

        @(posedge clk);
        #1;
        WriteEnable = 0;
        rs1 = 0;
        #1;

        if (ReadData1 === 32'b0)
            $display("Test 3 Passed: x0 remains zero");
        else
            $display("Test 3 Failed: x0 changed");

        // Test 4: Write x6 and read x5, x6
        @(negedge clk);
        WriteEnable = 1;
        rd = 6;
        WriteData = 32'd200;

        @(posedge clk);
        #1;
        WriteEnable = 0;
        rs1 = 5;
        rs2 = 6;
        #1;

        if (ReadData1 === 32'hDEADBEEF &&
            ReadData2 === 32'd200)
            $display("Test 4 Passed: Two read ports");
        else
            $display("Test 4 Failed: Two read ports");

        // Test 5: Overwrite x5
        @(negedge clk);
        WriteEnable = 1;
        rd = 5;
        WriteData = 32'd500;

        @(posedge clk);
        #1;
        WriteEnable = 0;
        rs1 = 5;
        #1;

        if (ReadData1 === 32'd500)
            $display("Test 5 Passed: Overwrite x5");
        else
            $display("Test 5 Failed: Overwrite x5");

        // Test 6: Reset all registers
        @(negedge clk);
        rst = 1;

        @(posedge clk);
        #1;
        rst = 0;
        rs1 = 5;
        rs2 = 6;
        #1;

        if (ReadData1 === 32'd0 &&
            ReadData2 === 32'd0)
            $display("Test 6 Passed: Registers cleared");
        else
            $display("Test 6 Failed: Reset");

        $display("Simulation Completed");
        $finish;
    end

endmodule


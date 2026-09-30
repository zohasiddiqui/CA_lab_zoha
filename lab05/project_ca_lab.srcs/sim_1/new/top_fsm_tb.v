`timescale 1ns / 1ps 
////////////////////////////////////////////////////////////////////////////////// 
// Company:  
// Engineer:  
//  
// Create Date: 09/28/2026 02:48:35 PM 
// Design Name:  
// Module Name: top_fsm_tb 
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
 
module top_fsm_tb;

    reg clk; 
    reg pbin; 
    reg [15:0] physical_sw; 
    wire [15:0] physical_leds; 
 
    top_fsm_system dut ( 
        .clk(clk), 
        .pbin(pbin), 
        .physical_sw(physical_sw), 
        .physical_leds(physical_leds) 
    ); 
 
    always #5 clk = ~clk; 
 
    initial begin 
 
        clk = 0; 
        pbin = 1; 
        physical_sw = 16'd0; 
 
        #20; 
        pbin = 0; 
 
        // Test 1: Load 5 
        physical_sw = 16'd5; 
 
        #100; 
 
        // Test 2: Load 3 
        physical_sw = 16'd3; 
 
        #40; 
 
        // Change switches while counting 
        physical_sw = 16'd10; 
 
        #100; 
 
        // Test 3: Reset during countdown 
        physical_sw = 16'd7; 
 
        #30; 
 
        pbin = 1; 
 
        #20; 
 
        pbin = 0; 
        physical_sw = 16'd0; 
 
        #50; 
 
        $finish; 
 
    end 
 
endmodule
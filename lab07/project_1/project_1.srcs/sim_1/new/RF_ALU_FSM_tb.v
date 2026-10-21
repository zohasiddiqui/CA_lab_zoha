`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/21/2026 12:42:25 PM
// Design Name: 
// Module Name: RF_ALU_FSM_tb
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



module RF_ALU_FSM_tb;

    reg clk = 0;
    reg rst = 1;
    reg WriteEnable = 0;
    reg [4:0] rs1 = 0, rs2 = 0, rd = 0;
    reg [31:0] WriteData = 0;

    wire [31:0] ReadData1, ReadData2;
    reg [3:0] ALUControl = 0;
    wire [31:0] ALUResult;
    wire Zero;

    // Register File from Lab 7
    registerfile RF (
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

    // ALU from Lab 6
    ALU alu1 (
        .A(ReadData1),
        .B(ReadData2),
        .ALUControl(ALUControl),
        .ALUResult(ALUResult),
        .Zero(Zero)
    );

    always #5 clk = ~clk;

    // FSM states
    localparam IDLE = 0;
    localparam WRITE_REGS = 1;
    localparam EXECUTE = 2;
    localparam WRITE_RESULT = 3;
    localparam VERIFY = 4;
    localparam BEQ_CHECK = 5;
    localparam DONE = 6;

    reg [2:0] state = IDLE;
    integer step = 0;
    integer errors = 0;
   reg [31:0] expected = 32'b0;
reg [31:0] saved_result = 32'b0;
reg beq_equal = 1'b0;

    // One state transition per clock cycle
    always @(negedge clk) begin
        case (state)

            IDLE: begin
                rst = 1;
                WriteEnable = 0;
                step = 0;
                state = WRITE_REGS;
            end

            WRITE_REGS: begin
                rst = 0;
                WriteEnable = 1;

                case (step)
                    0: begin
                        rd = 1;
                        WriteData = 32'h10101010;
                    end
                    1: begin
                        rd = 2;
                        WriteData = 32'h01010101;
                    end
                    2: begin
                        rd = 3;
                        WriteData = 32'h00000005;
                    end
                endcase

                if (step == 2) begin
                    step = 0;
                    state = EXECUTE;
                end
                else
                    step = step + 1;
            end

            EXECUTE: begin
                WriteEnable = 0;
                rs1 = 1;

                // Use x3 as shift amount for SLL/SRL
                if (step == 5 || step == 6)
                    rs2 = 3;
                else
                    rs2 = 2;

                ALUControl = step;
                state = WRITE_RESULT;
            end

            WRITE_RESULT: begin
                saved_result = ALUResult;
                WriteData = ALUResult;
                rd = step + 4;
                WriteEnable = 1;
                state = VERIFY;
            end

            VERIFY: begin
                // Previous positive clock edge wrote result
                WriteEnable = 0;
                rs1 = step + 4;
                rs2 = 0;
                expected = saved_result;

                #1;
                if (ReadData1 === expected)
                    $display("PASS: Operation %0d, x%0d = %h",
                             step, step + 4, ReadData1);
                else begin
                    $display("FAIL: Operation %0d, expected %h, got %h",
                             step, expected, ReadData1);
                    errors = errors + 1;
                end

                if (step == 6)
                    state = BEQ_CHECK;
                else begin
                    step = step + 1;
                    state = EXECUTE;
                end
            end

            BEQ_CHECK: begin
                // Compare x1 with itself using subtraction
                WriteEnable = 0;
                rs1 = 1;
                rs2 = 1;
                ALUControl = 4'b0001;

                #1;
                beq_equal = Zero;

                if (beq_equal === 1'b1)
                    $display("PASS: BEQ equal comparison");
                else begin
                    $display("FAIL: BEQ equal comparison");
                    errors = errors + 1;
                end

                // Write flag register x11 if equal
                rd = 11;
                WriteData = beq_equal ? 32'd1 : 32'd0;
                WriteEnable = 1;
                state = DONE;
            end

            DONE: begin
                WriteEnable = 0;
                rs1 = 11;
                #1;

                if (ReadData1 === 32'd1)
                    $display("PASS: BEQ flag register x11");
                else begin
                    $display("FAIL: BEQ flag register x11");
                    errors = errors + 1;
                end

                if (errors == 0)
                    $display("ALL INTEGRATION TESTS PASSED");
                else
                    $display("INTEGRATION TEST FAILED: %0d errors", errors);

                $finish;
            end

        endcase
    end

    initial begin
        #1000;
        $display("FAIL: Simulation timeout");
        $finish;
    end

endmodule


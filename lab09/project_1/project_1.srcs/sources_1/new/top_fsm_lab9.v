`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/28/2026 02:29:07 PM
// Design Name: 
// Module Name: top_fsm_lab9
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


module top_fsm_lab9 (
    input wire clk,
    input wire pbin,
    input wire [15:0] physical_sw,
    output wire [15:0] physical_leds
);

    // Switch and LED interfaces from previous labs
    wire [31:0] switch_data;
    reg [31:0] led_write_data;

    leds switch_reader (
        .clk(clk),
        .rst(1'b0),
        .btns(16'd0),
        .writeData(32'd0),
        .writeEnable(1'b0),
        .readEnable(1'b1),
        .memAddress(30'd0),
        .switches(physical_sw),
        .readData(switch_data)
    );

    switches led_writer (
        .clk(clk),
        .rst(1'b0),
        .writeData(led_write_data),
        .writeEnable(1'b1),
        .readEnable(1'b0),
        .memAddress(30'd0),
        .readData(),
        .leds(physical_leds)
    );

    // Existing pushbutton interface
    wire button_raw;

    debouncer button_interface (
        .clk(clk),
        .pbin(pbin),
        .pbout(button_raw)
    );

    // Synchronize and debounce the button
    reg btn_meta = 0;
    reg btn_sync = 0;
    reg btn_stable = 0;
    reg btn_prev = 0;
    reg [20:0] debounce_count = 0;

    wire button_pressed =
        btn_stable && !btn_prev;

    always @(posedge clk) begin
        btn_meta <= button_raw;
        btn_sync <= btn_meta;
        btn_prev <= btn_stable;

        if (btn_sync == btn_stable) begin
            debounce_count <= 0;
        end
        else if (debounce_count == 21'd1_999_999) begin
            btn_stable <= btn_sync;
            debounce_count <= 0;
        end
        else begin
            debounce_count <= debounce_count + 1'b1;
        end
    end

    // Captured instruction fields
    reg [6:0] opcode = 0;
    reg [2:0] funct3 = 0;
    reg [6:0] funct7 = 0;

    // Main Control outputs
    wire RegWrite;
    wire MemRead;
    wire MemWrite;
    wire ALUSrc;
    wire MemtoReg;
    wire Branch;
    wire [1:0] ALUOp;

    // ALU Control output
    wire [3:0] ALUControl;

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

    ALUControl alu_unit (
        .ALUOp(ALUOp),
        .funct3(funct3),
        .funct7(funct7),
        .ALUControl(ALUControl)
    );

    // FSM States
    localparam LOAD_OPCODE = 2'd0;
    localparam LOAD_FUNCT  = 2'd1;
    localparam DISPLAY     = 2'd2;

    reg [1:0] state = LOAD_OPCODE;

    always @(posedge clk) begin
        if (button_pressed) begin
            case (state)

                LOAD_OPCODE: begin
                    opcode <= switch_data[6:0];
                    state <= LOAD_FUNCT;
                end

                LOAD_FUNCT: begin
                    funct3 <= switch_data[9:7];
                    funct7 <= switch_data[6:0];
                    state <= DISPLAY;
                end

                DISPLAY: begin
                    state <= LOAD_OPCODE;
                end

                default: state <= LOAD_OPCODE;

            endcase
        end
    end

    // Display control outputs on LEDs
    always @(*) begin
        led_write_data = {
            16'd0,
            state,          // LED15:14
            ALUOp,          // LED13:12
            ALUControl,     // LED11:8
            RegWrite,       // LED7
            MemRead,        // LED6
            MemWrite,       // LED5
            ALUSrc,         // LED4
            MemtoReg,       // LED3
            Branch,         // LED2
            2'b00           // LED1:0
        };
    end

endmodule

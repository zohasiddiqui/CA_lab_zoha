`timescale 1ns / 1ps

module top_fsm_system (
    input wire clk,
    input wire pbin,
    input wire [15:0] physical_sw,
    output wire [15:0] physical_leds
);

    // --------------------------------------------------
    // Internal signals
    // --------------------------------------------------

    wire rst_clean;
    wire slow_clk;

    wire [31:0] switch_data;
    reg  [31:0] led_write_data = 32'd0;

    // ALU inputs
    reg [31:0] A;
    reg [31:0] B;
    reg [3:0] ALUControl;

    // ALU outputs
    wire [31:0] ALUResult;
    wire Zero;


    // --------------------------------------------------
    // Reset button debouncer
    // --------------------------------------------------

    debouncer rst_db (
        .clk(clk),
        .pbin(pbin),
        .pbout(rst_clean)
    );


    // --------------------------------------------------
    // Read physical switches
    // --------------------------------------------------

    leds switch_reader (
        .clk(clk),
        .rst(rst_clean),

        .btns(16'd0),

        .writeData(32'd0),
        .writeEnable(1'b0),

        .readEnable(1'b1),
        .memAddress(30'd0),

        .switches(physical_sw),
        .readData(switch_data)
    );


    // --------------------------------------------------
    // Write result to physical LEDs
    // --------------------------------------------------

    switches led_writer (
        .clk(clk),
        .rst(rst_clean),

        .writeData(led_write_data),
        .writeEnable(1'b1),

        .readEnable(1'b0),
        .memAddress(30'd0),

        .readData(),
        .leds(physical_leds)
    );


    // --------------------------------------------------
    // Slow clock for FSM
    // --------------------------------------------------

    clock_divider ticker (
        .clk_in(clk),
        .rst(rst_clean),
        .clk_out(slow_clk)
    );


    // --------------------------------------------------
    // ALU
    // --------------------------------------------------

    ALU alu_inst (
        .A(A),
        .B(B),
        .ALUControl(ALUControl),
        .ALUResult(ALUResult),
        .Zero(Zero)
    );


    // --------------------------------------------------
    // FSM
    // --------------------------------------------------

    reg state;

    parameter READ_SWITCH = 1'b0;
    parameter DISPLAY     = 1'b1;


    always @(posedge slow_clk or posedge rst_clean) begin

        if (rst_clean) begin

            state <= READ_SWITCH;

            A <= 32'd0;
            B <= 32'd0;
            ALUControl <= 4'b0000;

        end

        else begin

            case (state)

                // Read A, B and ALU operation
                READ_SWITCH: begin

                    // SW0-SW3 = A
                    A <= {28'd0, switch_data[3:0]};

                    // SW4-SW7 = B
                    B <= {28'd0, switch_data[7:4]};

                    // SW8-SW11 = ALU Control
                    ALUControl <= switch_data[11:8];

                    state <= DISPLAY;

                end


                // Keep result visible for one FSM state
                DISPLAY: begin
                    state <= READ_SWITCH;
                end


                default: begin
                    state <= READ_SWITCH;
                end

            endcase
        end
    end


    // --------------------------------------------------
    // Display ALU output on LEDs
  
    always @(*) begin

        led_write_data = 32'd0;

        // Display lower 16 bits of ALU result
        //
        // LED0  = 1
        // LED1  = 2
        // LED2  = 4
        // LED3  = 8
        // LED4  = 16
        // ...
        // LED15 = 32768

        led_write_data[15:0] = ALUResult[15:0];

    end


endmodule
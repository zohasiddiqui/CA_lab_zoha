
`timescale 1ns / 1ps

module top_fsm_system (
    input wire clk,
    input wire pbin,
    input wire [15:0] physical_sw,
    output wire [15:0] physical_leds
);

    // Reset and slow timing signal
    wire rst_clean;
    wire slow_clk;
    reg slow_clk_prev = 0;

    // Memory system connections
    reg [31:0] address;
    reg [31:0] writeData;
    reg readEnable;
    reg writeEnable;

    wire [31:0] readData;

    // Values saved after reading
    reg [31:0] memory_value = 0;
    reg [31:0] switch_value = 0;

    // FSM states
    localparam WRITE_MEM = 3'd0;
    localparam READ_MEM  = 3'd1;
    localparam SHOW_MEM  = 3'd2;
    localparam READ_SW   = 3'd3;
    localparam SHOW_SW   = 3'd4;

    reg [2:0] state = WRITE_MEM;

    // Teacher-provided debouncer
    debouncer rst_db (
        .clk(clk),
        .pbin(pbin),
        .pbout(rst_clean)
    );

    // Teacher-provided clock divider
    clock_divider ticker (
        .clk_in(clk),
        .rst(rst_clean),
        .clk_out(slow_clk)
    );

    // Complete Lab 8 memory system
    addressDecoderTop memory_system (
        .clk(clk),
        .rst(rst_clean),
        .address(address),
        .readEnable(readEnable),
        .writeEnable(writeEnable),
        .writeData(writeData),
        .switches(physical_sw),
        .readData(readData),
        .leds(physical_leds)
    );

    // Generate memory operations based on state
    always @(*) begin

        address = 32'd0;
        writeData = 32'd0;
        readEnable = 0;
        writeEnable = 0;

        case (state)

            WRITE_MEM: begin
                address = 32'd10;
                writeData = {16'd0, physical_sw};
                writeEnable = 1;
            end

            READ_MEM: begin
                address = 32'd10;
                readEnable = 1;
            end

            SHOW_MEM: begin
                address = 32'd600;
                writeData = memory_value;
                writeEnable = 1;
            end

            READ_SW: begin
                address = 32'd800;
                readEnable = 1;
            end

            SHOW_SW: begin
                address = 32'd600;
                writeData = switch_value;
                writeEnable = 1;
            end

            default: begin
                address = 32'd0;
            end

        endcase
    end

    // FSM state updates using the main clock
    always @(posedge clk) begin

        slow_clk_prev <= slow_clk;

        if (rst_clean) begin
            state <= WRITE_MEM;
            memory_value <= 32'd0;
            switch_value <= 32'd0;
        end

        else if (slow_clk && !slow_clk_prev) begin

            case (state)

                WRITE_MEM:
                    state <= READ_MEM;

                READ_MEM: begin
                    memory_value <= readData;
                    state <= SHOW_MEM;
                end

                SHOW_MEM:
                    state <= READ_SW;

                READ_SW: begin
                    switch_value <= readData;
                    state <= SHOW_SW;
                end

                SHOW_SW:
                    state <= WRITE_MEM;

                default:
                    state <= WRITE_MEM;

            endcase
        end
    end

endmodule

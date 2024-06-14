`timescale 1ns / 1ps

`define STATE_UP 2'd0
`define STATE_LEFT 2'd1
`define STATE_DOWN 2'd2
`define STATE_RIGHT 2'd3

module dir_fsm(
    input clk,
    input rst,
    input left,
    input right,
    input up,
    input down,
    output reg [1:0] state
    );
    reg [1:0] next_state;

    // Sequential block to update the state on clock edge or reset
    always @(posedge clk or posedge rst)
    begin
        if (rst)
            state <= `STATE_RIGHT;
        else
            state <= next_state;
    end

    // Combinational block to determine the next state
    always @*
    begin
        case (state)
            `STATE_UP:
                if (left)
                    next_state = `STATE_LEFT;
                else if (right)
                    next_state = `STATE_RIGHT;
                else
                    next_state = `STATE_UP;

            `STATE_LEFT:
                if (down)
                    next_state = `STATE_DOWN;
                else if (up)
                    next_state = `STATE_UP;
                else
                    next_state = `STATE_LEFT;

            `STATE_DOWN:
                if (left)
                    next_state = `STATE_LEFT;
                else if (right)
                    next_state = `STATE_RIGHT;
                else
                    next_state = `STATE_DOWN;

            `STATE_RIGHT:
                if (down)
                    next_state = `STATE_DOWN;
                else if (up)
                    next_state = `STATE_UP;
                else
                    next_state = `STATE_RIGHT;

            default:
                next_state = `STATE_UP;
        endcase
    end

endmodule
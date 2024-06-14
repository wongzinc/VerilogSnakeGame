`timescale 1ns / 1ps

`define STATE_START_INTERFACE 3'd0
`define STATE_CHOOSE_LEVEL 3'd1
`define STATE_IDLE 3'd2
`define STATE_PLAY 3'd3
`define STATE_PAUSE 3'd4
`define STATE_WIN_INTERFACE 3'd5

module GAMESTATE(
   input clk,
   input rst,
   input btnc,
   input left, right,
   output reg [27:0] mov_speed,
   output reg [2:0] state,
   input lost
);
reg [2:0] next_state;
reg [27:0] next_mov_speed;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= `STATE_START_INTERFACE;
        mov_speed <= 27'd50_000_000;
    end else begin
        state <= next_state;
        mov_speed <= next_mov_speed;
    end
end

always @* begin
    case (state)
    `STATE_START_INTERFACE:
        if (btnc) begin
            next_state = `STATE_CHOOSE_LEVEL;
        end else begin
            next_state = `STATE_START_INTERFACE;
        end
    `STATE_CHOOSE_LEVEL:
        if (left) begin
            next_mov_speed = 27'd50_000_000;
            next_state = `STATE_IDLE;
        end else if (btnc) begin
            next_mov_speed = 27'd25_000_000;
            next_state = `STATE_IDLE;
        end else if (right) begin
            next_mov_speed = 27'd12_500_000;
            next_state = `STATE_IDLE;
        end else begin
            next_mov_speed = mov_speed;
            next_state = `STATE_CHOOSE_LEVEL;
        end 
    `STATE_IDLE:
        if (btnc) begin
            next_state = `STATE_PLAY;
        end else begin
            next_state = `STATE_IDLE;
        end 
    `STATE_PLAY:
        if (lost) begin
            next_state = `STATE_WIN_INTERFACE;
        end else if (btnc) begin
            next_state = `STATE_PAUSE;
        end else begin
            next_state = `STATE_PLAY;
        end 
     `STATE_PAUSE:
        if (btnc) begin
            next_state = `STATE_PLAY;
        end else begin
            next_state = `STATE_PAUSE;
        end
    `STATE_WIN_INTERFACE:
        if (btnc) begin
            next_state = `STATE_START_INTERFACE;
        end else begin
            next_state = `STATE_WIN_INTERFACE;
        end
    endcase
end

endmodule

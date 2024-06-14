`timescale 1ns / 1ps

module lfsr_random(
   input target_ate,
   input rst,
   output [8:0] STATE
    );
wire state_tmp;
reg [8:0] state;
assign STATE = state;
assign state_tmp = state[8] ^ state[4];

always @(posedge rst or posedge target_ate)
    if (rst) begin
        state[0]<=1;
        state[1]<=1;
        state[2]<=1;
        state[3]<=1;
        state[4]<=1;
        state[5]<=1;
        state[6]<=1;
        state[7]<=1;
        state[8]<=1;
    end else begin
        state[8] <= state[7];
        state[7] <= state[6];
        state[6] <= state[5];
        state[5] <= state[4];
        state[4] <= state[3];
        state[3] <= state[2];
        state[2] <= state[1];
        state[1] <= state[0];
        state[0] <= state_tmp; 
    end

endmodule

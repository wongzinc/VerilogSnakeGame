`timescale 1ns / 1ps

module score_count(
    input target_ate,
    input rst,
    input [2:0] game_state,
    output reg c,
    output reg [3:0] counter
);

always @(posedge rst or posedge target_ate) begin
    if (rst || game_state == `STATE_IDLE) begin
        counter <= 0;
        c <= 0;
    end else if (counter == 4'd9) begin
        c <= 1;
        counter <= 0;
    end else begin
        counter <= counter + 1;
        c <= 0;
    end
end

endmodule

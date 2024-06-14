`timescale 1ns / 1ps

module mov_clk(
   input clk,
   input rst,
   input enable,
   input [27:0] mov_speed,
   output reg trig_out
);
reg [25:0] count;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        count <= 0;
        trig_out <= 0;
    end else if (enable) begin
        if (count == mov_speed) begin
            count <= 0;
            trig_out <= 1;
        end else begin
            count <= count + 1;
            trig_out <= 0;
        end
    end
end

endmodule

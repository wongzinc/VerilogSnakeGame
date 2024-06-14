`timescale 1ns / 1ps

module push_handle(
   input rst,
   input clk,
   input push,
   output reg [1:0] out
);
reg [31:0] counter;
parameter SHORT_PRESS_THRESHOLD = 1;
parameter LONG_PRESS_THRESHOLD = 20;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        counter <= 0;
        out <= 0;
    end else begin
        if (push) begin
            counter <= counter + 1;
        end else begin
            if (counter >= LONG_PRESS_THRESHOLD) begin
                out <= 2; // Long press detected
            end else if (counter >= SHORT_PRESS_THRESHOLD) begin
                out <= 1; // Short press detected
            end else begin
                out <= 0; // No press detected
            end
            counter <= 0; // Reset counter when push is released
        end
    end
end

endmodule

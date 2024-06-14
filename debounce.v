`timescale 1ns / 1ps

module debounce(
    input clk,      // System clock
    input rst,      // Reset signal
    input pb_in,   // Raw button input
    output reg pb_debounced   // Debounced button output
);
reg [3:0] debounce_window;
reg pb_debounced_next;

// Synchronize the button input to the clock domain
always @(posedge clk or posedge rst) begin
    if (rst) debounce_window<=4'd0;
    else debounce_window<= {debounce_window[2:0],pb_in};
end

// Debounce logic
always @*
if (debounce_window == 4'b1111)
    pb_debounced_next = 1'b1;
else 
    pb_debounced_next = 1'b0;

// Generate the debounced button output
always @(posedge clk or posedge rst) begin
    if (rst) pb_debounced <= 1'b0;
    else pb_debounced <=pb_debounced_next;
end

endmodule

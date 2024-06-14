`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.03.2023 13:49:49
// Design Name: 
// Module Name: freqdiv27
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

module freqdiv(
    input clk_in,
    input rst,
    input [27:0] div_num,
    output reg clk_out
);
    reg [26:0] counter;
    
    always @ (posedge clk_in or posedge rst)
        if(rst) {counter, clk_out} <= 0;
        else 
        begin
            counter = counter + 1'b1;  
            if(counter == div_num) 
            begin
                clk_out = ~clk_out;
                counter = 0;
            end
        end 
     
endmodule

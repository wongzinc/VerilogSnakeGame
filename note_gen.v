`timescale 1ns / 1ps

module note_gen(
    input clk,
    input rst_n,
    input [21:0] note_div,
    input enable_sound,
    input [15:0] amplitude,
    output reg [15:0] audio_left,
    output reg [15:0] audio_right
   
    );

// declare internal signals
reg [21:0] clk_cnt_next,clk_cnt;
reg b_clk,b_clk_next;

// note frequency generation
always @(posedge clk or negedge rst_n) 
    if (~rst_n) begin
        clk_cnt<=22'b0;
        b_clk<=1'b0;
    end else begin
        clk_cnt <=clk_cnt_next;
        b_clk<=b_clk_next;
    end
always @* 
     if (clk_cnt == note_div) begin
        clk_cnt_next = 22'd0;
        b_clk_next = ~b_clk;
      end else begin
        clk_cnt_next = clk_cnt+1'b1;
        b_clk_next = b_clk;
      end
      
always @* begin
    if (enable_sound) begin
        audio_left = (b_clk == 1'b0)? (~amplitude): (amplitude);
        audio_right = (b_clk == 1'b0)? (~amplitude): (amplitude);
    end
end

endmodule

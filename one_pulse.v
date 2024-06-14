`timescale 1ns / 1ps

module one_pulse(
    input clk,
    input rst,
    input in_trig,
    output reg out_pulse
    );
    reg last_in_trig;
    wire is_pulse;
    
    always @ (posedge clk or posedge rst)
    begin
        if(rst) 
            last_in_trig <= 0;
        else 
            last_in_trig <= in_trig;
    end 
    
    assign is_pulse = in_trig & (~last_in_trig);
    
    always @ (posedge clk or posedge rst)
    begin
        if(rst)
            out_pulse <= 0;
        else 
            out_pulse <= is_pulse;
    end 
    
endmodule

`timescale 1ns / 1ps

module target_rnd_gen(
    input clk,
    input rst,
    input target_ate,
    output [17:0] rnd_addr
    );
    wire [8:0] lfsr_x;
    wire [8:0] lfsr_y;
              
    lfsr_random LFSR_X(
        .rst(rst),
        .target_ate(target_ate),
        .STATE(lfsr_x)
    );
    
    lfsr_random LFSR_Y(
        .rst(rst),
        .target_ate(target_ate),
        .STATE(lfsr_y)
    );
    
    assign  rnd_addr = (rst == 1'b1 ) ? 18'd0 : ((target_ate == 1'b1) ? {lfsr_y, lfsr_x} : 0);

endmodule
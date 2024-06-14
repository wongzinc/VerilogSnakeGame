`timescale 1ns / 1ps

module volume_ctrl(
   input rst_n,
   input clk,
   input clk_100hz,
   output reg [15:0] volume,
   output reg [4:0] vol_d0,
   input up,
   input down
    );
wire p_up,p_down;
reg [3:0] vol;
wire [3:0] next_vol;
one_pulse PU(.clk(clk),.rst(~rst_n),.in_trig(up),.out_pulse(p_up)),
        PD(.clk(clk),.rst(~rst_n),.in_trig(down),.out_pulse(p_down));

always @(posedge clk or negedge rst_n)
if (~rst_n) begin
    vol<=4'd1;
end else begin
    vol <= next_vol;
end
assign next_vol = (vol>5'd9)? vol-5'd10+p_up-p_down: vol+p_up-p_down;

always @* begin
    case (vol) 
        0: begin
            volume = 0;vol_d0=0;
        end
        1: begin 
            volume = 16'h0800;vol_d0=1;
        end
        2: begin
            volume = 16'h1000;vol_d0=2;
        end
        3: begin
            volume = 16'h1800;vol_d0=3;
        end
        4: begin
            volume = 16'h2000;vol_d0=4;
        end
        5:  begin
            volume = 16'h2800;vol_d0=5;
        end
        6:  begin
            volume = 16'h3000;vol_d0=6;
        end
        7: begin
            volume = 16'h3800;vol_d0=7;
        end
        8: begin
            volume = 16'h4000;vol_d0=8;
        end
        9: begin
            volume = 16'h4800;vol_d0=9;
        end
    endcase
end

endmodule

`timescale 1ns / 1ps

module volume_ctrl(
   input rst_n,
   input clk,
   input clk_100hz,
   output reg [15:0] volume,
   output reg [4:0] vol_d0,
   input up,
   input down,
   input ready,
   input [15:0] data_adc
    );
wire p_up,p_down;
reg [3:0] vol;
//wire [3:0] next_vol;
reg [3:0] next_vol;
one_pulse PU(.clk(clk),.rst(~rst_n),.in_trig(up),.out_pulse(p_up)),
        PD(.clk(clk),.rst(~rst_n),.in_trig(down),.out_pulse(p_down));

always @(posedge clk or negedge rst_n)
if (~rst_n) begin
    vol<=4'd1;
end else begin
    vol <= next_vol;
end
//assign next_vol = (vol>5'd9)? vol-5'd10+p_up-p_down: vol+p_up-p_down;

    always @(posedge(clk)) begin            
        if(ready == 1'b1) begin
            case (data_adc[15:12])
            0: next_vol = 0;
            1:  next_vol = 1;
            2:  next_vol= 2;
            3:  next_vol = 3;
            4:  next_vol = 4;
            5:  next_vol = 5;
            6:  next_vol = 6;
            7:  next_vol = 7;
            8:  next_vol = 8;
            9:  next_vol = 9;
            10: next_vol = 10;
            11: next_vol = 11;
            12: next_vol = 12;
            13: next_vol = 13;
            14: next_vol = 14;
            15: next_vol = 15;                      
            endcase
        end
    end

always @* begin
    case (vol) 
        0: begin
            volume = 0;vol_d0=0;
        end
        1: begin 
            volume = 16'h0010;vol_d0=1;
        end
        2: begin
            volume = 16'h0020;vol_d0=2;
        end
        3: begin
            volume = 16'h0030;vol_d0=3;
        end
        4: begin
            volume = 16'h0040;vol_d0=4;
        end
        5:  begin
            volume = 16'h0050;vol_d0=5;
        end
        6:  begin
            volume = 16'h0060;vol_d0=6;
        end
        7: begin
            volume = 16'h0070;vol_d0=7;
        end
        8: begin
            volume = 16'h0080;vol_d0=8;
        end
        9: begin
            volume = 16'h0090;vol_d0=9;
        end
        10: begin
            volume = 16'h0100;vol_d0=10;
        end
        11: begin
            volume = 16'h0110;vol_d0=11;
        end 
        12: begin
            volume = 16'h0120;vol_d0=12;
        end
        13: begin
            volume = 16'h0130;vol_d0=13;
        end
        14: begin
            volume = 16'h0240;vol_d0=14;
        end
        15: begin
            volume = 16'h6000;vol_d0=15;
        end
    endcase
end

endmodule

`timescale 1ns / 1ps

module display_out(
    input clk,
    input rst,
    input enable,
    input [3:0] b0, b1, b2, b3,
    output reg [7:0] SSD,
    output reg [3:0] SSD_sel
);
    reg [1:0] select;
    wire [7:0] SSD0, SSD1, SSD2, SSD3;
    wire carry;
    reg [3:0] nb0, nb1, nb2, nb3;
    
    bin_to_ssd U1(.i(nb0), .SSD(SSD0));
    bin_to_ssd U2(.i(nb1), .SSD(SSD1));
    bin_to_ssd U3(.i(nb2), .SSD(SSD2));
    bin_to_ssd U4(.i(nb3), .SSD(SSD3));
    
    always @ * 
        if(enable) begin
            nb0 = b0;
            nb1 = b1;
            nb2 = b2;
            nb3 = b3;
        end 
    
    always @ (posedge clk or posedge rst)
    begin
        if(rst) select = 0;
        else begin
            SSD_sel = 4'b1111;
            SSD_sel[select] = 0;
            case(select)
                0: SSD = SSD0;
                1: SSD = SSD1;
                2: SSD = SSD2;
                3: SSD = SSD3;
            endcase
            select = select + 1;
        end 
    end
    
endmodule

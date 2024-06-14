`timescale 1ns / 1ps

module bin_to_ssd(
    input [3:0] i,
    output reg [3:0] d,
    output reg [7:0] SSD
);

always @*
begin
    d = i;
    case(i)
        4'b0000: SSD = 8'b00000011;
        4'b0001: SSD = 8'b10011111;
        4'b0010: SSD = 8'b00100101;
        4'b0011: SSD = 8'b00001101;
        4'b0100: SSD = 8'b10011001;
        4'b0101: SSD = 8'b01001001;
        4'b0110: SSD = 8'b01000001;
        4'b0111: SSD = 8'b00011111;
        4'b1000: SSD = 8'b00000001;
        4'b1001: SSD = 8'b00001001;
        default: SSD = 8'b00000001;
    endcase
end

endmodule

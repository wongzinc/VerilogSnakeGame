//module pixel_gen(
//  input [9:0] h_cnt,
//  input [9:0] v_cnt,
//  input valid,
//  output reg [3:0] vgaRed,
//  output reg [3:0] vgaGreen,
//  output reg [3:0] vgaBlue,
//  input [1:0] game_state
//);


   
//always @(*) begin
//    if (!valid) begin
//        {vgaRed,vgaGreen,vgaBlue} = 12'h000;
//    end else begin
//        if (h_cnt<640) begin
//            case (game_state) 
//            2'd0: {vgaRed, vgaGreen, vgaBlue} = 12'hfff;
//            2'd1: {vgaRed, vgaGreen, vgaBlue} = 12'hf00;
//            2'd2: {vgaRed, vgaGreen, vgaBlue} = 12'h0ff;
//            default: {vgaRed, vgaGreen, vgaBlue} = 12'hfff;
//            endcase         
//        end else begin
//            {vgaRed, vgaGreen, vgaBlue} = 12'h0;
//        end
//    end
//end

//endmodule

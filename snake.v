`timescale 1ns / 1ps

module snake(
   input clk,
   input rst,
   input btnc,
   input left,
   input up_online,
   input down_online,
   input left_online,
   input right_online,
   input right,
   input up,
   input down,
   inout PS2_DATA,
   inout PS2_CLK,
   
   input vauxp6,
   input vauxn6,
   input vauxp7,
   input vauxn7,
   input vauxp15,
   input vauxn15,
   input vauxp14,
   input vauxn14,
   input vp_in,
   input vn_in,
   input [1:0] sw,
   
   output [3:0] vgaRed,
   output [3:0] vgaGreen,
   output [3:0] vgaBlue,
   output hsync,
   output vsync,
   output [7:0] SSD,
   output [3:0] SSD_sel,
   output [15:0] LED,
   output audio_mclk,
   output audio_lrck,
   output audio_sck,
   output audio_sdin
);
wire target_ate;
wire [27:0] mov_speed;
wire [3:0] score_count0, score_count1;
wire [2:0] game_state; 
wire [1:0] dir_state;  // state for button: left, right, up, down
wire [17:0] rnd_addr; 
wire clk_25Mhz,clk_22;
wire valid;
wire [9:0] h_cnt;
wire [9:0] v_cnt;
wire c1, c2,clk_scan;
wire p_mid,lost;
wire btnc_debounced;
wire [11:0] pixel0,pixel1,pixel2,pixel3,pixel4;
wire [11:0] pixel_num0,pixel_num1,pixel_num2,pixel_num3,pixel_num4,pixel_num5,pixel_num6,pixel_num7,pixel_num8,pixel_num9;
wire [11:0] pixel_level1,pixel_level2,pixel_level3;
wire [11:0] pixel_pause;
wire [11:0] data;
wire [16:0] pixel_addr;
wire [16:0] pixel_addr_out;
wire [4:0] vol_d3;
wire [1:0] long_and_short_up,long_and_short_down;
wire short_up_press,short_down_press,long_up_press,long_down_press;
wire clk_100hz;
wire [511:0] key_down;
wire [8:0] last_change;
wire key_valid;
wire data_valid;
assign short_up_press = (long_and_short_up==1)? 1:0;
assign long_up_press = (long_and_short_up==2)? 1:0;
assign short_down_press = (long_and_short_down==1)?1:0;
assign long_down_press = (long_and_short_down==2)?1:0;

clock_divisor clk_wiz_0_inst(
  .clk(clk),
  .clk1(clk_25Mhz),
  .clk22(clk_22)
);

GAMESTATE G1(
    .clk(clk),
    .rst(rst),
    .btnc(p_mid),
    .left(left),
    .right(right),
    .state(game_state),
    .lost(lost),
    .mov_speed(mov_speed)
);

freqdiv FQD1(
    .clk_in(clk),
    .rst(rst),
    .div_num(20700),
    .clk_out(clk_scan)
);

freqdiv FQD2(
    .clk_in(clk),
    .rst(rst),
    .div_num(27'd100_000_0),
    .clk_out(clk_100hz)
);

snake_mov S1(
    .clk_25Mhz(clk_25Mhz),
    .clk(clk),
    .rst(rst),
    .valid(valid),
    .colour_in({vgaRed, vgaGreen, vgaBlue}),
    .game_state(game_state),
    .dir_state(dir_state),
    .v_cnt(v_cnt),
    .h_cnt(h_cnt),
    .rnd_addr(rnd_addr),
    .target_ate(target_ate),
    .mov_speed(mov_speed),
    .pixel0(pixel0),
    .pixel1(pixel1),
    .pixel2(pixel2),
    .pixel3(pixel3),
    .pixel4(pixel4),
    .pixel_num0(pixel_num0),
    .pixel_num1(pixel_num1),
    .pixel_num2(pixel_num2),
    .pixel_num3(pixel_num3),
    .pixel_num4(pixel_num4),
    .pixel_num5(pixel_num5),
    .pixel_num6(pixel_num6),
    .pixel_num7(pixel_num7),
    .pixel_num8(pixel_num8),
    .pixel_num9(pixel_num9),
    .pixel_addr(pixel_addr),
    .pixel_pause(pixel_pause),
    .pixel_level1(pixel_level1),
    .pixel_level2(pixel_level2),
    .pixel_level3(pixel_level3),
    .score_count0(score_count0),
    .score_count1(score_count1),
    .lost(lost)
);

dir_fsm F2(
    .clk(clk),
    .rst(rst || game_state == `STATE_IDLE),
    .left(left || key_down[9'h6B] || left_online),
    .right(right || key_down[9'h74] || right_online),
    .up(short_up_press || key_down[9'h75] || up_online),
    .down(short_down_press || key_down[9'h72] || down_online ),
    .state(dir_state)
);

vga_controller vga_inst(
    .pclk(clk_25Mhz),
    .reset(rst),
    .hsync(hsync),
    .vsync(vsync),
    .valid(valid),
    .h_cnt(h_cnt),
    .v_cnt(v_cnt)
);

target_rnd_gen T1(
    .clk(clk),
    .rst(rst),
    .target_ate(target_ate),
    .rnd_addr(rnd_addr)
);  

score_count SC1(
    .target_ate(target_ate),
    .rst(rst || game_state== `STATE_IDLE),
    .c(c1),
    .game_state(game_state),
    .counter(score_count0)
);

score_count SC2(
    .target_ate(c1),
    .rst(rst || game_state==`STATE_IDLE),
    .game_state(game_state),
    .c(c2),
    .counter(score_count1)
);

display_out DP1(
    .clk(clk_scan),
    .rst(rst),
    .enable(1),
    .b0(score_count0),
    .b1(score_count1),
    .b2(0),
    .b3(vol_d3),
    .SSD(SSD),
    .SSD_sel(SSD_sel)
);

debounce DB1 (
    .clk(clk),
    .rst(rst),
    .pb_in(btnc),
    .pb_debounced(btnc_debounced)
);
one_pulse P1(.clk(clk),.rst(rst),.in_trig(btnc_debounced),.out_pulse(p_mid));

assign pixel_addr_out = pixel_addr;

blk_mem_gen_0 blk_mem_gen_0_inst(
  .clka(clk_25Mhz),
  .wea(0),
  .addra(pixel_addr_out),
  .dina(data[11:0]),
  .douta(pixel0)
); 

blk_mem_gen_1 mem_gen_1_inst(
  .clka(clk_25Mhz),
  .wea(0),
  .addra(pixel_addr_out),
  .dina(data[11:0]),
  .douta(pixel1)
);
blk_mem_gen_2 blk_mem_gen_2_inst(
  .clka(clk_25Mhz),
  .wea(0),
  .addra(pixel_addr_out),
  .dina(data[11:0]),
  .douta(pixel2)
); 
blk_mem_gen_3 blk_mem_gen_3_inst(
  .clka(clk_25Mhz),
  .wea(0),
  .addra(pixel_addr_out),
  .dina(data[11:0]),
  .douta(pixel3)
); 
blk_mem_gen_4 blk_mem_gen_4_inst(
  .clka(clk_25Mhz),
  .wea(0),
  .addra(pixel_addr_out),
  .dina(data[11:0]),
  .douta(pixel4)
);
blk_mem_gen_5 blk_mem_gen_5_inst(
  .clka(clk_25Mhz),
  .wea(0),
  .addra(pixel_addr_out),
  .dina(data[11:0]),
  .douta(pixel_num0)
); 
blk_mem_gen_6 blk_mem_gen_6_inst(
  .clka(clk_25Mhz),
  .wea(0),
  .addra(pixel_addr_out),
  .dina(data[11:0]),
  .douta(pixel_num1)
); 
blk_mem_gen_7 blk_mem_gen_7_inst(
  .clka(clk_25Mhz),
  .wea(0),
  .addra(pixel_addr_out),
  .dina(data[11:0]),
  .douta(pixel_num2)
); 
blk_mem_gen_8 blk_mem_gen_8_inst(
  .clka(clk_25Mhz),
  .wea(0),
  .addra(pixel_addr_out),
  .dina(data[11:0]),
  .douta(pixel_num3)
); 
blk_mem_gen_9 blk_mem_gen_9_inst(
  .clka(clk_25Mhz),
  .wea(0),
  .addra(pixel_addr_out),
  .dina(data[11:0]),
  .douta(pixel_num4)
); 
blk_mem_gen_10 blk_mem_gen_10_inst(
  .clka(clk_25Mhz),
  .wea(0),
  .addra(pixel_addr_out),
  .dina(data[11:0]),
  .douta(pixel_num5)
); 
blk_mem_gen_11 blk_mem_gen_11_inst(
  .clka(clk_25Mhz),
  .wea(0),
  .addra(pixel_addr_out),
  .dina(data[11:0]),
  .douta(pixel_num6)
); 
blk_mem_gen_12 blk_mem_gen_12_inst(
  .clka(clk_25Mhz),
  .wea(0),
  .addra(pixel_addr_out),
  .dina(data[11:0]),
  .douta(pixel_num7)
); 
blk_mem_gen_13 blk_mem_gen_13_inst(
  .clka(clk_25Mhz),
  .wea(0),
  .addra(pixel_addr_out),
  .dina(data[11:0]),
  .douta(pixel_num8)
); 
blk_mem_gen_14 blk_mem_gen_14_inst(
  .clka(clk_25Mhz),
  .wea(0),
  .addra(pixel_addr_out),
  .dina(data[11:0]),
  .douta(pixel_num9)
); 
blk_mem_gen_15 blk_mem_gen_15_inst(
  .clka(clk_25Mhz),
  .wea(0),
  .addra(pixel_addr_out),
  .dina(data[11:0]),
  .douta(pixel_pause)
);
blk_mem_gen_16 blk_mem_gen_16_inst(
  .clka(clk_25Mhz),
  .wea(0),
  .addra(pixel_addr_out),
  .dina(data[11:0]),
  .douta(pixel_level1)
); 
blk_mem_gen_17 blk_mem_gen_17_inst(
  .clka(clk_25Mhz),
  .wea(0),
  .addra(pixel_addr_out),
  .dina(data[11:0]),
  .douta(pixel_level2)
); 
blk_mem_gen_18 blk_mem_gen_18_inst(
  .clka(clk_25Mhz),
  .wea(0),
  .addra(pixel_addr_out),
  .dina(data[11:0]),
  .douta(pixel_level3)
);  

// push handle for up button
push_handle PHU(
    .rst(rst),
    .clk(clk_100hz),
    .push(up),
    .out(long_and_short_up)
);
// push handle for down button
push_handle PHD(
    .rst(rst),
    .clk(clk_100hz),
    .push(down),
    .out(long_and_short_down)
);

//keyboard input
KeyboardDecoder D1(
    .key_down(key_down),
    .last_change(last_change),
    .key_valid(key_valid),
    .PS2_DATA(PS2_DATA),
    .PS2_CLK(PS2_CLK),
    .rst(rst),
    .clk(clk)
);
wire enable;  
wire ready;
wire [15:0] data_adc;   
reg [6:0] Address_in;
xadc_wiz_0  XLXI_7 (
    .daddr_in(Address_in), //addresses can be found in the artix 7 XADC user guide DRP register space
    .dclk_in(clk), 
    .den_in(enable), 
    .di_in(0), 
    .dwe_in(0), 
    .busy_out(),                    
    .vauxp6(vauxp6),
    .vauxn6(vauxn6),
    .vauxp7(vauxp7),
    .vauxn7(vauxn7),
    .vauxp14(vauxp14),
    .vauxn14(vauxn14),
    .vauxp15(vauxp15),
    .vauxn15(vauxn15),
    .vn_in(vn_in), 
    .vp_in(vp_in), 
    .alarm_out(), 
    .do_out(data_adc), 
    //.reset_in(),
    .eoc_out(enable),
    .channel_out(),
    .drdy_out(ready)
);
// need long press and short_press
Soundtrack_controller Soundtrack_inst(
    .rst_n(~rst),
    .clk(clk),
    .ready(ready),
    .data_adc(data_adc),
    .up(long_up_press || key_down[9'h79]),
    .down(long_down_press || key_down[9'h7B]),
    .audio_mclk(audio_mclk),
    .audio_lrck(audio_lrck),
    .audio_sck(audio_sck),
    .audio_sdin(audio_sdin),
    .vol_d3(vol_d3),
    .game_state(game_state)
);
always @(posedge(clk)) begin
    case(sw)
    0: Address_in <= 8'h16;
    1: Address_in <= 8'h17;
    2: Address_in <= 8'h1e;
    3: Address_in <= 8'h1f;
    endcase
end
assign LED = (game_state==3'd5)? 16'hFFFF:0;

endmodule

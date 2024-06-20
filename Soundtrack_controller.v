`timescale 1ns / 1ps

`define STATE_START_INTERFACE 3'd0
`define STATE_CHOOSE_LEVEL 3'd1
`define STATE_IDLE 3'd2
`define STATE_PLAY 3'd3
`define STATE_PAUSE 3'd4
`define STATE_WIN_INTERFACE 3'd5

module Soundtrack_controller(
    input clk,
    input rst_n,
    input up,down,
    input ready,
    input [15:0] data_adc,
    input [2:0] game_state,
    output audio_mclk,
    output audio_lrck,
    output audio_sck,
    output audio_sdin,
    output [4:0] vol_d3
);
wire clk_scan,clk_100hz,p_up,p_down;
wire [15:0] amplitude;
wire [15:0] audio_in_left,audio_in_right;
wire [21:0] note_div;
wire enable_sound;
//wire [4:0] wb1,wb2,wb3;
// warning: rst
// here because the sound control use negedge, it is troublesome though, so i just change the boolean to fit two different module with different +rst or -rst
freqdiv X1(
    .clk_in(clk),
    .rst(~rst_n),
    .div_num(27'd20700),
    .clk_out(clk_scan)
),
X2(
    .clk_in(clk),
    .rst(~rst_n),
    .div_num(27'd50_000_0),
    .clk_out(clk_100hz)
);
// warning: rst
note_gen U_MI(
    .clk(clk),
    .rst_n(rst_n),
    .note_div(note_div),
    .audio_left(audio_in_left),
    .audio_right(audio_in_right),
    .amplitude(amplitude),
    .enable_sound(enable_sound)
);

speaker_control Usc(
    .clk(clk),
    .rst_n(rst_n),
    .audio_in_left(audio_in_left),
    .audio_in_right(audio_in_right),
    .audio_mclk(audio_mclk),
    .audio_lrck(audio_lrck),
    .audio_sck(audio_sck),
    .audio_sdin(audio_sdin)
);

volume_ctrl V1(
    .clk(clk),
    .ready(ready),
    .data_adc(data_adc),
    .clk_100hz(clk_100hz),
    .rst_n(rst_n),
    .volume(amplitude),
    .vol_d0(vol_d3),
    .up(up),
    .down(down)
);

//display_out D1(
//    .clk(clk_scan),
//    .rst_n(rst_n),
//    .enable(1),
//    .b0(vol_d0),
//    .b1(wb1),
//    .b2(wb2),
//    .b3(wb3),
//    .d0(0),
//    .d1(0),
//    .d2(0),
//    .d3(0),
//    .SSD(SSD),
//    .SSD_sel(SSD_sel)
//);

gameOver_soundtrack G1(
    .note_div(note_div),
    .play(game_state == `STATE_PLAY || game_state == `STATE_PAUSE),
    .start(game_state == `STATE_START_INTERFACE || game_state == `STATE_CHOOSE_LEVEL || game_state == `STATE_IDLE),
    .game_over(game_state == `STATE_WIN_INTERFACE),
    .rst_n(rst_n),
    .clk(clk),
    .enable_sound(enable_sound)
);

endmodule
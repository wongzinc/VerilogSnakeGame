`timescale 1ns / 1ps

// NOTE DIV
`define G3  100000000/(2*196)
`define GS3 100000000/(2*208)
`define A3  100000000/(2*220)
`define AS3 100000000/(2*233)
`define B3  100000000/(2*247)
`define C4  100000000/(2*262)
`define CS4 100000000/(2*277)
`define D4  100000000/(2*294)
`define DS4 100000000/(2*311)
`define E4  100000000/(2*330)
`define F4  100000000/(2*349)
`define FS4 100000000/(2*370)
`define G4  100000000/(2*392)
`define GS4 100000000/(2*415)
`define A4  100000000/(2*440)
`define AS4 100000000/(2*466)
`define B4  100000000/(2*494)
`define C5  100000000/(2*523)
`define CS5 100000000/(2*554)
`define D5  100000000/(2*587)
`define DS5 100000000/(2*622)
`define E5  100000000/(2*659)
`define F5  100000000/(2*698)
`define FS5 100000000/(2*740)
`define G5  100000000/(2*784)
`define GS5 100000000/(2*831)
`define A5  100000000/(2*880)
`define AS5 100000000/(2*932)
`define B5  100000000/(2*988)
`define C6  100000000/(2*1046)
`define CS6 100000000/(2*1109)
// TIME DIV 100 BPM
`define WHOLE_NOTE_100 120_000_000
`define ONEHALF_NOTE_100  45_000_000
`define QUARTER_NOTE_100  30_000_000
`define EIGHTH_NOTE_100   15_000_000
`define REST_TWOBEAT_100  60_000_000
`define REST_ONEBEAT_100  30_000_000
`define REST_HALFBEAT_100 15_000_000
`define REST_1_16BEAT_100 1_875_000
`define REST_1_32BEAT_100   9375_00
`define REST_1_64BEAT_100 468_750
`define REST_1_128BEAT_100 234375
`define REST_1_512BEAT_100 58_594
`define REST_1_1024BEAT_100 29297
//200 BPM
`define QUARTER_NOTE_200  15_000_000
`define EIGHTH_NOTE_200   7_500_000
//180 BPM
`define QUARTER_NOTE_180  16_700_000
`define EIGHTH_NOTE_180   8_350_000
`define REST_TWOBEAT_180  33_400_000
`define REST_ONEBEAT_180  16_700_000
`define REST_HALFBEAT_180 8_350_000

`define C 5'b01010
`define D 5'b01011
`define E 5'b01100
`define F 5'b01101
`define G 5'b01110
`define A 5'b01111
`define B 5'b10000
`define S 5'b10001 // Sharp mode
`define N 5'b10010 // Normal mode
`define R 5'b10011 // Rest mode

module gameOver_soundtrack(
   output reg [21:0] note_div,
   input game_over,
   input start,
   input play,
   input rst_n,
   input clk,
   output reg [4:0] b1,b2,b3,
   output reg enable_sound
    );

reg [26:0] counter;
reg [7:0] note_index;

always @(posedge clk or negedge rst_n) begin
      if (~rst_n) begin
        counter <= 0;
        note_index <= 0;
        note_div <= 0;
        enable_sound=0;
      end else if (game_over) begin
        if (counter == 0) begin
          enable_sound=1;
        case (note_index)
            0: begin note_div <= `C5; counter <= `QUARTER_NOTE_100; b3<=`C; b2<=5'd5; b1<=`N; end // C5 1beat
            1: begin note_div <= 0; counter <= `REST_HALFBEAT_100; b3<=0; b2<=0; b1<=`R; end  // REST_HALFBEAT
            2: begin note_div <= `G4; counter <= `EIGHTH_NOTE_100; b3<=`G; b2<=5'd4; b1<=`N; end // G4 halfbeat
            3: begin note_div <= 0; counter <= `REST_ONEBEAT_100; b3<=0; b2<=0; b1<=`R; end // REST_ONEBEAT
            4: begin note_div <= `E4; counter<=`QUARTER_NOTE_100; b3<=`E;b2<=5'd4;b1<=`N; end // E4 1beat
            
            5: begin note_div <= `A4; counter <= `QUARTER_NOTE_100; b3<=`A; b2<=5'd4; b1<=`N; end // 
            6: begin note_div <= `B4; counter <= `QUARTER_NOTE_100; b3<=`B; b2<=5'd4; b1<=`N; end
            7: begin note_div <= `A4; counter <= `QUARTER_NOTE_100; b3<=`A; b2<=5'd4; b1<=`N; end
            8: begin note_div <= `GS4; counter <= `QUARTER_NOTE_100; b3<=`G; b2<=5'd4; b1<=`S; end
            9: begin note_div <= `AS4; counter <= `QUARTER_NOTE_100; b3<=`A; b2<=5'd4; b1<=`S; end
            10: begin note_div <= `GS4; counter <= `QUARTER_NOTE_100; b3<=`G; b2<=5'd4; b1<=`S; end
            
            11: begin note_div <= `E4; counter <= `EIGHTH_NOTE_100; b3<=`E; b2<=5'd4; b1<=`N; end
            12: begin note_div <= `D4; counter <= `EIGHTH_NOTE_100; b3<=`D; b2<=5'd4; b1<=`N; end
            13: begin note_div <= `E4; counter <= `ONEHALF_NOTE_100; b3<=`E; b2<=5'd4; b1<=`N; end
            14: begin note_div <= 0; counter <= `REST_TWOBEAT_100; b3<=0; b2<=0; b1<=`R; end

            default: begin note_div <= 0; note_index <= 0; end
          endcase
          note_index <= note_index + 1;
        end else begin
          counter <= counter-1;
        end
      end else if (start) begin
        if (counter == 0) begin
          enable_sound=1;
        case (note_index)
            0: begin note_div <= `C5; counter <= `EIGHTH_NOTE_100; b3<=`C; b2<=5'd5; b1<=`N; end 
            1: begin note_div <= `C6; counter <= `EIGHTH_NOTE_100; b3<=`C; b2<=5'd6; b1<=`N; end  
            2: begin note_div <= `G5; counter <= `EIGHTH_NOTE_100; b3<=`G; b2<=5'd5; b1<=`N; end 
            3: begin note_div <= `E5; counter <= `EIGHTH_NOTE_100; b3<=`E; b2<=5'd5; b1<=`N; end 
            4: begin note_div <= `C6; counter<= `EIGHTH_NOTE_100; b3<=`C;b2<=5'd5;b1<=`N; end 
            5: begin note_div <= `G5; counter <= `EIGHTH_NOTE_100; b3<=`G; b2<=5'd5; b1<=`N; end 
            6: begin note_div <= `E5; counter <= `QUARTER_NOTE_100; b3<=`E; b2<=5'd5; b1<=`N; end
            
            7: begin note_div <= `CS5; counter <= `EIGHTH_NOTE_100; b3<=`C; b2<=5'd5; b1<=`S; end
            8: begin note_div <= `CS6; counter <= `EIGHTH_NOTE_100; b3<=`C; b2<=5'd6; b1<=`S; end
            9: begin note_div <= `GS5; counter <= `EIGHTH_NOTE_100; b3<=`G; b2<=5'd5; b1<=`S; end
            10: begin note_div <= `F5; counter <= `EIGHTH_NOTE_100; b3<=`F; b2<=5'd5; b1<=`N; end     
            11: begin note_div <= `CS6; counter <= `EIGHTH_NOTE_100; b3<=`C; b2<=5'd6; b1<=`N; end
            12: begin note_div <= `GS5; counter <= `EIGHTH_NOTE_100; b3<=`G; b2<=5'd5; b1<=`S; end
            13: begin note_div <= `F5; counter <= `QUARTER_NOTE_100; b3<=`F; b2<=5'd5; b1<=`N; end
            
            14: begin note_div <= `C5; counter <= `EIGHTH_NOTE_100; b3<=`C; b2<=5'd5; b1<=`S; end
            15: begin note_div <= `C6; counter <= `EIGHTH_NOTE_100; b3<=`C; b2<=5'd6; b1<=`S; end
            16: begin note_div <= `G5; counter <= `EIGHTH_NOTE_100; b3<=`G; b2<=5'd5; b1<=`S; end
            17: begin note_div <= `E5; counter <= `EIGHTH_NOTE_100; b3<=`E; b2<=5'd5; b1<=`N; end
            18: begin note_div <= `C6; counter <= `EIGHTH_NOTE_100; b3<=`C; b2<=5'd6; b1<=`S; end
            19: begin note_div <= `G5; counter <= `EIGHTH_NOTE_100; b3<=`G; b2<=5'd5; b1<=`S; end
            20: begin note_div <= `E5; counter <= `QUARTER_NOTE_100; b3<=`E; b2<=5'd5; b1<=`N; end
           
            21: begin note_div <= `FS5; counter <= `EIGHTH_NOTE_100; b3<=`F; b2<=5'd5; b1<=`S; end
            22: begin note_div <= `G5; counter <= `EIGHTH_NOTE_100; b3<=`G; b2<=5'd5; b1<=`N; end
            23: begin note_div <= `GS5; counter <= `EIGHTH_NOTE_100; b3<=`G; b2<=5'd5; b1<=`S; end
            24: begin note_div <= 0; counter <= `REST_1_512BEAT_100; b3<=0; b2<=5'd0; b1<=`R; end //
            25: begin note_div <= `GS5; counter <= `EIGHTH_NOTE_100; b3<=`G; b2<=5'd5; b1<=`S; end
            26: begin note_div <= `A5; counter <= `EIGHTH_NOTE_100; b3<=`A; b2<=5'd5; b1<=`N; end
            27: begin note_div <= `AS5; counter <= `EIGHTH_NOTE_100; b3<=`A; b2<=5'd5; b1<=`S; end
            28: begin note_div <= 0; counter <= `REST_1_512BEAT_100; b3<=0; b2<=5'd0; b1<=`R; end // 
            29: begin note_div <= `AS5; counter <= `EIGHTH_NOTE_100; b3<=`A; b2<=5'd5; b1<=`S; end
            30: begin note_div <= `B5; counter <= `EIGHTH_NOTE_100; b3<=`B; b2<=5'd5; b1<=`N; end
            31: begin note_div <= `CS6; counter <= `EIGHTH_NOTE_100; b3<=`C; b2<=5'd6; b1<=`S; end
            32: begin note_div <= 0; counter <= `REST_1_512BEAT_100; b3<=0; b2<=5'd0; b1<=`R; end //
            33: begin note_div <= `CS6; counter <= `WHOLE_NOTE_100; b3<=`C; b2<=5'd6; b1<=`S; end
//            34: begin note_div <= 0; counter <= `REST_1_16BEAT_100; b3<=0; b2<=5'd0; b1<=`R; end
            
            default: begin note_div <= 0; note_index <= 0; end
          endcase
          note_index <= note_index + 1;
        end else begin
          counter <= counter-1;
        end 
      end else if (play) begin
        if (counter == 0) begin
          enable_sound=1;
        case (note_index)
            0: begin note_div <= `E5; counter <= `EIGHTH_NOTE_100; b3<=`E; b2<=5'd5; b1<=`N; end 
            1: begin note_div <= `E5; counter <= `EIGHTH_NOTE_100; b3<=`E; b2<=5'd5; b1<=`N; end  
            2: begin note_div <= 0; counter <= `REST_HALFBEAT_100; b3<=0; b2<=5'd0; b1<=`R; end 
            3: begin note_div <= `E5; counter <= `EIGHTH_NOTE_100; b3<=`E; b2<=5'd5; b1<=`N; end 
            4: begin note_div <= 0; counter<= `REST_HALFBEAT_100; b3<=0;b2<=5'd0;b1<=`R; end 
            5: begin note_div <= `C5; counter <= `EIGHTH_NOTE_100; b3<=`C; b2<=5'd5; b1<=`N; end 
            6: begin note_div <= `E5; counter <= `QUARTER_NOTE_100; b3<=`E; b2<=5'd5; b1<=`N; end
            
            7: begin note_div <= `G5; counter <= `QUARTER_NOTE_100; b3<=`G; b2<=5'd5; b1<=`N; end
            8: begin note_div <= 0; counter <= `REST_ONEBEAT_100; b3<=0; b2<=5'd0; b1<=`R; end
            9: begin note_div <= `G4; counter <= `QUARTER_NOTE_100; b3<=`G; b2<=5'd4; b1<=`N; end
            10: begin note_div <= 0; counter <= `REST_ONEBEAT_100; b3<=0; b2<=5'd0; b1<=`R; end     
            //
            11: begin note_div <= `C5; counter <= `QUARTER_NOTE_100; b3<=`C; b2<=5'd5; b1<=`N; end
            12: begin note_div <= 0; counter <= `REST_HALFBEAT_100; b3<=0; b2<=5'd0; b1<=`R; end
            13: begin note_div <= `G4; counter <= `QUARTER_NOTE_100; b3<=`G; b2<=5'd4; b1<=`N; end
            14: begin note_div <= 0; counter <= `REST_HALFBEAT_100; b3<=0; b2<=5'd0; b1<=`R; end
            15: begin note_div <= `E4; counter <= `QUARTER_NOTE_100; b3<=`E; b2<=5'd4; b1<=`N; end
            
            16: begin note_div <= 0; counter <= `REST_HALFBEAT_100; b3<=0; b2<=5'd0; b1<=`R; end
            17: begin note_div <= `A4; counter <= `QUARTER_NOTE_100; b3<=`A; b2<=5'd4; b1<=`N; end
            18: begin note_div <= `B4; counter <= `QUARTER_NOTE_100; b3<=`B; b2<=5'd4; b1<=`N; end
            19: begin note_div <= `AS4; counter <= `EIGHTH_NOTE_100; b3<=`A; b2<=5'd4; b1<=`S; end
            20: begin note_div <= `A4; counter <= `QUARTER_NOTE_100; b3<=`A; b2<=5'd4; b1<=`N; end
           
            21: begin note_div <= `G4; counter <= `QUARTER_NOTE_100; b3<=`G; b2<=5'd4; b1<=`N; end
            22: begin note_div <= `E5; counter <= `QUARTER_NOTE_100; b3<=`E; b2<=5'd5; b1<=`N; end
            23: begin note_div <= `G5; counter <= `QUARTER_NOTE_100; b3<=`G; b2<=5'd5; b1<=`N; end
            24: begin note_div <= `A5; counter <= `QUARTER_NOTE_100; b3<=`A; b2<=5'd5; b1<=`N; end
            25: begin note_div <= `F5; counter <= `EIGHTH_NOTE_100; b3<=`F; b2<=5'd5; b1<=`N; end
            26: begin note_div <= `G5; counter <= `EIGHTH_NOTE_100; b3<=`G; b2<=5'd5; b1<=`N; end
            
            27: begin note_div <= 0; counter <= `REST_HALFBEAT_100; b3<=0; b2<=5'd0; b1<=`R; end
            28: begin note_div <= `E5; counter <= `QUARTER_NOTE_100; b3<=`E; b2<=5'd5; b1<=`N; end
            29: begin note_div <= `C5; counter <= `EIGHTH_NOTE_100; b3<=`C; b2<=5'd5; b1<=`N; end
            30: begin note_div <= `D5; counter <= `EIGHTH_NOTE_100; b3<=`D; b2<=5'd5; b1<=`N; end
            31: begin note_div <= `B4; counter <= `QUARTER_NOTE_100; b3<=`B; b2<=5'd4; b1<=`N; end
            32: begin note_div <= 0; counter <= `REST_HALFBEAT_100; b3<=0; b2<=5'd0; b1<=`R; end
            //
            33: begin note_div <= `C5; counter <= `QUARTER_NOTE_100; b3<=`C; b2<=5'd5; b1<=`N; end
            34: begin note_div <= 0; counter <= `REST_HALFBEAT_100; b3<=0; b2<=5'd0; b1<=`R; end
            35: begin note_div <= `G4; counter <= `QUARTER_NOTE_100; b3<=`G; b2<=5'd4; b1<=`N; end
            36: begin note_div <= 0; counter <= `REST_HALFBEAT_100; b3<=0; b2<=5'd0; b1<=`R; end
            37: begin note_div <= `E4; counter <= `QUARTER_NOTE_100; b3<=`E; b2<=5'd4; b1<=`N; end
            
            38: begin note_div <= 0; counter <= `REST_HALFBEAT_100; b3<=0; b2<=5'd0; b1<=`R; end
            39: begin note_div <= `A4; counter <= `QUARTER_NOTE_100; b3<=`A; b2<=5'd4; b1<=`N; end
            40: begin note_div <= `B4; counter <= `QUARTER_NOTE_100; b3<=`B; b2<=5'd4; b1<=`N; end
            41: begin note_div <= `AS4; counter <= `EIGHTH_NOTE_100; b3<=`A; b2<=5'd4; b1<=`S; end
            42: begin note_div <= `A4; counter <= `QUARTER_NOTE_100; b3<=`A; b2<=5'd4; b1<=`N; end
           
            43: begin note_div <= `G4; counter <= `QUARTER_NOTE_100; b3<=`G; b2<=5'd4; b1<=`N; end
            44: begin note_div <= `E5; counter <= `QUARTER_NOTE_100; b3<=`E; b2<=5'd5; b1<=`N; end
            45: begin note_div <= `G5; counter <= `QUARTER_NOTE_100; b3<=`G; b2<=5'd5; b1<=`N; end
            46: begin note_div <= `A5; counter <= `QUARTER_NOTE_100; b3<=`A; b2<=5'd5; b1<=`N; end
            47: begin note_div <= `F5; counter <= `EIGHTH_NOTE_100; b3<=`F; b2<=5'd5; b1<=`N; end
            48: begin note_div <= `G5; counter <= `EIGHTH_NOTE_100; b3<=`G; b2<=5'd5; b1<=`N; end
            
            49: begin note_div <= 0; counter <= `REST_HALFBEAT_100; b3<=0; b2<=5'd0; b1<=`R; end
            50: begin note_div <= `E5; counter <= `QUARTER_NOTE_100; b3<=`E; b2<=5'd5; b1<=`N; end
            51: begin note_div <= `C5; counter <= `EIGHTH_NOTE_100; b3<=`C; b2<=5'd5; b1<=`N; end
            52: begin note_div <= `D5; counter <= `EIGHTH_NOTE_100; b3<=`D; b2<=5'd5; b1<=`N; end
            53: begin note_div <= `B4; counter <= `QUARTER_NOTE_100; b3<=`B; b2<=5'd4; b1<=`N; end
            54: begin note_div <= 0; counter <= `REST_HALFBEAT_100; b3<=0; b2<=5'd0; b1<=`R; end
            ////
            55: begin note_div <= 0; counter <= `REST_ONEBEAT_100; b3<=0; b2<=5'd0; b1<=`R; end
            56: begin note_div <= `G5; counter <= `EIGHTH_NOTE_100; b3<=`G; b2<=5'd5; b1<=`N; end
            57: begin note_div <= `FS5; counter <= `EIGHTH_NOTE_100; b3<=`F; b2<=5'd5; b1<=`S; end
            58: begin note_div <= `F5; counter <= `EIGHTH_NOTE_100; b3<=`F; b2<=5'd5; b1<=`N; end
            59: begin note_div <= `DS5; counter <= `QUARTER_NOTE_100; b3<=`D; b2<=5'd5; b1<=`S; end 
            60: begin note_div <= `E5; counter <= `EIGHTH_NOTE_100; b3<=`E; b2<=5'd5; b1<=`N; end
            
            61: begin note_div <= 0; counter <= `REST_HALFBEAT_100; b3<=0; b2<=5'd0; b1<=`R; end
            62: begin note_div <= `GS4; counter <= `EIGHTH_NOTE_100; b3<=`G; b2<=5'd4; b1<=`S; end
            63: begin note_div <= `A4; counter <= `EIGHTH_NOTE_100; b3<=`A; b2<=5'd4; b1<=`N; end
            64: begin note_div <= `C5; counter <= `EIGHTH_NOTE_100; b3<=`C; b2<=5'd5; b1<=`N; end
            65: begin note_div <= 0; counter <= `REST_HALFBEAT_100; b3<=0; b2<=5'd0; b1<=`R; end
            66: begin note_div <= `A4; counter <= `EIGHTH_NOTE_100; b3<=`A; b2<=5'd4; b1<=`N; end
            67: begin note_div <= `C5; counter <= `EIGHTH_NOTE_100; b3<=`C; b2<=5'd5; b1<=`N; end
            68: begin note_div <= `DS5; counter <= `EIGHTH_NOTE_100; b3<=`D; b2<=5'd5; b1<=`S; end
            
            69: begin note_div <= 0; counter <= `REST_ONEBEAT_100; b3<=0; b2<=5'd0; b1<=`R; end
            70: begin note_div <= `G5; counter <= `EIGHTH_NOTE_100; b3<=`G; b2<=5'd5; b1<=`N; end
            71: begin note_div <= `FS5; counter <= `EIGHTH_NOTE_100; b3<=`F; b2<=5'd5; b1<=`S; end
            72: begin note_div <= `F5; counter <= `EIGHTH_NOTE_100; b3<=`F; b2<=5'd5; b1<=`N; end
            73: begin note_div <= `DS5; counter <= `QUARTER_NOTE_100; b3<=`D; b2<=5'd5; b1<=`S; end
            74: begin note_div <= `E5; counter <= `EIGHTH_NOTE_100; b3<=`E; b2<=5'd5; b1<=`N; end
            
            75: begin note_div <= 0; counter <= `REST_HALFBEAT_100; b3<=0; b2<=5'd0; b1<=`R; end
            76: begin note_div <= `C6; counter <= `QUARTER_NOTE_100; b3<=`C; b2<=5'd6; b1<=`N; end
            77: begin note_div <= 0; counter <= `REST_1_512BEAT_100; b3<=0; b2<=5'd0; b1<=`R; end
            78: begin note_div <= `C6; counter <= `EIGHTH_NOTE_100; b3<=`C; b2<=5'd6; b1<=`N; end
            79: begin note_div <= 0; counter <= `REST_1_512BEAT_100; b3<=0; b2<=5'd0; b1<=`R; end
            80: begin note_div <= `C6; counter <= `QUARTER_NOTE_100; b3<=`C; b2<=5'd6; b1<=`N; end
            81: begin note_div <= 0; counter <= `REST_ONEBEAT_100; b3<=0; b2<=5'd0; b1<=`R; end
            
            82: begin note_div <= 0; counter <= `REST_ONEBEAT_100; b3<=0; b2<=5'd0; b1<=`R; end
            83: begin note_div <= `G5; counter <= `EIGHTH_NOTE_100; b3<=`G; b2<=5'd5; b1<=`N; end
            84: begin note_div <= `FS5; counter <= `EIGHTH_NOTE_100; b3<=`F; b2<=5'd5; b1<=`S; end
            85: begin note_div <= `F5; counter <= `EIGHTH_NOTE_100; b3<=`F; b2<=5'd5; b1<=`N; end
            86: begin note_div <= `DS5; counter <= `QUARTER_NOTE_100; b3<=`D; b2<=5'd5; b1<=`S; end
            87: begin note_div <= `E5; counter <= `EIGHTH_NOTE_100; b3<=`E; b2<=5'd5; b1<=`N; end
            
            88: begin note_div <= 0; counter <= `REST_HALFBEAT_100; b3<=0; b2<=5'd0; b1<=`R; end
            89: begin note_div <= `GS4; counter <= `EIGHTH_NOTE_100; b3<=`G; b2<=5'd4; b1<=`S; end
            90: begin note_div <= `A4; counter <= `EIGHTH_NOTE_100; b3<=`A; b2<=5'd4; b1<=`N; end
            91: begin note_div <= `C5; counter <= `EIGHTH_NOTE_100; b3<=`C; b2<=5'd5; b1<=`N; end
            92: begin note_div <= 0; counter <= `REST_HALFBEAT_100; b3<=0; b2<=5'd0; b1<=`R; end
            93: begin note_div <= `A4; counter <= `EIGHTH_NOTE_100; b3<=`A; b2<=5'd4; b1<=`N; end
            94: begin note_div <= `C5; counter <= `EIGHTH_NOTE_100; b3<=`C; b2<=5'd5; b1<=`N; end
            95: begin note_div <= `D5; counter <= `EIGHTH_NOTE_100; b3<=`D; b2<=5'd5; b1<=`N; end
            
            96: begin note_div <= 0; counter <= `REST_ONEBEAT_100; b3<=0; b2<=5'd0; b1<=`R; end
            97: begin note_div <= `DS5; counter <= `QUARTER_NOTE_100; b3<=`D; b2<=5'd5; b1<=`S; end
            98: begin note_div <= 0; counter <= `REST_HALFBEAT_100; b3<=0; b2<=5'd0; b1<=`R; end
            99: begin note_div <= `D5; counter <= `QUARTER_NOTE_100; b3<=`D; b2<=5'd5; b1<=`N; end
            100: begin note_div <= 0; counter <= `REST_HALFBEAT_100; b3<=0; b2<=5'd0; b1<=`R; end
            
            101: begin note_div <= `C5; counter <= `QUARTER_NOTE_100; b3<=`C; b2<=5'd5; b1<=`N; end
            102: begin note_div <= 0; counter <= `REST_ONEBEAT_100; b3<=0; b2<=5'd0; b1<=`R; end
            103: begin note_div <= 0; counter <= `REST_TWOBEAT_100; b3<=0; b2<=5'd0; b1<=`R; end
            ////
            104: begin note_div <= 0; counter <= `REST_ONEBEAT_100; b3<=0; b2<=5'd0; b1<=`R; end
            105: begin note_div <= `G5; counter <= `EIGHTH_NOTE_100; b3<=`G; b2<=5'd5; b1<=`N; end
            106: begin note_div <= `FS5; counter <= `EIGHTH_NOTE_100; b3<=`F; b2<=5'd5; b1<=`S; end
            107: begin note_div <= `F5; counter <= `EIGHTH_NOTE_100; b3<=`F; b2<=5'd5; b1<=`N; end
            108: begin note_div <= `DS5; counter <= `QUARTER_NOTE_100; b3<=`D; b2<=5'd5; b1<=`S; end 
            109: begin note_div <= `E5; counter <= `EIGHTH_NOTE_100; b3<=`E; b2<=5'd5; b1<=`N; end
            
            110: begin note_div <= 0; counter <= `REST_HALFBEAT_100; b3<=0; b2<=5'd0; b1<=`R; end
            111: begin note_div <= `GS4; counter <= `EIGHTH_NOTE_100; b3<=`G; b2<=5'd4; b1<=`S; end
            112: begin note_div <= `A4; counter <= `EIGHTH_NOTE_100; b3<=`A; b2<=5'd4; b1<=`N; end
            113: begin note_div <= `C5; counter <= `EIGHTH_NOTE_100; b3<=`C; b2<=5'd5; b1<=`N; end
            114: begin note_div <= 0; counter <= `REST_HALFBEAT_100; b3<=0; b2<=5'd0; b1<=`R; end
            115: begin note_div <= `A4; counter <= `EIGHTH_NOTE_100; b3<=`A; b2<=5'd4; b1<=`N; end
            116: begin note_div <= `C5; counter <= `EIGHTH_NOTE_100; b3<=`C; b2<=5'd5; b1<=`N; end
            117: begin note_div <= `DS5; counter <= `EIGHTH_NOTE_100; b3<=`D; b2<=5'd5; b1<=`S; end
            
            118: begin note_div <= 0; counter <= `REST_ONEBEAT_100; b3<=0; b2<=5'd0; b1<=`R; end
            119: begin note_div <= `G5; counter <= `EIGHTH_NOTE_100; b3<=`G; b2<=5'd5; b1<=`N; end
            120: begin note_div <= `FS5; counter <= `EIGHTH_NOTE_100; b3<=`F; b2<=5'd5; b1<=`S; end
            121: begin note_div <= `F5; counter <= `EIGHTH_NOTE_100; b3<=`F; b2<=5'd5; b1<=`N; end
            122: begin note_div <= `DS5; counter <= `QUARTER_NOTE_100; b3<=`D; b2<=5'd5; b1<=`S; end
            123: begin note_div <= `E5; counter <= `EIGHTH_NOTE_100; b3<=`E; b2<=5'd5; b1<=`N; end
            
            124: begin note_div <= 0; counter <= `REST_HALFBEAT_100; b3<=0; b2<=5'd0; b1<=`R; end
            125: begin note_div <= `C6; counter <= `QUARTER_NOTE_100; b3<=`C; b2<=5'd6; b1<=`N; end
            126: begin note_div <= 0; counter <= `REST_1_512BEAT_100; b3<=0; b2<=5'd0; b1<=`R; end
            127: begin note_div <= `C6; counter <= `EIGHTH_NOTE_100; b3<=`C; b2<=5'd6; b1<=`N; end
            128: begin note_div <= 0; counter <= `REST_1_512BEAT_100; b3<=0; b2<=5'd0; b1<=`R; end
            129: begin note_div <= `C6; counter <= `QUARTER_NOTE_100; b3<=`C; b2<=5'd6; b1<=`N; end
            130: begin note_div <= 0; counter <= `REST_ONEBEAT_100; b3<=0; b2<=5'd0; b1<=`R; end
            
            131: begin note_div <= 0; counter <= `REST_ONEBEAT_100; b3<=0; b2<=5'd0; b1<=`R; end
            132: begin note_div <= `G5; counter <= `EIGHTH_NOTE_100; b3<=`G; b2<=5'd5; b1<=`N; end
            133: begin note_div <= `FS5; counter <= `EIGHTH_NOTE_100; b3<=`F; b2<=5'd5; b1<=`S; end
            134: begin note_div <= `F5; counter <= `EIGHTH_NOTE_100; b3<=`F; b2<=5'd5; b1<=`N; end
            135: begin note_div <= `DS5; counter <= `QUARTER_NOTE_100; b3<=`D; b2<=5'd5; b1<=`S; end
            136: begin note_div <= `E5; counter <= `EIGHTH_NOTE_100; b3<=`E; b2<=5'd5; b1<=`N; end
            
            137: begin note_div <= 0; counter <= `REST_HALFBEAT_100; b3<=0; b2<=5'd0; b1<=`R; end
            138: begin note_div <= `GS4; counter <= `EIGHTH_NOTE_100; b3<=`G; b2<=5'd4; b1<=`S; end
            139: begin note_div <= `A4; counter <= `EIGHTH_NOTE_100; b3<=`A; b2<=5'd4; b1<=`N; end
            140: begin note_div <= `C5; counter <= `EIGHTH_NOTE_100; b3<=`C; b2<=5'd5; b1<=`N; end
            141: begin note_div <= 0; counter <= `REST_HALFBEAT_100; b3<=0; b2<=5'd0; b1<=`R; end
            142: begin note_div <= `A4; counter <= `EIGHTH_NOTE_100; b3<=`A; b2<=5'd4; b1<=`N; end
            143: begin note_div <= `C5; counter <= `EIGHTH_NOTE_100; b3<=`C; b2<=5'd5; b1<=`N; end
            144: begin note_div <= `D5; counter <= `EIGHTH_NOTE_100; b3<=`D; b2<=5'd5; b1<=`N; end
            
            145: begin note_div <= 0; counter <= `REST_ONEBEAT_100; b3<=0; b2<=5'd0; b1<=`R; end
            146: begin note_div <= `DS5; counter <= `QUARTER_NOTE_100; b3<=`D; b2<=5'd5; b1<=`S; end
            147: begin note_div <= 0; counter <= `REST_HALFBEAT_100; b3<=0; b2<=5'd0; b1<=`R; end
            148: begin note_div <= `D5; counter <= `QUARTER_NOTE_100; b3<=`D; b2<=5'd5; b1<=`N; end
            149: begin note_div <= 0; counter <= `REST_HALFBEAT_100; b3<=0; b2<=5'd0; b1<=`R; end
            
            150: begin note_div <= `C5; counter <= `QUARTER_NOTE_100; b3<=`C; b2<=5'd5; b1<=`N; end
            151: begin note_div <= 0; counter <= `REST_ONEBEAT_100; b3<=0; b2<=5'd0; b1<=`R; end
            152: begin note_div <= 0; counter <= `REST_TWOBEAT_100; b3<=0; b2<=5'd0; b1<=`R; end
            ////
            default: begin note_div <= 0; note_index <= 0; end
          endcase
          note_index <= note_index + 1;
        end else begin
          counter <= counter-1;
        end 
      end 
    end
endmodule

`timescale 1ns / 1ps

`define UP 2'd0
`define LEFT 2'd1
`define DOWN 2'd2
`define RIGHT 2'd3

parameter MAX_Y = 480;
parameter MAX_X = 640;

module snake_mov(
    input clk_25Mhz,
    input clk,
    input rst,
    input valid,
    output reg [11:0] colour_in,
    input [2:0] game_state,
    input [1:0] dir_state,
    input [9:0] v_cnt,
    input [9:0] h_cnt,
    input [17:0] rnd_addr,
    output reg target_ate,
    input [11:0] pixel0,
    input [11:0] pixel1,
    input [11:0] pixel2,
    input [11:0] pixel3,
    input [11:0] pixel4,
    input [11:0] pixel_num0,
    input [11:0] pixel_num1,
    input [11:0] pixel_num2,
    input [11:0] pixel_num3,
    input [11:0] pixel_num4,
    input [11:0] pixel_num5,
    input [11:0] pixel_num6,
    input [11:0] pixel_num7,
    input [11:0] pixel_num8,
    input [11:0] pixel_num9,
    input [11:0] pixel_pause,
    input [11:0] pixel_level1,
    input [11:0] pixel_level2,
    input [11:0] pixel_level3,
    input [3:0] score_count0,
    input [3:0] score_count1,
    input [27:0] mov_speed,
    output reg [16:0] pixel_addr,
    output reg lost
);
parameter LENGTH = 99;
reg [9:0] SNAKE_X [0:LENGTH-1];
reg [9:0] SNAKE_Y [0:LENGTH-1];
wire SCORE,SCORE0,SCORE1,LEVEL1,LEVEL2,LEVEL3;
wire trigger,PAUSE;
reg [5:0] snake_length; // 6-bit counter for snake length
parameter INITIAL_LENGTH = 3;
wire SNAKE_HEAD,target;
reg [LENGTH-1:0] SNAKE_BODY;
parameter offset_x = 40;
parameter offset_y = 20;
parameter range_x = 440; // Reduced range to prevent targets appearing at edges
parameter range_y = 440;
reg [9:0] target_x, target_y;
wire [9:0] rnd_x = ((offset_x + (rnd_addr[8:0] % (range_x / 20)) * 20));
wire [9:0] rnd_y = ((offset_y + (rnd_addr[17:9] % (range_y / 20)) * 20));
assign SCORE = (h_cnt>464 && h_cnt<615) && (v_cnt>100 && v_cnt<=200); // width: 150, height:100 
assign SCORE0 = (h_cnt>539 && h_cnt<616) && (v_cnt>201 && v_cnt<=301);
assign SCORE1 = (h_cnt>464 && h_cnt<=540) && (v_cnt>201 && v_cnt<=301);
assign SNAKE_HEAD = (h_cnt >= SNAKE_X[0] && h_cnt < SNAKE_X[0] + 20) && (v_cnt >= SNAKE_Y[0] && v_cnt < SNAKE_Y[0] + 20);
assign target = (h_cnt >= target_x && h_cnt < target_x + 20) && (v_cnt >= target_y && v_cnt < target_y + 20);
assign PAUSE = (h_cnt >=155 && h_cnt<305) && (v_cnt>=170 && v_cnt<270);
assign LEVEL1 = (h_cnt>=20 && h_cnt<175) && (v_cnt>=20 && v_cnt<420);
assign LEVEL2 = (h_cnt>=225 && h_cnt<375) && (v_cnt>=20 && v_cnt<420);
assign LEVEL3 = (h_cnt>=425 && h_cnt<575) && (v_cnt>=20 && v_cnt<420);

mov_clk M1(.clk(clk), .rst(rst), .enable(1), .trig_out(trigger),.mov_speed(mov_speed));
always @* begin
    if (game_state == `STATE_START_INTERFACE|| game_state == `STATE_WIN_INTERFACE) pixel_addr <= (((h_cnt >> 1)>>1) + 160 * ((v_cnt >> 1)>>1)) % 19200;
    else if ((game_state == `STATE_PLAY||game_state==`STATE_PAUSE) && SNAKE_HEAD) pixel_addr <= (h_cnt-SNAKE_X[0]) + 20*(v_cnt-SNAKE_Y[0]);
    else if ((game_state == `STATE_PLAY||game_state== `STATE_PAUSE) && target) pixel_addr <= (h_cnt-target_x) + 20*(v_cnt-target_y);
    else if ((game_state == `STATE_PLAY||game_state==`STATE_PAUSE) && SCORE) pixel_addr <= (h_cnt-465) + 150*(v_cnt-101);
    else if ((game_state == `STATE_PLAY||game_state==`STATE_PAUSE) && SCORE0) pixel_addr <= ((h_cnt-540)>>1) + (76*((v_cnt-202)>>1)>>1);
    else if ((game_state == `STATE_PLAY||game_state== `STATE_PAUSE) && SCORE1) pixel_addr <= ((h_cnt-465)>>1) + (76*((v_cnt-202)>>1)>>1);
    else if (game_state == `STATE_PAUSE && PAUSE) pixel_addr <= ((h_cnt-155)>>1) + (75*((v_cnt-170)>>1));
    else if (game_state == `STATE_CHOOSE_LEVEL && LEVEL1) pixel_addr <= ((h_cnt-20)>>1) + (75*(((v_cnt-20)>>1)>>1));
    else if (game_state == `STATE_CHOOSE_LEVEL && LEVEL2) pixel_addr <= ((h_cnt-225)>>1) + (75*(((v_cnt-20)>>1)>>1));
    else if (game_state == `STATE_CHOOSE_LEVEL && LEVEL3) pixel_addr <= ((h_cnt-425)>>1) + (75*(((v_cnt-20)>>1)>>1));
    else if (game_state == `STATE_IDLE && SNAKE_HEAD) pixel_addr <= (h_cnt-SNAKE_X[0]) + 20*(v_cnt-SNAKE_Y[0]);
    else if (game_state == `STATE_IDLE && target) pixel_addr <= (h_cnt-200) + 20*(v_cnt-220);
    else pixel_addr=0;
end 

// Snake length and initialization logic
always @(posedge clk) begin
    if (game_state == `STATE_IDLE) begin
        snake_length <= INITIAL_LENGTH;
    end
    else if (game_state == `STATE_PLAY) begin
        if (target && SNAKE_HEAD) begin
            snake_length<=snake_length+1;
        end else begin
            snake_length<=snake_length;
        end 
    end
end

// Generate block to shift snake body
genvar PXL;
generate
    for (PXL = 0; PXL < LENGTH-1; PXL = PXL + 1) begin: PXL_SHIFT
        always @(posedge clk) begin
            if (game_state == `STATE_IDLE) begin
                SNAKE_X[PXL+1] <= 120-(PXL + 1)*20;
                SNAKE_Y[PXL+1] <= 100;
            end else if (trigger && PXL < snake_length && game_state == `STATE_PLAY) begin
                SNAKE_X[PXL+1] <= SNAKE_X[PXL];
                SNAKE_Y[PXL+1] <= SNAKE_Y[PXL];
            end else if (game_state == `STATE_PAUSE) begin
                SNAKE_X[PXL+1] <= SNAKE_X[PXL+1];
                SNAKE_Y[PXL+1] = SNAKE_Y[PXL+1];
            end
        end
    end
endgenerate

integer i;

// Update snake head position based on direction
always @(posedge clk) begin
    if (game_state == `STATE_IDLE) begin
        SNAKE_X[0] <= 120;
        SNAKE_Y[0] <= 100;
    end else if (trigger && game_state == `STATE_PLAY) begin
        case (dir_state)
            `UP: begin
                SNAKE_Y[0] <= SNAKE_Y[0] - 20;
            end
            `LEFT: begin
                SNAKE_X[0] <= SNAKE_X[0] -20;
            end
            `DOWN: begin
                SNAKE_Y[0] <= SNAKE_Y[0] +20;
            end
            `RIGHT: begin
                SNAKE_X[0] <= SNAKE_X[0]+20;
            end
        endcase  
    end else if (game_state == `STATE_PAUSE) begin
        SNAKE_X[0] <= SNAKE_X[0];
        SNAKE_Y[0] <= SNAKE_Y[0];
    end
end

// Target logic and boundary logic and collision logic
always @(posedge clk) begin
    if (game_state == `STATE_IDLE) begin
        target_x <= 220;
        target_y <= 220;
        target_ate <= 0;
        lost<=0;
    end else if (game_state == `STATE_PLAY && target && SNAKE_HEAD) begin
        target_x <= rnd_x;
        target_y <= rnd_y;
        target_ate <= 1;
        lost<=0;
    end else if (game_state == `STATE_PLAY &&  (SNAKE_X[0]<=20 || SNAKE_X[0]>=440 || SNAKE_Y[0] <=10 || SNAKE_Y[0]>=460)) begin
        lost<=1;
    end
    else begin
        target_ate <= 0;
    end
    for (i=1;i<snake_length;i=i+1) begin
        if (SNAKE_X[0] == SNAKE_X[i] && SNAKE_Y[0]== SNAKE_Y[i]) begin
            lost<=1;
        end
    end
end

// Color and pixel calculation
always @* begin
    colour_in = 12'h000; // default color
    if (game_state == `STATE_PLAY || game_state == `STATE_PAUSE) begin
        for (i = 0; i < LENGTH-1; i = i + 1) begin
            if (i < snake_length) begin
                SNAKE_BODY[i] = (h_cnt >= SNAKE_X[i+1] && h_cnt < SNAKE_X[i+1] + 20) && (v_cnt >= SNAKE_Y[i+1] && v_cnt < SNAKE_Y[i+1] + 20);
            end else begin
                SNAKE_BODY[i] = 0;
            end
        end
        if (valid) begin
            if (SCORE) begin
                colour_in = pixel4;
            end else if (SCORE0) begin
                case (score_count0) 
                    4'd0: colour_in = pixel_num0;
                    4'd1: colour_in = pixel_num1;
                    4'd2: colour_in = pixel_num2;
                    4'd3: colour_in = pixel_num3;
                    4'd4: colour_in = pixel_num4;
                    4'd5: colour_in = pixel_num5;
                    4'd6: colour_in = pixel_num6;
                    4'd7: colour_in = pixel_num7;
                    4'd8: colour_in = pixel_num8;
                    4'd9: colour_in = pixel_num9;
                    default: colour_in = pixel_num0;
                endcase
            end else if (SCORE1) begin
                    case (score_count1) 
                    4'd0: colour_in = pixel_num0;
                    4'd1: colour_in = pixel_num1;
                    4'd2: colour_in = pixel_num2;
                    4'd3: colour_in = pixel_num3;
                    4'd4: colour_in = pixel_num4;
                    4'd5: colour_in = pixel_num5;
                    4'd6: colour_in = pixel_num6;
                    4'd7: colour_in = pixel_num7;
                    4'd8: colour_in = pixel_num8;
                    4'd9: colour_in = pixel_num9;
                    default: colour_in = pixel_num0;
                endcase
            end
            else if (h_cnt<40 || h_cnt>440 || v_cnt<20 || v_cnt>460) begin
                colour_in = 12'habe;
            end
            else if (game_state == `STATE_PAUSE && PAUSE) begin
                if (valid) begin
                    colour_in = pixel_pause;
                end
            end 
            else if (SNAKE_HEAD) begin
                colour_in = pixel2; // red for snake head
            end else if (target) begin
                colour_in = pixel3; // green for target
            end else if (valid) begin
                for (i = 0; i < snake_length; i = i + 1) begin
                    if (SNAKE_BODY[i]) begin
                        colour_in = 12'h0ff; // cyan for snake body
                    end
                end
            end
        end
    end

    else if (game_state == `STATE_IDLE) begin
        if (valid) begin
            if (SNAKE_HEAD) begin
                colour_in = pixel2; // green for snake head
            end else if (target) begin
                colour_in = pixel3;
            end
        end
    end else if (game_state == `STATE_START_INTERFACE) begin
            colour_in = pixel0;  //    PIXEL0
    end else if (game_state == `STATE_WIN_INTERFACE) begin
            colour_in = pixel1;  // PIXEL1
    end else if (game_state == `STATE_CHOOSE_LEVEL) begin
         if (valid) begin
            if (LEVEL1) colour_in = pixel_level1;
            else if (LEVEL2) colour_in = pixel_level2;
            else if (LEVEL3) colour_in = pixel_level3;
         end
     end
end

endmodule

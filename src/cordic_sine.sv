`default_nettype none
`timescale 1ns / 1ps

// 13 floating point, 2 integer bits 1 signed
module cordic_sine #(
    parameter WIDTH = 16,
    parameter FLOAT = 13,
    parameter STAGES = 13) (
  input wire clk,
  input wire rst,
  input wire signed [WIDTH-1:0] theta_in,
  input wire valid_in,
  output logic signed [WIDTH-1:0] cos_out,
  output logic signed [WIDTH-1:0] sin_out,
  output logic valid_out
  );
  logic signed [WIDTH-1:0] theta;
  logic signed [2*WIDTH-1:0] x = 1, y = 0;
  logic [1:0] state = 0;  // 0 - idle, 1 - processing, 2 - done
  logic [$clog2(STAGES):0] i = 0;
  logic done = 0;
  
  logic signed [12:0][WIDTH-1:0] atan_lut;
  assign atan_lut[0] = 16'h1921;
  assign atan_lut[1] = 16'h0ed6;
  assign atan_lut[2] = 16'h07d6;
  assign atan_lut[3] = 16'h03fa;
  assign atan_lut[4] = 16'h01ff;
  assign atan_lut[5] = 16'h00ff;
  assign atan_lut[6] = 16'h007f;
  assign atan_lut[7] = 16'h003f;
  assign atan_lut[8] = 16'h001f;
  assign atan_lut[9] = 16'h000f;
  assign atan_lut[10] = 16'h0007;
  assign atan_lut[11] = 16'h0003;
  assign atan_lut[12] = 16'h0001;

  logic signed [12:0][WIDTH-1:0] scaling;
  assign scaling[0] = 16'h2000;
  assign scaling[1] = 16'h16a0;
  assign scaling[2] = 16'h143d;
  assign scaling[3] = 16'h13a2;
  assign scaling[4] = 16'h137b;
  assign scaling[5] = 16'h1371;
  assign scaling[6] = 16'h136f;
  assign scaling[7] = 16'h136e;
  assign scaling[8] = 16'h136e;
  assign scaling[9] = 16'h136e;
  assign scaling[10] = 16'h136e;
  assign scaling[11] = 16'h136e;
  assign scaling[12] = 16'h136e;

  always_ff @( posedge clk ) begin
    if(rst) begin
        i <= 0;
        theta <= 0;
        state <= 0;
        x <= 1 << FLOAT;
        y <= 0;
        done <= 0;
    end else if(state == 0) begin
        if(valid_in) begin
            state <= 1;
            
            if(theta_in > 12868) begin
                x <= -$signed(1 << FLOAT);
                theta <= theta_in - 25736;
            end else if(theta_in < -12868) begin
                x <= -$signed(1 << FLOAT);
                theta <= theta_in + 25736;
            end else begin
                x <= $signed(1 << FLOAT);
                theta <= theta_in;
            end
            
            y <= 0;
            i <= 0;
        end else state <= 0;
    end else if(state == 1) begin
        if(theta[WIDTH-1:0] > 0 && i < STAGES) begin
            // $display("i: %d, y: %d", i, y);
            if(theta[WIDTH-1]) begin
                x <= x + (y >>> i);
                y <= y - (x >>> i);
                theta  <= theta + $signed(atan_lut[i]);
            end else begin
                x <= x - (y >>> i);
                y <= y + (x >>> i);
                theta  <= theta - $signed(atan_lut[i]);
            end
            i <= i + 1;
            if(i + 1 == STAGES) begin
                state <= 2;
                done <= 1;
                x <= (x * $signed(scaling[i])) >>> FLOAT;
                y <= (y * $signed(scaling[i])) >>> FLOAT;
            end
        end else begin
            state <= 2;
            done <= 1;
            x <= (x * $signed(scaling[i])) >>> FLOAT;
            y <= (y * $signed(scaling[i])) >>> FLOAT;
        end
    end else if(state == 2) begin
        state <= 0;
        done <= 0;
    end
  end
  
  assign cos_out = $signed(x[WIDTH-1:0]);
  assign sin_out = $signed(y[WIDTH-1:0]);
  assign valid_out = done;
endmodule

`default_nettype wire

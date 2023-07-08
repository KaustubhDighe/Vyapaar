`default_nettype none
`timescale 1ns / 1ps

// data_out = arctan(y_in/x_in)
module cordic_arctan #(
    parameter WIDTH = 16,
    parameter STAGES = 13) (
  input wire clk,
  input wire rst,
  input wire signed [WIDTH-1:0] y_in,
  input wire signed [WIDTH-1:0] x_in,
  input wire valid_in,
  output logic signed [WIDTH-1:0] theta_out,
  output logic valid_out
  );
  logic signed [WIDTH-1:0] theta = 0;
  logic signed [WIDTH-1:0] x, y;
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

  always_ff @( posedge clk ) begin
    if(rst) begin
        i <= 0;
        theta <= 0;
        state <= 0;
        x <= 0;
        y <= 0;
        done <= 0;
    end else if(state == 0) begin
        if(valid_in) begin
            
            state <= 1;
            if(x_in[WIDTH-1]) begin
                x <= -x_in;
                y <= -y_in;
                if(y_in[WIDTH-1]) begin
                    theta <= -$signed(16'h6488);
                end else begin
                    theta <= $signed(16'h6488);
                end
            end else begin
                x <= x_in;
                y <= y_in;
                theta <= 0;
            end
        end else state <= 0;
    end else if(state == 1) begin
        if(y[WIDTH-1:0] > 0 && i < STAGES) begin
            // $display("i: %d, y: %d", i, y);
            if(y[WIDTH-1]) begin
                x <= x - (y >>> i);
                y <= y + (x >>> i);
                theta  <= theta - $signed(atan_lut[i]);
            end else begin
                x <= x + (y >>> i);
                y <= y - (x >>> i);
                theta  <= theta + $signed(atan_lut[i]);
            end
            i <= i + 1;
            if(i + 1 == STAGES) begin
                state <= 2;
                done <= 1;
            end
        end else begin
            state <= 2;
            done <= 1;
        end
    end else if(state == 2) begin
        state <= 0;
        done <= 0;
        i <= 0;
    end
  end
  
  assign theta_out = theta;
  assign valid_out = done;
endmodule

`default_nettype wire

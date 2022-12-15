`default_nettype none
`timescale 1ns / 1ps
// https://www.investopedia.com/articles/07/ewma.asp
module covariance #( 
  parameter WIDTH = 16, 
  parameter FRACT = 8,
  parameter N_STOCKS = 4, 
  parameter LAMBDA = 1 << (FRACT - 2)) ( // lambda = 0.25 
  input wire clk,
  input wire rst,
  input wire valid_in,
  input wire signed [N_STOCKS - 1:0][WIDTH - 1:0] x_in,
  output logic valid_out,
  output logic signed [N_STOCKS-1:0][N_STOCKS-1:0][WIDTH - 1:0] cov_out
);
  logic [1:0] state = 0;
  logic [N_STOCKS - 1:0][WIDTH - 1:0] mean;
  logic [N_STOCKS - 1:0][N_STOCKS - 1:0][WIDTH - 1:0] cov;

  genvar i, j;
  generate
    for(i = 0; i < N_STOCKS; i++) begin
      always_ff @(posedge clk) begin
          if(rst) begin
            state <= 0;
            valid_out <= 0;
            mean[i] <= $signed(0);
          end else if(state == 0) begin
            if(valid_in) begin
              mean[i] <= $signed(x_in[i]);
              state <= 1;
              valid_out <= 1;
            end 
          end else if(state == 1) begin
            if(valid_in) begin
              // update mean
              mean[i] <= ($signed(mean[i]) * (($signed(1) <<< FRACT) - $signed(LAMBDA)) + $signed(x_in[i]) * LAMBDA) >>> FRACT;
              //$display(i, mean[i]);
              valid_out <= 1;
            end
          end
        end
    end
    for(i = 0; i < N_STOCKS; i++) begin
      for(j = 0; j < N_STOCKS; j++) begin
        always_ff @(posedge clk) begin
          if(rst) begin
            //state <= 0;
            //valid_out <= 0;
            cov[i][j] <= $signed(0);
          end else if(state == 0) begin
            if(valid_in) begin
              cov[i][j] <= $signed(0);
              state <= 1;
            end 
          end else if(state == 1) begin
            if(valid_in) begin
              // update covariance
              cov[i][j] <= ((($signed(1) <<< FRACT) - $signed(LAMBDA)) * $signed(cov[i][j]) * ($signed(1) <<< FRACT)
                              + (LAMBDA * ($signed(mean[i]) - $signed(x_in[i])) * ($signed(mean[j]) - $signed(x_in[j])))) >>> 2 * FRACT;
              // if(i == 0 && j == 0) begin
              //   $display(cov[i][j]);
              // end
            end
          end
        end
      end
    end
  endgenerate
 assign cov_out = cov;
endmodule

`default_nettype wire
`default_nettype none
`timescale 1ns / 1ps

module pivot #(
    parameter WIDTH = 16,
    parameter N_STOCKS = 4) (
  input signed [N_STOCKS-1:0][N_STOCKS-1:0][WIDTH - 1:0] matrix,
  output logic [$clog2(WIDTH) - 1:0] pivot_i,
  output logic [$clog2(WIDTH) - 1:0] pivot_j
  );
  // This module is combinational and works only for symmetric matrices
  logic [$clog2(WIDTH) - 1:0] i_max, j_max;
  logic signed [WIDTH - 1: 0] max_val = -1;
  genvar i, j;
  generate
  for(i = 0; i < N_STOCKS; i++) begin
    for(j = i+1; j < N_STOCKS; j++) begin
      always @(*) begin
        if(i != j && $signed(matrix[i][j]) > max_val) begin
            max_val = $signed(matrix[i][j]);
            i_max = i;
            j_max = j;
        end
      end
    end
  end
  endgenerate
  assign pivot_i = i_max;
  assign pivot_j = j_max;
endmodule

`default_nettype wire

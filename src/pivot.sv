`default_nettype none
`timescale 1ns / 1ps

module pivot #(
    parameter WIDTH = 16,
    parameter N_STOCKS = 4) (
  input signed [WIDTH - 1:0] matrix [N_STOCKS-1:0][N_STOCKS-1:0],
  output logic [$clog2(WIDTH) - 1:0] pivot_i,
  output logic [$clog2(WIDTH) - 1:0] pivot_j
  );
  // This module is combinational
  logic [$clog2(WIDTH) - 1:0] i_max, j_max;
  logic signed [WIDTH - 1: 0] max_val = -1;
  always_comb begin
    max_val = -1;
    i_max = 0;
    j_max = 0;
    for (int i = 0; i < N_STOCKS; i++) begin
        for (int j = 0; j < N_STOCKS; j++) begin
            //$display(max_val);
            if(i != j && matrix[i][j] > max_val) begin
                max_val = matrix[i][j];
                i_max = i;
                j_max = j;
            end
        end
    end 
  end
  assign pivot_i = i_max;
  assign pivot_j = j_max;
endmodule

`default_nettype wire

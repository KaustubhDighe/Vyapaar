`default_nettype none
`timescale 1ns / 1ps

module converge #(
    parameter WIDTH = 16,
    parameter FRACT = 8,
    parameter N_STOCKS = 4,
    parameter THRESHOLD = 2) (
  input signed [N_STOCKS-1:0][N_STOCKS-1:0][WIDTH - 1:0] matrix,
  output logic conv
  );
  // This module is combinational
  logic signed [N_STOCKS-1:0][WIDTH - 1:0] matrix_row;
  logic signed [2 * WIDTH - 1 + N_STOCKS * N_STOCKS - 1 : 0] sum_of_squares = 0;
  always @(*)  begin
    sum_of_squares = 0;
    for(int i = 0; i < N_STOCKS; i++) begin
      matrix_row = matrix[i];
      for(int j = 0; j < N_STOCKS; j++) begin
        //$display(sum_of_squares);
        if(i != j) begin
          sum_of_squares = sum_of_squares + ($signed(matrix_row[j]) ** 2);
        end
        // squaring a fixed width decimal = n1 * 2^FRACT * n1 * 2^FRACT
        // so remove a multiplication of 2^FRACT
      end
    end
  end
  assign conv = ((sum_of_squares >>> FRACT) < (1 << THRESHOLD));
endmodule

`default_nettype wire

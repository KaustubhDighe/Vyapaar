`default_nettype none
`timescale 1ns / 1ps

module converge #(
    parameter WIDTH = 16,
    parameter FRACT = 8,
    parameter N_STOCKS = 4,
    parameter THRESHOLD = 2) (
  input signed [WIDTH - 1:0] matrix [N_STOCKS-1:0][N_STOCKS-1:0],
  output logic conv
  );
  // This module is combinational
  logic signed [2 * WIDTH - 1 + N_STOCKS * N_STOCKS - 1 : 0] sum_of_squares = 0;
  always_comb  begin
    sum_of_squares = 0;
    for (int i = 0; i < N_STOCKS; i++) begin
        for (int j = 0; j < N_STOCKS; j++) begin
            if (i != j) begin
                sum_of_squares = sum_of_squares + matrix[i][j] ** 2;
            end
        end
    end
    // squaring a fixed width decimal = n1 * 2^FRACT * n1 * 2^FRACT
    // so remove a multiplication of 2^FRACT
    //$display(sum_of_squares);
    sum_of_squares = (sum_of_squares >> FRACT); 
    //$display(sum_of_squares);
    end
  assign conv = (sum_of_squares < (1 << THRESHOLD));
endmodule

`default_nettype wire

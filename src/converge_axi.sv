`default_nettype none
`timescale 1ns / 1ps

module converge_axi #(
    parameter WIDTH = 16,
    parameter N_STOCKS = 4
    parameter THRESHOLD = 1) (
  input wire clk,
  input wire rst,
  input wire axiiv,
  input wire [WIDTH - 1:0] axiid,
  output logic axiov,
  output logic axiod
  );
  logic [1:0] state = 0;
  logic [$clog2(N_STOCKS) - 1:0] i, j;
  logic [$clog2(N_STOCKS) * WIDTH - 1: 0] sum_of_squares = 0;
  always_ff @(posedge clk) begin
    if(rst) begin
      state <= 0;
      sum_of_squares <= 0;
      i <= 0;
      j <= 0;
    end else if(state == 0) begin
      if(axiiv) begin
        state <= 1;
        i <= 1;
        j <= 0;
      end
    end else if(state == 1) begin
      axiov <= 0;
      if(axiiv) begin
        if(i != j) begin
            sum_of_squares <= sum_of_squares + axiid * axiid;
        end
        if(i < N_STOCKS - 1) begin
            i <= i + 1;
            state <= 1;
        end else if(j < N_STOCKS - 1) begin
            i <= 0;
            j <= j + 1;
            state <= 1;
        end else begin
            state <= 2;
            i <= 0;
            j <= 0;
        end
      end else begin
        state <= 2;
        i <= 0;
        j <= 0;
      end 
    end else if(state == 2) begin
        axiov <= 1;
        axiod <= (sum_of_squares <= THRESHOLD);
        state <= 0;
      end  
    end
endmodule

`default_nettype wire

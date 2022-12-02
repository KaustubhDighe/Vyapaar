`default_nettype none
`timescale 1ns / 1ps

module pivot #(
    parameter WIDTH = 16,
    parameter N_STOCKS = 4) (
  input wire clk,
  input wire rst,
  input wire axiiv,
  input wire [WIDTH - 1:0] axiid,
  output logic axiov,
  output logic [$clog2(N_STOCKS) - 1:0][1:0] axiod  //i, j
  );
  logic [2:0] state = 0;
  logic [$clog2(N_STOCKS) - 1:0] i, j, i_max, j_max;
  logic [WIDTH - 1: 0] max_val;
  always_ff @(posedge clk) begin
    if(rst) begin
      state <= 0;
      i <= 0;
      j <= 0;
      i_max <= 0;
      j_max <= 0;
      max_val <= 0;
    end else if(state == 0) begin
      if(axiiv) begin
        if(max_val < axiid) begin
            i <= i_max;
            j <= j_max;
            max_val <= axiid;
        end
      end else begin
        axiov <= 1;
        axiod <= {i_max, j_max};
      end  
    end
  end
endmodule

`default_nettype wire

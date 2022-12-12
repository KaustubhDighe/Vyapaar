`default_nettype none
`timescale 1ns / 1ps

module pivot_axi #(
    parameter WIDTH = 16,
    parameter N_STOCKS = 4) (
  input wire clk,
  input wire rst,
  input wire axiiv,
  input wire [WIDTH - 1:0] axiid,
  output logic axiov,
  output logic [$clog2(N_STOCKS) - 1:0][1:0] axiod  //i, j
  );
  logic [1:0] state = 0;
  logic [$clog2(N_STOCKS) - 1:0] i, j, i_max, j_max;
  logic signed [WIDTH - 1: 0] max_val;
  always_ff @(posedge clk) begin
    if(rst) begin
      state <= 0;
      i <= 0;
      j <= 0;
      i_max <= 0;
      j_max <= 0;
      max_val <= $signed(-1);
    end else if(state == 0) begin
      if(axiiv) begin
        state <= 1;
        i <= 1;
        j <= 0;
      end
    end else if(state == 1) begin
      axiov <= 0;
      if(axiiv) begin
        if(max_val < axiid && i != j) begin
            i_max <= i;
            j_max <= j;
            max_val <= axiid;
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
        axiod <= {i_max, j_max};
        state <= 0;
      end  
    end
endmodule

`default_nettype wire

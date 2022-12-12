`default_nettype none
`timescale 1ns / 1ps

module eigendecompose #(
    parameter WIDTH = 16,
    parameter N_STOCKS = 4) (
  input wire clk,
  input wire rst,
  input wire start,
  input signed [N_STOCKS-1:0][N_STOCKS-1:0][WIDTH - 1:0] matrix,
  output wire done,
  output signed [N_STOCKS-1:0][N_STOCKS-1:0][WIDTH - 1:0] eigenvectors,
  output signed [N_STOCKS-1:0][N_STOCKS-1:0][WIDTH - 1:0] eigenvalues
  );

  logic signed [N_STOCKS-1:0][N_STOCKS-1:0][WIDTH - 1:0] diag_in;
  logic signed [N_STOCKS-1:0][N_STOCKS-1:0][WIDTH - 1:0] diag_out;
  logic signed [N_STOCKS-1:0][N_STOCKS-1:0][WIDTH - 1:0] q_in;
  logic signed [N_STOCKS-1:0][N_STOCKS-1:0][WIDTH - 1:0] q_out;

  logic state = 0;
  
  logic conv = 0;
  converge converge_0(.matrix(matrix), .conv(conv));

  logic [$clog2(WIDTH) - 1:0][1:0] pivot_index;
  pivot pivot_0(.matrix(matrix), .index(pivot_index));

  logic [$clog2(WIDTH) - 1:0] i, j;

  logic j_axiiv, j_axiov;
  jacobi rotate(
    .clk(clk),
    .rst(rst),
    .axiiv(j_axiiv),
    .diag_in(diag_in),
    .q_in(q_in),
    .i(i),
    .j(j),
    .axiov(j_axiov),
    .diag_out(diag_out),
    .q_out(q_out)
  );

  always_ff @( posedge clk ) begin
    if (rst) begin
      state <= 0;
      done <= 0;
    end else if(state == 0) begin
      done <= 0;
      if(start) begin
        i <= pivot_index[0];
        j <= pivot_index[1];
        j_axiiv <= 1;
        
        diag_in <= matrix;
        for(int i = 0; i < N_STOCKS; i++) begin
          for(int j = 0; j < N_STOCKS; j++) begin
            q_in[i][j] <= (i == j) ? 1 : 0;
          end
        end

        state <= 1;
      end
    end else if(state == 1) begin
      if(j_axiov) begin
        if(conv) begin
          state <= 0;
          done <= 1;
          eigenvectors <= q_out;
          eigenvalues <= diag_out;
          j_axiiv <= 0;
        end else begin
          i <= pivot_index[0];
          j <= pivot_index[1];
          diag_in <= diag_out;
          q_in <= q_out;
          state <= 1;
          j_axiiv <= 1;
        end
      end else begin
        j_axiiv <= 0;  // j_axiiv should remain high for only one cycle
      end
    end
  end
endmodule

`default_nettype wire

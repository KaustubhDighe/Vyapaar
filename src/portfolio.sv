`default_nettype none
`timescale 1ns / 1ps

module eigenportfolio #(
    parameter WIDTH = 16,
    parameter N_STOCKS = 3) (
  input wire clk,
  input wire rst,
  input wire start,
  input wire signed [N_STOCKS * N_STOCKS -1:0][WIDTH - 1:0] eigenvectors,
  input wire signed [N_STOCKS * N_STOCKS -1:0][WIDTH - 1:0] eigenvalues,
  output logic done,
  output logic signed [N_STOCKS-1:0][WIDTH - 1:0] portfolio
  );
  logic [3:0] state = 0;
  logic signed [N_STOCKS-1:0][WIDTH-1:0] eigenvector, portfolio_reg;
  logic signed [WIDTH + N_STOCKS:0] sum;
  logic start_div;
  logic [2:0] complete_div, overflow_div;

  // eigenvector corresponding to 2nd-highest eigenvalue
  assign eigenvector = 
    ($signed(eigenvalues[0 * N_STOCKS + 0]) > $signed(eigenvalues[1 * N_STOCKS + 1]) 
    && $signed(eigenvalues[2 * N_STOCKS + 2]) > $signed(eigenvalues[0 * N_STOCKS + 0]))
    || ($signed(eigenvalues[0 * N_STOCKS + 0]) < $signed(eigenvalues[1 * N_STOCKS + 1]) 
    && $signed(eigenvalues[2 * N_STOCKS + 2]) < $signed(eigenvalues[0 * N_STOCKS + 0]))
        ?  {eigenvectors[2 * N_STOCKS + 0], eigenvectors[1 * N_STOCKS + 0], eigenvectors[0 * N_STOCKS + 0]}
    : ($signed(eigenvalues[1 * N_STOCKS + 1]) > $signed(eigenvalues[0 * N_STOCKS + 0]) 
    && $signed(eigenvalues[2 * N_STOCKS + 2]) > $signed(eigenvalues[1 * N_STOCKS + 1]))
    || ($signed(eigenvalues[1 * N_STOCKS + 1]) < $signed(eigenvalues[0 * N_STOCKS + 0]) 
    && $signed(eigenvalues[2 * N_STOCKS + 2]) < $signed(eigenvalues[1 * N_STOCKS + 1]))
        ?  {eigenvectors[2 * N_STOCKS + 1], eigenvectors[1 * N_STOCKS + 1], eigenvectors[0 * N_STOCKS + 1]}
    : {eigenvectors[2 * N_STOCKS + 2], eigenvectors[1 * N_STOCKS + 2], eigenvectors[0 * N_STOCKS + 2]};
  
  assign sum = $signed(eigenvector[0]) + $signed(eigenvector[1]) + $signed(eigenvector[2]);

  genvar i;
  generate
    for(i = 0; i < N_STOCKS; i++) begin
        qdiv divider_i (
            .i_dividend(eigenvector[i]),
            .i_divisor(sum[WIDTH-1:0]),
            .i_clk(clk),
            .i_start(start_div),
            .o_quotient_out(portfolio[i]),
            .o_complete(complete_div[i]),
            .o_overflow(overflow_div[i])
        );
    end
  endgenerate
  
  always_ff @(posedge clk) begin
    if(rst) begin
        state <= 0;
        start_div <= 0;
    end else if(state == 0) begin
        done <= 0;
        if(start) begin
            start_div <= 1;
            state <= 1;
        end
    end else if(state <= 1) begin
        start_div <= 0;
        state <= state + 1;
    end else if(state == 2) begin
        //$display(sum[WIDTH-1:0]);
        if(| complete_div) begin
            state <= 0;
            done <= 1;
        end
    end
  end

  // assign done = ((complete_div === 3'b111) && (state == 1));
endmodule

`default_nettype wire

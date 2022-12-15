`default_nettype none
`timescale 1ns / 1ps

module eigendecompose #(
    parameter WIDTH = 16,
    parameter N_STOCKS = 4) (
  input wire clk,
  input wire rst,
  input wire start,
  input wire signed [N_STOCKS * N_STOCKS - 1:0][WIDTH - 1:0] matrix,
  output logic done,
  output logic signed [N_STOCKS * N_STOCKS - 1:0][WIDTH - 1:0] eigenvectors,
  output logic signed [N_STOCKS * N_STOCKS - 1:0][WIDTH - 1:0] eigenvalues
  );

  logic [1:0] state = 0;

  logic signed [N_STOCKS * N_STOCKS - 1:0][WIDTH - 1:0] D;
  logic signed [N_STOCKS * N_STOCKS - 1:0][WIDTH - 1:0] Q;
  
  logic conv;
  converge #(.N_STOCKS(N_STOCKS)) converge_0(
    .matrix(D), 
    .conv(conv)
  );

  logic [$clog2(WIDTH) - 1:0] pivot_i, pivot_j;
  pivot #(.N_STOCKS(N_STOCKS))pivot_0(
    .matrix(D), 
    .pivot_i(pivot_i),
    .pivot_j(pivot_j)
  );

  logic [$clog2(WIDTH) - 1:0] i, j;

  logic arctan_valid_in, arctan_valid_out;
  logic signed [WIDTH - 1: 0] theta, arctan_data_out;

  logic signed [2*WIDTH - 1: 0] arctan_data_in;
  logic signed [WIDTH - 1: 0] arctan_y, arctan_x;
  assign arctan_data_in = {arctan_y, arctan_x};

  cordic_arctan arctan (
    .aclk(clk),
    .s_axis_cartesian_tdata(arctan_data_in),
    .s_axis_cartesian_tvalid(arctan_valid_in),
    .m_axis_dout_tdata(arctan_data_out),
    .m_axis_dout_tvalid(arctan_valid_out)
  );

  logic sincos_valid_in, sincos_valid_out;
  logic signed [2*WIDTH - 1: 0] sincos_data_out;

  logic signed [WIDTH - 1: 0] sincos_data_in;
  logic signed [WIDTH - 1: 0] s, c;
  assign s = $signed(sincos_data_out[2*WIDTH-1 : WIDTH]) >>> (8 - 3);
  assign c = $signed(sincos_data_out[WIDTH - 1 : 0]) >>> (8 - 3);

  logic signed [WIDTH - 1: 0] new_Dii, new_Djj, new_Dij;
  assign new_Dii = c * c * $signed( D[i * N_STOCKS + i]) - 2 * s * c * $signed( D[i * N_STOCKS + j]) + s * s * $signed( D[j * N_STOCKS + j]);
  assign new_Djj = s * s * $signed( D[i * N_STOCKS + i]) + 2 * s * c * $signed( D[i * N_STOCKS + j]) + c * c * $signed( D[j * N_STOCKS + j]);
  assign new_Dij = (c * c - s * s) * $signed( D[i * N_STOCKS + j]) + s * c * ($signed( D[i * N_STOCKS + i]) - $signed( D[j * N_STOCKS + j]));

  logic signed [N_STOCKS - 1: 0] new_Dik, new_Djk;
  genvar k;
  generate
    for(k = 0; k < N_STOCKS; k++) begin
      assign new_Dik[k] = c * $signed( D[i * N_STOCKS + k]) - s * $signed( D[j * N_STOCKS + k]);
      assign new_Djk[k] = s * $signed( D[i * N_STOCKS + k]) + c * $signed( D[j * N_STOCKS + k]);
    end
  endgenerate

  cordic_sine sincos (
    .aclk(clk),
    .s_axis_phase_tdata(sincos_data_in),
    .s_axis_phase_tvalid(sincos_valid_in),
    .m_axis_dout_tdata(sincos_data_out),
    .m_axis_dout_tvalid(sincos_valid_out)
  );

  always_ff @( posedge clk ) begin
    if (rst) begin
      state <= 0;
      done <= 0;
      arctan_valid_in <= 0;
      sincos_valid_in <= 0;
    end else if(state == 0) begin
      done <= 0;
      if(start) begin
        D <= matrix;
        for(int row = 0; row < N_STOCKS; row++) begin
          for(int col = 0; col < N_STOCKS; col++) begin
            Q[row * N_STOCKS + col] <= (row == col) ? 1 : 0;
          end
        end
        state <= 1;
      end
    end else if(state == 1) begin
      if(conv) begin
        done <= 1;
        eigenvectors <= Q;
        eigenvalues <= D;
        state <= 0;
      end else begin
        i <= pivot_i;
        j <= pivot_j;
        arctan_y <= $signed(D[pivot_i * N_STOCKS + pivot_j]) <<< 1;
        arctan_x <= $signed(D[pivot_j * N_STOCKS + pivot_j]) - $signed(D[pivot_i * N_STOCKS + pivot_i]);
        arctan_valid_in <= 1;
        state <= 2;
      end
    end else if(state == 2) begin
      if(arctan_valid_out) begin
        sincos_data_in <= $signed(arctan_data_out) >>> 1;
        sincos_valid_in <= 1;
        state <= 3;
      end
    end else if(state == 3) begin
      if(sincos_valid_out) begin
        D[i * N_STOCKS + i] <= new_Dii;
        D[j * N_STOCKS + j] <= new_Djj;
        D[i * N_STOCKS + j] <= new_Dij;
        D[j * N_STOCKS + i] <= new_Dij;

        for(int k = 0; k < N_STOCKS; k++) begin
          if(k != i && k != j) begin
            D[i * N_STOCKS + k] <= new_Dik[k];
            D[k * N_STOCKS + i] <= new_Dik[k];
            D[j * N_STOCKS + k] <= new_Djk[k];
            D[k * N_STOCKS + j] <= new_Djk[k];
          end
          Q[k * N_STOCKS + i] <= c * $signed(Q[k * N_STOCKS + i]) - s * $signed(Q[k * N_STOCKS + j]);
          Q[k * N_STOCKS + j] <= s * $signed(Q[k * N_STOCKS + i]) + c * $signed(Q[k * N_STOCKS + j]);
        end
        state <= 1;
      end
    end
  end
endmodule

`default_nettype wire

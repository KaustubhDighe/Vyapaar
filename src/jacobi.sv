`default_nettype none
`timescale 1ns / 1ps

module jacobi #(
    parameter WIDTH = 16,
    parameter N_STOCKS = 4) (
  input wire clk,
  input wire rst,
  input wire axiiv,
  input wire signed [N_STOCKS * N_STOCKS - 1:0][WIDTH - 1:0] diag_in,
  input wire signed [N_STOCKS * N_STOCKS - 1:0][WIDTH - 1:0] q_in,
  input wire [$clog2(WIDTH) - 1:0] i,
  input wire [$clog2(WIDTH) - 1:0] j,
  output logic axiov,
  output logic signed [N_STOCKS * N_STOCKS - 1:0][WIDTH - 1:0] diag_out,
  output logic signed [N_STOCKS * N_STOCKS - 1:0][WIDTH - 1:0] q_out
  );
  logic [1:0] state = 0;

  logic arctan_valid_in, arctan_valid_out;
  logic [3:0] arctan_user_in, arctan_user_out;
  logic signed [WIDTH - 1: 0] theta, arctan_data_out;

  logic signed [2*WIDTH - 1: 0] arctan_data_in;
  logic signed [WIDTH - 1: 0] arctan_y, arctan_x;
  assign arctan_data_in = {arctan_y, arctan_x};

  /*cordic_arctan arctan (
    .aclk(clk),
    .s_axis_cartesian_tdata(arctan_data_in),
    .s_axis_cartesian_tvalid(arctan_valid_in),
    .s_axis_cartesian_tuser(arctan_user_in),
    .m_axis_dout_tdata(arctan_data_out),
    .m_axis_dout_tvalid(arctan_valid_out),
    .m_axis_dout_tuser(arctan_user_out)
  );*/

  logic sincos_valid_in, sincos_valid_out;
  logic [3:0] sincos_user_in, sincos_user_out;
  logic signed [2*WIDTH - 1: 0] sincos_data_out;

  logic signed [WIDTH - 1: 0] sincos_data_in;
  logic signed [WIDTH - 1: 0] sin, cos;
  assign sin = $signed(sincos_data_out[2*WIDTH-1 : WIDTH]) >>> (8 - 3);
  assign cos = $signed(sincos_data_out[WIDTH - 1 : 0]) >>> (8 - 3);

  genvar row, col;
  for(row = 0; row < N_STOCKS; row++) begin
    for(col = 0; col < N_STOCKS; col++) begin
      always @(*) begin
        if(row != i && row != j && col != i && col != j) begin
          diag_out[row * N_STOCKS + col] = diag_in[row * N_STOCKS + col];
        end else if(row == i && col != i && col != j) begin
          diag_out[row * N_STOCKS + col] = cos * diag_in[i * N_STOCKS + col] - sin * diag_in[j * N_STOCKS + col];
        end else if(row == j && col != j && col != i) begin
          diag_out[row * N_STOCKS + col] = sin * diag_in[i * N_STOCKS + col] + cos * diag_in[j * N_STOCKS + col];
        end else if(row != i && row != j && col == i) begin
          diag_out[row * N_STOCKS + col] = cos * diag_in[i * N_STOCKS + col] - sin * diag_in[j * N_STOCKS + col];
        end else if(row != j && row != i && col == j) begin
          diag_out[row * N_STOCKS + col] = sin * diag_in[i * N_STOCKS + col] + cos * diag_in[j * N_STOCKS + col];
        end else if(row == i && col == i) begin
          diag_out[row * N_STOCKS + col] = cos * cos * diag_in[i * N_STOCKS + i];
        end else if(row == j && col == j) begin
          diag_out[row * N_STOCKS + col] = 0;
        end else begin
          diag_out[row * N_STOCKS + col] = 0;
        end
      end
    end
  end

  
  /*cordic_sine sincos (
    .aclk(clk),
    .s_axis_cartesian_tdata(sincos_data_in),
    .s_axis_cartesian_tvalid(sincos_valid_in),
    .s_axis_cartesian_tuser(sincos_user_in),
    .m_axis_dout_tdata(sincos_data_out),
    .m_axis_dout_tvalid(sincos_valid_out),
    .m_axis_dout_tuser(sincos_user_out)
  );*/

  always_ff @(posedge clk) begin
    if(rst) begin
      state <= 0;
      axiov <= 0;
      arctan_valid_in <= 0;
    end else if(state == 0) begin
      if(axiiv) begin
        arctan_y <= $signed(diag_in[i * N_STOCKS + j]) <<< 1;
        arctan_x <= $signed(diag_in[j * N_STOCKS + j] - diag_in[i * N_STOCKS + i]);
        arctan_valid_in <= 1;
        state <= 1;
      end
    end else if(state == 1) begin
      if(arctan_valid_out) begin
        sincos_data_in <= $signed(arctan_data_out) >>> 1;
        sincos_valid_in <= 1;
        state <= 2;
      end
    end else if(state == 2) begin
      if(sincos_valid_out) begin
        axiov <= 1;
      end
    end else if(state == 3) begin
    end
  end
endmodule

`default_nettype wire

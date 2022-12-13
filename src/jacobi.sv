`default_nettype none
`timescale 1ns / 1ps

module jacobi #(
    parameter WIDTH = 16,
    parameter N_STOCKS = 4) (
  input wire clk,
  input wire rst,
  input wire axiiv,
  input signed [N_STOCKS-1:0][N_STOCKS-1:0][WIDTH - 1:0] diag_in,
  input signed [N_STOCKS-1:0][N_STOCKS-1:0][WIDTH - 1:0] q_in,
  input wire [$clog2(WIDTH) - 1:0] i,
  input wire [$clog2(WIDTH) - 1:0] j,
  output logic axiov,
  output signed [N_STOCKS-1:0][N_STOCKS-1:0][WIDTH - 1:0] diag_out,
  output signed [N_STOCKS-1:0][N_STOCKS-1:0][WIDTH - 1:0] q_out
  );
  // states
  // 0 - waiting for valid input
  // 1 - computing tan (2*theta) and sending to arctan
  // 2 - got theta, now commputing sin and cos
  // 3 - got sin and cos, computing updated matrix.
  logic [1:0] state = 0;

  // TODO: may need to change widths and integer widths
  logic signed [WIDTH - 1: 0] tan2theta;
  logic signed [WIDTH - 1: 0] theta;

  cordic_arctan arctan (
    .aclk(clk),
    .s_axis_cartesian_tdata(arctan_data_in),
    .s_axis_cartesian_tvalid(arctan_valid_in),
    .s_axis_cartesian_tuser(arctan_user_in),
    .m_axis_dout_tdata(arctan_data_out),
    .m_axis_dout_tvalid(arctan_valid_out),
    .m_axis_dout_tuser(arctan_user_out)
  );
  
  cordic_sine sincos (
    .aclk(clk),
    .s_axis_cartesian_tdata(sincos_data_in),
    .s_axis_cartesian_tvalid(sincos_valid_in),
    .s_axis_cartesian_tuser(sincos_user_in),
    .m_axis_dout_tdata(sincos_data_out),
    .m_axis_dout_tvalid(sincos_valid_out),
    .m_axis_dout_tuser(sincos_user_out)
  );

  always_ff @(posedge clk) begin
    if(rst) begin
        state <= 0;
        axiov <= 0;
        tan2theta <= $signed(0);
    end else if(state == 0) begin
        if(axiiv) begin
            if(diag_in[i][i] == diag_in[j][j]) begin
                theta <= (pi/4);
                state <= 2;
            end else begin 
                tan2theta <= ;
                state <= 1;
            end
        end
    end else if(state == 1) begin
    end else if(state == 2) begin
    end else if(state == 3) begin
    end
  end
endmodule

`default_nettype wire

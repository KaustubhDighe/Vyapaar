`default_nettype none
`timescale 1ns / 1ps

module converge_tb;
  logic clk;
  logic rst;
  logic signed [15:0] matrix [1:0][1:0];
  logic conv;

  converge #(.N_STOCKS(2)) dut(.matrix(matrix), .conv(conv));

  always begin
    #10;
    clk = !clk;
  end

  initial begin
    $dumpfile("converge.vcd"); //file to store value change dump (vcd)
    $dumpvars(0,converge_tb); //store everything at the current level and below
    $display("Starting Sim"); //print nice message
    clk = 1;
    rst = 1;
    #20;
    rst = 0;
    #20;

    // Test 1
    matrix[0][0] = 16'b10000000000;
    matrix[0][1] = 16'b10000000000;
    matrix[1][0] = 16'b10000000000;
    matrix[1][1] = 16'b10000000000;
    #20;
    $display(conv);

    // Test 2
    matrix[0][0] = 16'b10000000000;
    matrix[0][1] = 16'b00000000000;
    matrix[1][0] = 16'b00000000000;
    matrix[1][1] = 16'b10000000000;
    #20;
    $display(conv);
    $finish;
  end
endmodule

`default_nettype wire

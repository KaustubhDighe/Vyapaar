`default_nettype none
`timescale 1ns / 1ps

module eigen_tb;
  logic clk;
  logic rst;
  logic [4:0][7:0] axiid;
  logic axiiv;
  logic [4 * 3:0][7:0] axiod;
  logic axiov;

  always begin
    #10;
    clk = !clk;
  end

  initial begin
    $dumpfile("eigen.vcd"); //file to store value change dump (vcd)
    $dumpvars(0,eigen_tb); //store everything at the current level and below
    $display("Starting Sim"); //print nice message
    clk = 1;
    rst = 1;
    axiiv = 0;
    #20;
    rst = 0;

    #60;

    // Test 1
    axiid = {8'd1, 8'd0, 8'd0, 8'd1};
    axiiv = 1;
    #100;
    for(int i = 0; i < 3*4; i = i + 1) begin
      $display("%d \n", axiod[i]);
    end
    $finish;
  end
endmodule

`default_nettype wire

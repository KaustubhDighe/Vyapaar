`default_nettype none
`timescale 1ns / 1ps

module pivot_tb;
  logic clk;
  logic rst;
  logic signed [2:0][2:0][15:0] matrix;
  logic [3:0] index[1:0];

  pivot #(.N_STOCKS(3)) dut(.matrix(matrix), .pivot_i(index[0]), .pivot_j(index[1]));

  always begin
    #10;
    clk = !clk;
  end

  initial begin
    $dumpfile("pivot.vcd"); //file to store value change dump (vcd)
    $dumpvars(0,pivot_tb); //store everything at the current level and below
    $display("Starting Sim"); //print nice message
    clk = 1;
    rst = 1;
    #20;
    rst = 0;
    #20;

    // Only symmetric matrices
    // Test 1
    $display("Test 1 ..");
    matrix[0][0] = 16'b000_0010_0000;
    matrix[0][1] = 16'b010_1000_0000;
    matrix[0][2] = 16'b000_0010_0000;
    matrix[1][0] = 16'b010_1000_0000;
    matrix[1][1] = 16'b111_0000_0000;
    matrix[1][2] = 16'b100_0100_0100;
    matrix[2][0] = 16'b000_0010_0000;
    matrix[2][1] = 16'b100_0100_0000;
    matrix[2][2] = 16'b100_0000_0000;
    #20;
    if(index[0] == 1 && index[1] == 2) begin
        $display("Test 1 PASSED");
    end else begin
        $display("Test 1 FAILED : Check for off diagonal logic");
        $display(index[0]);
        $display(index[1]);
    end

    // Test 2
    $display("Test 2 ..");
    matrix[0][0] = 16'b0000_0100_0000_0000;
    matrix[0][1] = 16'b0011_0010_0000_0000;
    matrix[0][2] = 16'b1100_0100_0000_0000;
    matrix[1][0] = 16'b0011_0010_0000_0000;
    matrix[1][1] = 16'b1000_0000_0000_0000;
    matrix[1][2] = 16'b1000_1000_0000_0000;
    matrix[2][0] = 16'b1100_0100_0000_0000;
    matrix[2][1] = 16'b1000_1000_0000_0000;
    matrix[2][2] = 16'b1000_0000_0000_0000;
    #20;
    if(index[0] == 0 && index[1] == 1) begin
        $display("Test 2 PASSED");
    end else begin
        $display("Test 2 FAILED : Check for signed logic");
        $display(index[0]);
        $display(index[1]);
    end
    $finish;
  end
endmodule

`default_nettype wire

`default_nettype none
`timescale 1ns / 1ps

module covariance_tb;
  logic clk;
  logic rst;
  logic valid_in;
  logic valid_out;
  logic signed [1:0][15:0] x_in;
  logic signed [1:0][1:0][15:0] cov ;

  logic test_ok;

  covariance #(.N_STOCKS(2)) dut(
    .clk(clk),
    .rst(rst),
    .valid_in(valid_in),
    .x_in(x_in), 
    .valid_out(valid_out),
    .cov_out(cov));

  always begin
    #10;
    clk = !clk;
  end

  initial begin
    $dumpfile("covariance.vcd"); //file to store value change dump (vcd)
    $dumpvars(0,covariance_tb); //store everything at the current level and below
    $display("Starting Sim"); //print nice message
    clk = 1;
    rst = 1;
    valid_in = 0;
    #20;
    rst = 0;
    #20;

    /*
    a[0][0] = 0.00, a[0][1] = 3.00;
    a[1][0] = 1.00, a[1][1] = 3.00;
    a[2][0] = 2.00, a[2][1] = 3.00;
    a[3][0] = 3.00, a[3][1] = 3.00;
    a[4][0] = 4.00, a[4][1] = 3.00;
    a[5][0] = 5.00, a[5][1] = 3.00;
    */
    test_ok = 0;
    // Test 1
    $display("Test 1 ..");
    valid_in = 1;
    x_in[0] = 16'b0000_0000_0000_0000;
    x_in[1] = 16'b0000_0011_0000_0000;
    #20;
    x_in[0] = 16'b0000_0001_0000_0000;
    x_in[1] = 16'b0000_0011_0000_0000;
    #20;
    x_in[0] = 16'b0000_0010_0000_0000;
    x_in[1] = 16'b0000_0011_0000_0000;
    #20;
    x_in[0] = 16'b0000_0011_0000_0000;
    x_in[1] = 16'b0000_0011_0000_0000;
    #20;
    x_in[0] = 16'b0000_0100_0000_0000;
    x_in[1] = 16'b0000_0011_0000_0000;
    #20;
    x_in[0] = 16'b0000_0101_0000_0000;
    x_in[1] = 16'b0000_0011_0000_0000;
    #20;
    if(cov[0][0] == 1249 &&
       cov[0][1] == 0 &&
       cov[1][0] == 0 &&
       cov[1][1] == 0 ) begin
        $display("Test 1 PASSED");
    end else begin
        $display("Test 1 FAILED : Check for signed logic");
        $display(cov[0][0]);
        $display(cov[0][1]);
        $display(cov[1][0]);
        $display(cov[1][1]);
    end

    /*
    a[0][0] = 0.00, a[0][1] = 3.00;
    a[1][0] = 1.00, a[1][1] = 5.00;
    a[2][0] = 2.00, a[2][1] = -3.00;
    a[3][0] = 3.00, a[3][1] = 1.00;
    a[4][0] = 4.00, a[4][1] = 9.00;
    a[5][0] = 5.00, a[5][1] = 3.00;
    */
    test_ok = 0;
    rst = 1;
    #20;
    rst = 0;
    // Test 2
    $display("Test 2 ..");
    valid_in = 1;
    x_in[0] = 16'b0000_0000_0000_0000;
    x_in[1] = 16'b0000_0011_0000_0000;
    #20;
    x_in[0] = 16'b0000_0001_0000_0000;
    x_in[1] = 16'b0000_0101_0000_0000;
    #20;
    x_in[0] = 16'b0000_0010_0000_0000;
    x_in[1] = 16'b1111_1101_0000_0000;
    #20;
    x_in[0] = 16'b0000_0011_0000_0000;
    x_in[1] = 16'b0000_0001_0000_0000;
    #20;
    x_in[0] = 16'b0000_0100_0000_0000;
    x_in[1] = 16'b0000_1001_0000_0000;
    #20;
    x_in[0] = 16'b0000_0101_0000_0000;
    x_in[1] = 16'b0000_0011_0000_0000;
    #20;
    if(cov[0][0] == 1249 &&
       cov[0][1] == 527 &&
       cov[1][0] == 527 &&
       cov[1][1] == 3853 ) begin
        $display("Test 2 PASSED");
    end else begin
        $display("Test 2 FAILED : Check for negative signed logic");
        $display(cov[0][0]);
        $display(cov[0][1]);
        $display(cov[1][0]);
        $display(cov[1][1]);
    end
    $finish;
  end
endmodule

`default_nettype wire

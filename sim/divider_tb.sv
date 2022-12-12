`default_nettype none
`timescale 1ns / 1ps

module divider_tb;
  logic clk;
  logic start, complete, overflow;
  logic signed [15:0] dividend, divisor, quotient;

  qdiv dut(
    .i_dividend(dividend),
    .i_divisor(divisor),
    .i_clk(clk),
    .i_start(start),
    .o_quotient_out(quotient),
    .o_complete(complete),
    .o_overflow(overflow)
  );

  logic test_ok;
  always begin
    #10;
    clk = !clk;
  end

  initial begin
    $dumpfile("divider.vcd"); //file to store value change dump (vcd)
    $dumpvars(0, divider_tb); //store everything at the current level and below
    $display("Starting Sim"); //print nice message
    clk = 1;
    //rst = 1;
    start = 0;
    #20;
    //rst = 0;
    #20;

    test_ok = 0;
    // Test 1
    $display("Test 1 ..");
    start = 1;
    dividend = 16'b0000_0011_0000_0000;
    $display(dividend >>> 8);
    divisor =  16'b0000_0110_0000_0000;
    $display(divisor >>> 8);
    #20;
    start = 0;
    for(int i = 0; i < 24; i++) begin
        #20;
        if(complete) begin
            $display(i);
            $display(quotient);
            test_ok = quotient == 16'b0000_0000_1000_0000; 
        end
    end
    if(test_ok) $display("TEST 1 : fraction PASSED");
    else $display("TEST 1 : fraction failed");

    test_ok = 0;
    // Test 1
    $display("Test 2 ..");
    start = 1;
    dividend = 16'b1111_1101_0000_0000;
    $display(dividend >>> 8);
    divisor =  16'b0000_0110_0000_0000;
    $display(divisor >>> 8);
    #20;
    start = 0;
    for(int i = 0; i < 24; i++) begin
        #20;
        if(complete) begin
            $display(i);
            $display(overflow);
            $display(quotient);
            test_ok = quotient == 16'b1111_1111_1000_0000; 
        end
    end
    if(test_ok) $display("TEST 2 : negative fractions PASSED");
    else $display("TEST 2 : negative fractions failed");
    $finish;
  end
endmodule

`default_nettype wire

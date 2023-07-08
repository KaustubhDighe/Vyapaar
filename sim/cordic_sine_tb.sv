`default_nettype none
`timescale 1ns / 1ps

module cordic_sine_tb;
  logic clk;
  logic rst;
  logic signed [15:0] cos_out, sin_out, theta_in;
  logic valid_in, valid_out;

  logic test_ok;

  cordic_sine dut(
    .clk(clk),
    .rst(rst),
    .theta_in(theta_in),
    .valid_in(valid_in),
    .cos_out(cos_out),
    .sin_out(sin_out),
    .valid_out(valid_out)
  );

  always begin
    #10;
    clk = !clk;
  end

  initial begin
    $dumpfile("sine.vcd"); //file to store value change dump (vcd)
    $dumpvars(0, cordic_sine_tb); //store everything at the current level and below
    $display("Starting Sim"); //print nice message
    clk = 1;
    rst = 1;
    valid_in = 0;
    #20;
    rst = 0;
    #20;

    test_ok = 0;
    // Test 1
    $display("Test 1 theta = pi/4");
    valid_in = 1;
    theta_in = $signed(16'h1921);
    #20;
    valid_in = 0;
    for(int i = 0; i < 16; i++) begin
        if(valid_out && !test_ok) begin
            if(cos_out == 5792 && sin_out == 5792) begin
                test_ok = 1;
                $display(i);
                $display("Test 1 PASSED");
            end else begin
                $display("Test 1 FAILED");
                $display(cos_out);
            end
        end
        #20;
    end

    test_ok = 0;
    // Test 2
    $display("Test 2 theta = pi/3");
    valid_in = 1;
    theta_in = $signed(8579);
    #20;
    valid_in = 0;
    for(int i = 0; i < 16; i++) begin
        if(valid_out && !test_ok) begin
            if(cos_out == 4096 && sin_out == 7093) begin
                test_ok = 1;
                $display(i);
                $display("Test 2 PASSED");
                $display(sin_out);
            end else begin
                $display("Test 2 FAILED");
                $display(sin_out);
            end
        end
        #20;
    end

    test_ok = 0;
    // Test 3
    $display("Test 3 theta = -pi/4");
    valid_in = 1;
    theta_in = -$signed(16'h1921);
    #20;
    valid_in = 0;
    for(int i = 0; i < 16; i++) begin
        if(valid_out && !test_ok) begin
            if(cos_out == 5792 && sin_out == -5792) begin
                test_ok = 1;
                $display(i);
                $display("Test 3 PASSED");
            end else begin
                $display("Test 3 FAILED");
                $display(cos_out);
            end
        end
        #20;
    end

    test_ok = 0;
    // Test 3
    $display("Test 4 theta = 3*pi/4");
    valid_in = 1;
    theta_in = 3 * $signed(16'h1921);
    #20;
    valid_in = 0;
    for(int i = 0; i < 16; i++) begin
        if(valid_out && !test_ok) begin
            if(cos_out == -5793 && sin_out == 5793) begin
                test_ok = 1;
                $display(i);
                $display("Test 4 PASSED");
            end else begin
                $display("Test 4 FAILED");
                $display(cos_out);
                $display(sin_out);
            end
        end
        #20;
    end

    test_ok = 0;
    // Test 2
    $display("Test 5 theta = -2*pi/3");
    valid_in = 1;
    theta_in = -2*$signed(8579);
    #20;
    valid_in = 0;
    for(int i = 0; i < 16; i++) begin
        if(valid_out && !test_ok) begin
            if(cos_out + 4096 <= 2 && cos_out + 4096 >= -2  && sin_out == -7093) begin
                test_ok = 1;
                $display(i);
                $display("Test 2 PASSED");
                $display(sin_out);
            end else begin
                $display("Test 2 FAILED");
                $display(cos_out);
            end
        end
        #20;
    end
    $finish;
  end
endmodule

`default_nettype wire
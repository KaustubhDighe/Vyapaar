`default_nettype none
`timescale 1ns / 1ps

module cordic_arctan_tb;
  logic clk;
  logic rst;
  logic signed [15:0] y_in, x_in, theta_out;
  logic valid_in, valid_out;

  logic test_ok;

  cordic_arctan dut(
    .clk(clk),
    .rst(rst),
    .y_in(y_in),
    .x_in(x_in),
    .valid_in(valid_in),
    .theta_out(theta_out),
    .valid_out(valid_out)
  );

  always begin
    #10;
    clk = !clk;
  end

  initial begin
    $dumpfile("arctan.vcd"); //file to store value change dump (vcd)
    $dumpvars(0, cordic_arctan_tb); //store everything at the current level and below
    $display("Starting Sim"); //print nice message
    clk = 1;
    rst = 1;
    valid_in = 0;
    #20;
    rst = 0;
    #20;

    test_ok = 0;
    // Test 1
    $display("Test 1 (atan(1) = pi/4)..");
    valid_in = 1;
    y_in = 16'b0010_0000_0000_0000; // 1.0000
    x_in = 16'b0010_0000_0000_0000; // 1.0000
    #20;
    valid_in = 0;
    for(int i = 0; i < 16; i++) begin
        if(valid_out && !test_ok) begin
            if(theta_out == 16'h1921) begin
                test_ok = 1;
                $display(i);
                $display("Test 1 PASSED");
            end else begin
                $display("Test 1 FAILED");
                $display(theta_out);
            end
        end
        #20;
    end

    test_ok = 0;
    // Test 2
    $display("Test 2 (atan(1/2) = 0.463647");
    valid_in = 1;
    y_in = 16'b0010_0000_0000_0000; // 1.0000
    x_in = 16'b0100_0000_0000_0000; // 1.0000
    #20;
    valid_in = 0;
    for(int i = 0; i < 16; i++) begin
        if(valid_out && !test_ok) begin
            if($signed(theta_out - 3798) <= 2 && $signed(theta_out - 3798) >= -2) begin
                test_ok = 1;
                $display(i);
                $display("Test 2 PASSED");
            end else begin
                $display("Test 2 FAILED");
                $display(theta_out);
            end
        end
        #20;
    end

    test_ok = 0;
    // Test 3
    $display("Test 3 (atan(-1) = -pi/4");
    valid_in = 1;
    y_in = 16'b1110_0000_0000_0000; // -1.0000
    x_in = 16'b0010_0000_0000_0000; // 1.0000
    #20;
    valid_in = 0;
    for(int i = 0; i < 16; i++) begin
        if(valid_out && !test_ok) begin
            if($signed(theta_out - 16'hE6DD) <= 2 && $signed(theta_out - 16'hE6DD) >= -2) begin
                test_ok = 1;
                $display(i);
                $display("Test 3 PASSED");
            end else begin
                $display("Test 3 FAILED");
                $display("%h", theta_out );
                $display(theta_out);
            end
        end
        #20;
    end

    test_ok = 0;
    // Test 3
    $display("Test 4 (atan(-1) = 3*pi/4");
    valid_in = 1;
    y_in = 16'b0010_0000_0000_0000; // 1.0000
    x_in = 16'b1110_0000_0000_0000; // -1.0000
    #20;
    valid_in = 0;
    for(int i = 0; i < 16; i++) begin
        if(valid_out && !test_ok) begin
            if($signed(theta_out - 16'h4B66) <= 1 && $signed(theta_out - 16'h4B66) >= -1) begin
                test_ok = 1;
                $display(i);
                $display("Test 4 PASSED");
            end else begin
                $display("Test 4 FAILED");
                $display("%h", theta_out - 16'h4b66 <= 8 );
                $display(y_in);
            end
        end
        #20;
    end

    test_ok = 0;
    // Test 2
    $display("Test 5 thrid quadrant");
    valid_in = 1;
    y_in = -$signed(16'b0100_0000_0000_0000); // -2.0000
    x_in = -$signed(16'b0010_0000_0000_0000); // -1.0000
    #20;
    valid_in = 0;
    for(int i = 0; i < 16; i++) begin
        if(valid_out && !test_ok) begin
            if($signed(theta_out + 16666) <= 1 && $signed(theta_out + 16666) >= -1) begin
                test_ok = 1;
                $display(theta_out);
                $display("Test 5 PASSED");
            end else begin
                $display("Test 5 FAILED");
                $display(theta_out);
            end
        end
        #20;
    end
    $finish;
  end
endmodule

`default_nettype wire
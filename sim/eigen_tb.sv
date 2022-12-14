`default_nettype none
`timescale 1ns / 1ps

module eigen_tb;
  logic clk;
  logic rst;
  logic start;
  logic done;
  logic signed [1:0][1:0][15:0] matrix, eigenvectors, eigenvalues;

  logic test_ok;

  eigendecompose #(.N_STOCKS(2)) dut(
    .clk(clk),
    .rst(rst),
    .start(start),
    .matrix(matrix),
    .done(done),
    .eigenvectors(eigenvectors),
    .eigenvalues(eigenvalues)
  );

  always begin
    #10;
    clk = !clk;
  end

  initial begin
    $dumpfile("eigen.vcd"); //file to store value change dump (vcd)
    $dumpvars(0, eigen_tb); //store everything at the current level and below
    $display("Starting Sim"); //print nice message
    clk = 1;
    rst = 1;
    start = 0;
    #20;
    rst = 0;
    #20;

    test_ok = 0;
    // Test 1
    $display("Test 1 ..");
    start = 1;
    matrix[0][0] = 16'b0000_0010_0000_0000; // 2
    matrix[0][0] = 16'b0000_0011_0000_0000; // 3
    matrix[0][0] = 16'b0000_0011_0000_0000; // 3
    matrix[0][0] = 16'b0000_0100_0000_0000; // 4
    #20;
    start = 0;
    for(int i = 0; i < 30; i++) begin
        #20;
        if(done && !test_ok) begin
            if(eigenvalues[1][1] == 16'b0000_0110_0010_1001 && // 3 + sqrt(10)
            eigenvalues[0][0] == 16'b1111_1111_1101_0111 // 3 - sqrt(10)
            ) begin
                test_ok = 1;
                $display(i);
                $display("Test 1 PASSED");
            end else begin
                $display("Test 1 FAILED : Check for signed logic and cycles");
            end
        end
    end
    $finish;
  end
endmodule

`default_nettype wire

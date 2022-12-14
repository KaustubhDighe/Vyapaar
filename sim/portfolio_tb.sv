`default_nettype none
`timescale 1ns / 1ps

module portfolio_tb;
  logic clk;
  logic rst;
  logic start;
  logic done;
  logic signed [2:0][2:0][15:0] eigenvectors, eigenvalues;
  logic signed [2:0][15:0] portfolio;

  logic test_ok;

  eigenportfolio dut(
    .clk(clk),
    .rst(rst),
    .start(start),
    .eigenvectors(eigenvectors),
    .eigenvalues(eigenvalues),
    .done(done),
    .portfolio(portfolio)
  );

  always begin
    #10;
    clk = !clk;
  end

  initial begin
    $dumpfile("portfolio.vcd"); //file to store value change dump (vcd)
    $dumpvars(0, portfolio_tb); //store everything at the current level and below
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
    eigenvalues = 0;
    eigenvalues[0][0] = 3;
    eigenvalues[1][1] = 4;
    eigenvalues[2][2] = 1;

    eigenvectors[0][0] = 16'b0000_0001_0100_0000;  // 1.2500 -> 0.125  : 0_0010_0000 (32)
    eigenvectors[1][0] = 16'b0000_0011_1000_0000;  // 3.5000 -> 0.350  : 0_0101_1000 (88)
    eigenvectors[2][0] = 16'b0000_0101_0100_0000;  // 5.2500 -> 0.525  : 0_1000_0110 (134)
                                                   // sum = 10

    eigenvectors[0][1] = 16'b0000_0001_0000_0000;
    eigenvectors[1][1] = 16'b0010_0001_0000_0000;
    eigenvectors[2][1] = 16'b0001_0001_0000_0000;

    eigenvectors[0][2] = 16'b0000_1001_0000_0000;
    eigenvectors[1][2] = 16'b0001_0001_0000_0000;
    eigenvectors[2][2] = 16'b0000_0011_0000_0000;
    #20;
    start = 0;
    for(int i = 0; i < 30; i++) begin
        #20;
        if(done && !test_ok) begin
            if(portfolio[0] == 32 &&
            portfolio[1] == 88 &&
            portfolio[2] == 134) begin
                test_ok = 1;
                $display(i);
                $display("Test 1 PASSED");
            end else begin
                $display("Test 1 FAILED : Check for signed logic and cycles");
                $display(portfolio[0]);
                $display(portfolio[1]);
                $display(portfolio[2]);
            end
        end
    end

    test_ok = 0;
    // Test 2
    $display("Test 2 ..");
    start = 1;
    eigenvalues = 0;
    eigenvalues[0][0] = 3;
    eigenvalues[1][1] = 4;
    eigenvalues[2][2] = 10;

    eigenvectors[0][1] = 16'b0000_0001_0100_0000;  // 1.2500  -> 0.4166 : 0_0110_1010
    eigenvectors[1][1] = 16'b1111_1100_1000_0000;  // -3.5000 -> -1.166  : 1111_1110_1101_0110
    eigenvectors[2][1] = 16'b0000_0101_0100_0000;  // 5.2500  -> 1.75  : 01_1100_0000
                                                   // sum = 3

    eigenvectors[0][0] = 16'b0000_0001_0000_0000;
    eigenvectors[1][0] = 16'b0010_0001_0000_0000;
    eigenvectors[2][0] = 16'b0001_0001_0000_0000;

    eigenvectors[0][2] = 16'b0000_1001_0000_0000;
    eigenvectors[1][2] = 16'b0001_0001_0000_0000;
    eigenvectors[2][2] = 16'b0000_0011_0000_0000;
    #20;
    start = 0;
    for(int i = 0; i < 30; i++) begin
        #20;
        if(done && !test_ok) begin
            if(portfolio[0] == 16'b0110_1010 &&
            portfolio[1] == 16'b1111_1110_1101_0110 &&
            portfolio[2] == 16'b01_1100_0000) begin
                test_ok = 1;
                $display(i);
                $display("Test 2 PASSED");
            end else begin
                $display("Test 2 FAILED : Check for negative signed logic and cycles");
                $display(portfolio[0]);
                $display(portfolio[1]);
                $display(portfolio[2]);
            end
        end
    end
    $finish;
  end
endmodule

`default_nettype wire

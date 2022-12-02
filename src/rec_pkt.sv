`default_nettype none
`timescale 1ns / 1ps

module rec_pkt (
  input wire clk,
  input wire rst,
  input wire axiiv,
  input wire [1:0] axiid,
  output logic axiov,
  output logic [1:0] axiod
  );
  logic [47:0] mac_addr = 0;
  logic [5:0] state = 0;  // 57 states

  assign axiod = axiid;
  assign axiov = axiiv & (state == 56) & match;

  logic match = 0;
  always_ff @(posedge clk) begin
    if(rst) begin
      state <= 0;
      mac_addr <= 0;
      match <= 0;
    end else if(state < 24) begin
      if(axiiv) begin
        mac_addr <= {mac_addr[45:0], axiid};
        state <= state + 1;
      end else begin
        state <= 0;
        mac_addr <= 0;
        match <= 0;
      end
    end else if(state == 24) begin
      if(axiiv) begin
        state <= state + 1;
        match <= (mac_addr == 48'h69_69_5A_06_54_91) || (mac_addr == 48'hFF_FF_FF_FF_FF_FF);
      end else begin
        state <= 0;
        mac_addr <= 0;
        match <= 0;
      end
    end else if(state < 56) begin
      // 24 to 47 for src addr, 48 to 56 for length
      if(axiiv) begin
        state <= state + 1;
      end else begin
        state <= 0;
        mac_addr <= 0;
        match <= 0;
      end
    end else if(state == 56) begin
      if(!axiiv) begin
        state <= 0;
        mac_addr <= 0;
        match <= 0;
      end
    end
  end
endmodule

`default_nettype wire

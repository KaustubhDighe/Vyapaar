`default_nettype none

module seven_segment_controller #(parameter COUNT_TO = 'd100_000)
                        (input wire         clk_in,
                         input wire         rst_in,
                         input wire [31:0]  val_in,
                         output logic[6:0]   cat_out,
                         output logic[7:0]   an_out
                        );
  logic [7:0]	segment_state;
  logic [31:0]	segment_counter;
  logic [3:0]	routed_vals;
  logic [6:0]	led_out;

  logic [31:0] val, old_val;

  /* TODO: wire up routed_vals (-> x_in) with your input, val_in
   * Note that x_in is a 4 bit input, and val_in is 32 bits wide
   * Adjust accordingly, based on what you know re. which digits
   * are displayed when...
   */
  bto7s mbto7s (.x_in(routed_vals), .s_out(led_out));
  assign cat_out = ~led_out; //<--note this inversion is needed
  assign an_out = ~segment_state; //note this inversion is needed
  always_ff @(posedge clk_in)begin
    old_val <= val_in;
    if ((val_in != old_val) || rst_in)begin
      segment_state <= 8'b0000_0001;
      segment_counter <= 32'b0;
      val <= val_in;
    end else begin
      if (segment_counter == COUNT_TO) begin
        segment_counter <= 32'd0;
        segment_state <= {segment_state[6:0],segment_state[7]};
        val <= {val[3:0], val[31:4]};
    	end else begin
    	  segment_counter <= segment_counter +1;
    	end
      routed_vals <= val[3:0];
    end
  end
endmodule // seven_segment_controller

module bto7s(input wire [3:0]   x_in,output logic [6:0] s_out);
  // array of bits that are "one hot" with numbers 0 through 15
  logic [15:0] num;
  genvar i;
  generate
    for(i = 0; i < 16; i++) begin
      assign num[i] = x_in == i;
    end
  endgenerate

  /* assign the seven output segments, sa through sg, using a "sum of products"
   * approach and the diagram above.
   */
  assign s_out[0] = ~(num[1] || num[4] || num[11] || num[13]);
  assign s_out[1] = ~(num[5] || num[6] || num[11] || num[12] || num[14] || num[15]);
  assign s_out[2] = ~(num[2] || num[12] || num[14] || num[15]);
  assign s_out[3] = ~(num[1] || num[4] || num[7] || num[10] || num[15]);
  assign s_out[4] = ~(num[1] || num[3] || num[4] || num[5] || num[7] || num[9]);
  assign s_out[5] = ~(num[1] || num[2] || num[3] || num[7] || num[13]);
  assign s_out[6] = ~(num[0] || num[1] || num[7] || num[12]);
endmodule // bto7s

`default_nettype wire
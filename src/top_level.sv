`timescale 1ns / 1ps
`default_nettype none

module top_level(
  input wire clk_100mhz, //clock @ 100 mhz
  input wire btnc, //btnc (used for reset)
  
  output logic [7:0] an,
  output logic ca,cb,cc,cd,ce,cf,cg
  );
  
logic signed [75:0][2:0][15:0] data;

assign data[0][0] = 16'd10106;    assign data[0][1] = 16'd13386;    assign data[0][2] = 16'd25886;
assign data[1][0] = 16'd9100;    assign data[1][1] = 16'd13005;    assign data[1][2] = 16'd24934;
assign data[2][0] = 16'd9488;    assign data[2][1] = 16'd13705;    assign data[2][2] = 16'd26094;
assign data[3][0] = 16'd9467;    assign data[3][1] = 16'd13675;    assign data[3][2] = 16'd26127;
assign data[4][0] = 16'd9648;    assign data[4][1] = 16'd13776;    assign data[4][2] = 16'd26316;
assign data[5][0] = 16'd9811;    assign data[5][1] = 16'd13755;    assign data[5][2] = 16'd26693;
assign data[6][0] = 16'd9843;    assign data[6][1] = 16'd13700;    assign data[6][2] = 16'd26521;
assign data[7][0] = 16'd9746;    assign data[7][1] = 16'd13532;    assign data[7][2] = 16'd26316;
assign data[8][0] = 16'd9600;    assign data[8][1] = 16'd13372;    assign data[8][2] = 16'd26124;
assign data[9][0] = 16'd9796;    assign data[9][1] = 16'd13787;    assign data[9][2] = 16'd26882;
assign data[10][0] = 16'd9916;    assign data[10][1] = 16'd13836;    assign data[10][2] = 16'd26977;
assign data[11][0] = 16'd9975;    assign data[11][1] = 16'd13950;    assign data[11][2] = 16'd27166;
assign data[12][0] = 16'd10036;    assign data[12][1] = 16'd14057;    assign data[12][2] = 16'd27573;
assign data[13][0] = 16'd9811;    assign data[13][1] = 16'd13702;    assign data[13][2] = 16'd27054;
assign data[14][0] = 16'd9850;    assign data[14][1] = 16'd13767;    assign data[14][2] = 16'd27317;
assign data[15][0] = 16'd9772;    assign data[15][1] = 16'd13745;    assign data[15][2] = 16'd27187;
assign data[16][0] = 16'd10096;    assign data[16][1] = 16'd13964;    assign data[16][2] = 16'd27435;
assign data[17][0] = 16'd10003;    assign data[17][1] = 16'd13697;    assign data[17][2] = 16'd26900;
assign data[18][0] = 16'd9899;    assign data[18][1] = 16'd13575;    assign data[18][2] = 16'd26352;
assign data[19][0] = 16'd10576;    assign data[19][1] = 16'd13939;    assign data[19][2] = 16'd27233;
assign data[20][0] = 16'd10652;    assign data[20][1] = 16'd14289;    assign data[20][2] = 16'd26734;
assign data[21][0] = 16'd10657;    assign data[21][1] = 16'd14217;    assign data[21][2] = 16'd26311;
assign data[22][0] = 16'd10960;    assign data[22][1] = 16'd14499;    assign data[22][2] = 16'd27069;
assign data[23][0] = 16'd11147;    assign data[23][1] = 16'd14668;    assign data[23][2] = 16'd27448;
assign data[24][0] = 16'd11151;    assign data[24][1] = 16'd14274;    assign data[24][2] = 16'd27143;
assign data[25][0] = 16'd10940;    assign data[25][1] = 16'd14063;    assign data[25][2] = 16'd26949;
assign data[26][0] = 16'd10906;    assign data[26][1] = 16'd14016;    assign data[26][2] = 16'd27051;
assign data[27][0] = 16'd10843;    assign data[27][1] = 16'd14016;    assign data[27][2] = 16'd26944;
assign data[28][0] = 16'd10936;    assign data[28][1] = 16'd14353;    assign data[28][2] = 16'd27363;
assign data[29][0] = 16'd10891;    assign data[29][1] = 16'd14338;    assign data[29][2] = 16'd27343;
assign data[30][0] = 16'd10931;    assign data[30][1] = 16'd14357;    assign data[30][2] = 16'd27366;
assign data[31][0] = 16'd10906;    assign data[31][1] = 16'd14254;    assign data[31][2] = 16'd27704;
assign data[32][0] = 16'd10939;    assign data[32][1] = 16'd14317;    assign data[32][2] = 16'd27691;
assign data[33][0] = 16'd11009;    assign data[33][1] = 16'd14256;    assign data[33][2] = 16'd27430;
assign data[34][0] = 16'd10947;    assign data[34][1] = 16'd14041;    assign data[34][2] = 16'd28008;
assign data[35][0] = 16'd11070;    assign data[35][1] = 16'd14212;    assign data[35][2] = 16'd28408;
assign data[36][0] = 16'd11150;    assign data[36][1] = 16'd14200;    assign data[36][2] = 16'd28567;
assign data[37][0] = 16'd11157;    assign data[37][1] = 16'd14273;    assign data[37][2] = 16'd28764;
assign data[38][0] = 16'd11191;    assign data[38][1] = 16'd14285;    assign data[38][2] = 16'd28715;
assign data[39][0] = 16'd11081;    assign data[39][1] = 16'd14334;    assign data[39][2] = 16'd28679;
assign data[40][0] = 16'd11198;    assign data[40][1] = 16'd14604;    assign data[40][2] = 16'd28807;
assign data[41][0] = 16'd11254;    assign data[41][1] = 16'd14691;    assign data[41][2] = 16'd28738;
assign data[42][0] = 16'd11233;    assign data[42][1] = 16'd14873;    assign data[42][2] = 16'd28595;
assign data[43][0] = 16'd11169;    assign data[43][1] = 16'd14820;    assign data[43][2] = 16'd28608;
assign data[44][0] = 16'd11040;    assign data[44][1] = 16'd14634;    assign data[44][2] = 16'd28259;
assign data[45][0] = 16'd11066;    assign data[45][1] = 16'd14621;    assign data[45][2] = 16'd28290;
assign data[46][0] = 16'd11449;    assign data[46][1] = 16'd15049;    assign data[46][2] = 16'd28884;
assign data[47][0] = 16'd11578;    assign data[47][1] = 16'd15272;    assign data[47][2] = 16'd29086;
assign data[48][0] = 16'd11629;    assign data[48][1] = 16'd15274;    assign data[48][2] = 16'd29312;
assign data[49][0] = 16'd11758;    assign data[49][1] = 16'd15175;    assign data[49][2] = 16'd29335;
assign data[50][0] = 16'd11911;    assign data[50][1] = 16'd15161;    assign data[50][2] = 16'd29672;
assign data[51][0] = 16'd12033;    assign data[51][1] = 16'd15158;    assign data[51][2] = 16'd30097;
assign data[52][0] = 16'd11937;    assign data[52][1] = 16'd15345;    assign data[52][2] = 16'd30118;
assign data[53][0] = 16'd12042;    assign data[53][1] = 16'd15666;    assign data[53][2] = 16'd30085;
assign data[54][0] = 16'd12485;    assign data[54][1] = 16'd15763;    assign data[54][2] = 16'd30776;
assign data[55][0] = 16'd12227;    assign data[55][1] = 16'd15430;    assign data[55][2] = 16'd29964;
assign data[56][0] = 16'd12079;    assign data[56][1] = 16'd15270;    assign data[56][2] = 16'd30120;
assign data[57][0] = 16'd11954;    assign data[57][1] = 16'd15163;    assign data[57][2] = 16'd30184;
assign data[58][0] = 16'd12062;    assign data[58][1] = 16'd15014;    assign data[58][2] = 16'd29893;
assign data[59][0] = 16'd12078;    assign data[59][1] = 16'd14956;    assign data[59][2] = 16'd29934;
assign data[60][0] = 16'd12156;    assign data[60][1] = 16'd15018;    assign data[60][2] = 16'd30192;
assign data[61][0] = 16'd12239;    assign data[61][1] = 16'd15288;    assign data[61][2] = 16'd30469;
assign data[62][0] = 16'd12417;    assign data[62][1] = 16'd15366;    assign data[62][2] = 16'd30512;
assign data[63][0] = 16'd12502;    assign data[63][1] = 16'd15435;    assign data[63][2] = 16'd30712;
assign data[64][0] = 16'd12524;    assign data[64][1] = 16'd15552;    assign data[64][2] = 16'd30556;
assign data[65][0] = 16'd12608;    assign data[65][1] = 16'd15451;    assign data[65][2] = 16'd30691;
assign data[66][0] = 16'd12806;    assign data[66][1] = 16'd15409;    assign data[66][2] = 16'd30702;
assign data[67][0] = 16'd12768;    assign data[67][1] = 16'd15324;    assign data[67][2] = 16'd30535;
assign data[68][0] = 16'd12839;    assign data[68][1] = 16'd15387;    assign data[68][2] = 16'd30768;
assign data[69][0] = 16'd12732;    assign data[69][1] = 16'd15419;    assign data[69][2] = 16'd30804;
assign data[70][0] = 16'd12727;    assign data[70][1] = 16'd15588;    assign data[70][2] = 16'd30963;
assign data[71][0] = 16'd12750;    assign data[71][1] = 16'd15630;    assign data[71][2] = 16'd30988;
assign data[72][0] = 16'd12752;    assign data[72][1] = 16'd15707;    assign data[72][2] = 16'd30917;
assign data[73][0] = 16'd13000;    assign data[73][1] = 16'd15825;    assign data[73][2] = 16'd31173;
assign data[74][0] = 16'd13047;    assign data[74][1] = 16'd15825;    assign data[74][2] = 16'd31582;
assign data[75][0] = 16'd13089;    assign data[75][1] = 16'd15985;    assign data[75][2] = 16'd31682;

logic [7:0] cycle = 0;

logic signed [2:0][15:0] old_prices, new_prices, returns;

logic start_div = 0;
logic [2:0] complete_div, overflow_div;

genvar div_i;
generate
for(div_i = 0; div_i < 3; div_i++) begin
    qdiv divider_returns (
        .i_dividend(new_prices[div_i] - old_prices[div_i]),
        .i_divisor(old_prices[div_i]),
        .i_clk(clk_100mhz),
        .i_start(start_div),
        .o_quotient_out(returns[div_i]),
        .o_complete(complete_div[div_i]),
        .o_overflow(overflow_div[div_i])
    );
end
endgenerate

logic cov_valid;
logic signed [2:0][2:0][15:0] cov_of_returns;
covariance #(.N_STOCKS(3)) cov (
    .clk(clk_100mhz),
    .rst(btnc),
    .valid_in(| complete_div),
    .x_in(returns),
    .valid_out(cov_valid),
    .cov_out(cov_of_returns)
);

logic eig_done;
logic signed [8:0][15:0] eigenvectors, eigenvalues;
eigendecompose #(.N_STOCKS(3)) eig (
    .clk(clk_100mhz),
    .rst(btnc),
    .start(cov_valid),
    .matrix(cov_of_returns),
    .done(eig_done),
    .eigenvectors(eigenvectors),
    .eigenvalues(eigenvalues)
);

logic portfolio_done;
logic signed [2:0][15:0] portfolio;
eigenportfolio #(.N_STOCKS(3)) eig_portfolio (
    .clk(clk_100mhz),
    .rst(btnc),
    .start(eig_done),
    .eigenvectors(eigenvectors),
    .eigenvalues(eigenvalues),
    .done(portfolio_done),
    .portfolio(portfolio)
);

logic [15:0] capital = 16'd10000;  // $10,000

logic signed [2:0][15:0] cumulative_returns;
logic [31:0] present_money;

seven_segment_controller mssc(
    .clk_in(clk_100mhz),
    .rst_in(btnc),
    .val_in(capital),
    .cat_out({cg, cf, ce, cd, cc, cb, ca}),
    .an_out(an)
);

logic state = 0;
always_ff @(posedge clk_100mhz) begin
    if(btnc) begin
        cycle <= 1;
        state <= 0;
    end else if (state == 0) begin
        if(portfolio_done) begin
            if(cycle < 75) begin
                cycle <= cycle + 1;
                old_prices <= new_prices;
                new_prices <= data[cycle];
                cumulative_returns[0] <= ($signed(cumulative_returns[0]) + 1 <<< 8) * (1 <<< 8 + $signed(returns[0])) - 1 <<< 8;
                cumulative_returns[1] <= ($signed(cumulative_returns[1]) + 1 <<< 8) * (1 <<< 8 + $signed(returns[1])) - 1 <<< 8;
                cumulative_returns[2] <= ($signed(cumulative_returns[2]) + 1 <<< 8) * (1 <<< 8 + $signed(returns[2])) - 1 <<< 8;
                present_money <= capital * 
                            ((($signed(cumulative_returns[0]) + 1 <<< 8) * (1 <<< 8 + $signed(returns[0])) - 1 <<< 8) * portfolio[0]
                            + (($signed(cumulative_returns[1]) + 1 <<< 8) * (1 <<< 8 + $signed(returns[1])) - 1 <<< 8) * portfolio[1]
                            + (($signed(cumulative_returns[2]) + 1 <<< 8) * (1 <<< 8 + $signed(returns[2])) - 1 <<< 8) * portfolio[2]
                            + 1 << 8);
                start_div <= 1;
            end else begin
                state <= 1;
            end
        end
    end else if(state == 1) begin
        // just stay here
        state <= 1;
    end
end
endmodule
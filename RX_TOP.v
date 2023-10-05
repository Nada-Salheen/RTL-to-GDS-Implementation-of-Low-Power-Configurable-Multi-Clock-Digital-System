module RX_TOP# (parameter data_width=8)(

input wire RX_IN, PARITY_TYPE, PARITY_ENABLE, 
input wire [5:0] PRESCALE,
input wire CLK, RST,
output wire par_err, frame_error,DATA_VALID_IN,
output wire [data_width-1:0] P_DATA_IN
);

wire sample_bit;
wire parity_check_en, start_check_en, stop_chk_en, deserializer_en, counter_en, sampler_en;
wire [3:0] Edge, bit;


data_sampling data_sampling_U0(
.RX_in(RX_IN),
.prescalar(PRESCALE),
.data_sampling_en(sampler_en),
.edge_count(Edge),
.clk(CLK),
.rst(RST),
.sampled_bit(sample_bit));

deserializer deserializer_U1(
.des_en(deserializer_en),
.sampled_bit(sample_bit),
.edge_counter(Edge),
.clk(CLK),
.rst(RST),
.p_data(P_DATA_IN));

edge_bit_counter edge_bit_counter_U2(
.enable(counter_en),
.parity_en(PARITY_ENABLE),
.clk(CLK),
.rst(RST),
.bit_count(bit),
.edge_count(Edge));

FSM_RX FSM_RX_U3(
.RX_IN(RX_IN),
.parity_en(PARITY_ENABLE),
.bit_count(bit),
.edge_count(Edge),
.par_error(par_err),
.stop_error(stop_err),
.start_error(start_err),
.clk(CLK),
.rst(RST),
.data_valid(DATA_VALID_IN),
.par_check_enable(parity_check_en),
.start_check_enable(start_check_en),
.stop_check_enable(stop_chk_en),
.deserializer_enable(deserializer_en),
.counter_enable(counter_en),
.sampler_enable(sampler_en));

parity_check parity_check_U4(
.parity_type(PARITY_TYPE),
.parity_check_en(parity_check_en),
.sampled_bit(sample_bit),
.edge_num(Edge),
.bit_num(bit),
.parity_enable(PARITY_ENABLE),
.clk(CLK),
.rst(RST),
.parity_error(par_err));

start_check start_check_U5(
.start_check_en(start_check_en),
.sampled_bit(sample_bit),
.start_glitch(frame_error));

stop_check stop_check_U6(
.stop_check_en(stop_chk_en),
.with_parity(PARITY_ENABLE),
.sampled_bit(sample_bit),
.clk(CLK),
.rst(RST),
.stop_error(frame_error));
  
endmodule


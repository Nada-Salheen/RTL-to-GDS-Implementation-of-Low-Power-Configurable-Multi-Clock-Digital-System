
module TX_TOP# (parameter data_width= 8)(
  
  input wire [data_width-1:0] P_DATA_OUT,
  input wire DATA_VALID_OUT,PAR_EN,PAR_TYP,
  input wire CLK,RST,
  output TX_OUT,BUSY
  );
  wire [2:0] selection_mux;
  wire parity_bit_top;
  wire serial;
  
  FSM_TX FSM_u(
  .data_valid(DATA_VALID_OUT),
  .par_en(PAR_EN),
  .ser_done(ser_done),
  .clk(CLK),
  .rst(RST),
  .ser_en(ser_enable),
  .busy(BUSY),
  .mux_sel(selection_mux));
  
  MUX_TX MUX_u(
  .sel(selection_mux),
  .serial_data(serial),
  .parity(parity_bit_top),
  .clk(CLK),
  .rst(RST),
  .tx_out(TX_OUT));
  
  serializer_tx serializer_u(
  .parallel_data(P_DATA_OUT),
  .ser_enable(ser_enable),
  .data_valid(DATA_VALID_OUT),
  .busy(BUSY),
  .clk(CLK),
  .rst(RST),
  .ser_done(ser_done),
  .serial_data(serial));
  
  parity_cal_tx parity_cal_u(
  .par_typ(PAR_TYP),
  .data_valid_par(DATA_VALID_OUT),
  .parity_enable(PAR_EN),
  .p_data(P_DATA_OUT),
  .clk(CLK),
  .rst(RST),
  .par_bit(parity_bit_top));
  
  endmodule



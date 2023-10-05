module UART_TOP#(parameter data_width=8)(
  
input wire RX_IN_Serial, PARITY_TYP, PARITY_EN, 
input wire [5:0] PRE_SCALE,
input wire RX_CLK,RST,
output DATA_VALID_RX, parity_error, frame_error,
output [data_width-1:0] P_DATA_RX,

input wire [data_width-1:0] P_DATA_TX,
input wire DATA_VALID_TX,
input wire TX_CLK,
output TX_OUT_Serial,BUSY_TX
  
  );
  
TX_TOP TX1(
.P_DATA_OUT(P_DATA_TX),
.DATA_VALID_OUT(DATA_VALID_TX),
.PAR_EN(PARITY_EN),
.PAR_TYP(PARITY_TYP),
.CLK(TX_CLK),
.RST(RST),
.TX_OUT(TX_OUT_Serial),
.BUSY(BUSY_TX)
);

RX_TOP RX1(
.RX_IN(RX_IN_Serial),
.PARITY_TYPE(PARITY_TYP),
.PARITY_ENABLE(PARITY_EN),
.PRESCALE(PRE_SCALE),
.CLK(RX_CLK),
.RST(RST),
.DATA_VALID_IN(DATA_VALID_RX),
.par_err(parity_error),
.frame_error(frame_error),
.P_DATA_IN(P_DATA_RX)
);

endmodule


module System_Top # ( parameter DATA_WIDTH = 8 ,  RF_ADDR = 4 )(
  
 input   wire                          RST_N,
 input   wire                          UART_CLK,
 input   wire                          REF_CLK,
 input   wire                          UART_RX_IN,
 output  wire                          UART_TX_O,
 output  wire                          parity_error,
 output  wire                          framing_error
);

wire                                   SYNC_UART_RST,
                                       SYNC_REF_RST;
									   
wire					               UART_TX_CLK;
wire					               UART_RX_CLK;


wire      [DATA_WIDTH-1:0]             Operand_A,
                                       Operand_B,
									   UART_Config,
									   DIV_RATIO;
									   
wire      [DATA_WIDTH-1:0]             DIV_RATIO_RX;
									   
wire      [DATA_WIDTH-1:0]             UART_RX_OUT;
wire         						   UART_RX_V_OUT;
wire      [DATA_WIDTH-1:0]			   UART_RX_SYNC;
wire                                   UART_RX_V_SYNC;

wire      [DATA_WIDTH-1:0]             UART_TX_IN;
wire        						   UART_TX_VLD;
wire      [DATA_WIDTH-1:0]             UART_TX_SYNC;
wire        						   UART_TX_V_SYNC;

wire                                   UART_TX_Busy;	
wire                                   UART_TX_Busy_PULSE;	
									   
wire                                   RF_WrEn;
wire                                   RF_RdEn;
wire      [RF_ADDR-1:0]                RF_Address;
wire      [DATA_WIDTH-1:0]             RF_WrData;
wire      [DATA_WIDTH-1:0]             RF_RdData;
wire                                   RF_RdData_VLD;									   

wire                                   CLKG_EN;
wire                                   ALU_EN;
wire      [3:0]                        ALU_FUN; 
wire      [DATA_WIDTH*2-1:0]           ALU_OUT;
wire                                   ALU_OUT_VLD; 
									   
wire                                   ALU_CLK ;								   

wire                                   FIFO_FULL ;
	
wire                                   CLKDIV_EN ;
	
///********************************************************///
//////////////////// System Controller ///////////////////////
///********************************************************///

System_FSM U0_SYS_CTRL (
.CLK(REF_CLK),
.RST(SYNC_REF_RST),

.Rd_Data(RF_RdData),
.Rd_Data_Valid(RF_RdData_VLD),

.WrEn(RF_WrEn),
.RdEn(RF_RdEn),
.address(RF_Address),
.WrData(RF_WrData),

.ALU_EN(ALU_EN),
.ALU_FUN(ALU_FUN), 
.ALU_OUT(ALU_OUT),
.OUT_VALID(ALU_OUT_VLD),  
.CLK_EN(CLKG_EN), 

.clk_div_en(CLKDIV_EN),   
.FIFO_FULL(FIFO_FULL),

.RX_P_DATA(UART_RX_SYNC), 
.RX_D_VLD(UART_RX_V_SYNC),

.TX_P_DATA(UART_TX_IN), 
.TX_D_VLD(UART_TX_VLD)
);
								   
///********************************************************///
//////////////////// Reset synchronizers /////////////////////
///********************************************************///

RST_SYNC # (.NUM_STAGES(2)) UART_RST_SYNC (
.RST(RST_N),
.CLK(UART_CLK),
.SYNC_RST(SYNC_UART_RST)
);

RST_SYNC # (.NUM_STAGES(2)) SYS_RST_SYNC (
.RST(RST_N),
.CLK(REF_CLK),
.SYNC_RST(SYNC_REF_RST)
);

///********************************************************///
////////////////////// Data Synchronizer /////////////////////
///********************************************************///

DATA_SYNC # (.NUM_STAGES(2) , .BUS_WIDTH(8)) U0_ref_sync (
.CLK(REF_CLK),
.RST(SYNC_REF_RST),
.unsync_bus(UART_RX_OUT),
.bus_enable(UART_RX_V_OUT),
.sync_bus(UART_RX_SYNC),
.enable_pulse_d(UART_RX_V_SYNC)
);

///********************************************************///
///////////////////////// Async FIFO /////////////////////////
///********************************************************///

Async_fifo #(.D_SIZE(DATA_WIDTH) , .P_SIZE(4)  , .F_DEPTH(8)) U0_UART_FIFO (
.i_w_clk(REF_CLK),
.i_w_rstn(SYNC_REF_RST),  
.i_w_inc(UART_TX_VLD),
.i_w_data(UART_TX_IN),             
.i_r_clk(UART_TX_CLK),              
.i_r_rstn(SYNC_UART_RST),              
.i_r_inc(UART_TX_Busy_PULSE),              
.o_r_data(UART_TX_SYNC),             
.o_full(FIFO_FULL),               
.o_empty(UART_TX_V_SYNC)               
);

///********************************************************///
//////////////////////// Pulse Generator /////////////////////
///********************************************************///

PULSE_GEN U0_PULSE_GEN (
.clk(UART_TX_CLK),
.rst(SYNC_UART_RST),
.lvl_sig(UART_TX_Busy),
.pulse_sig(UART_TX_Busy_PULSE)
);


///********************************************************///
//////////// Clock Divider for UART_TX Clock /////////////////
///********************************************************///

clock_divider U0_ClkDiv (
.i_ref_clk(UART_CLK),             
.i_rst(SYNC_UART_RST),                 
.i_clk_en(CLKDIV_EN),               
.i_div_ratio(DIV_RATIO),           
.o_div_clk(UART_TX_CLK)             
);

///********************************************************///
//////////// Custom Mux Clock /////////////////
///********************************************************///

CLKDIV_MUX U0_CLKDIV_MUX (
.IN(UART_Config[7:2]),
.OUT(DIV_RATIO_RX)
);

///********************************************************///
//////////// Clock Divider for UART_RX Clock /////////////////
///********************************************************///

clock_divider U1_ClkDiv (
.i_ref_clk(UART_CLK),             
.i_rst(SYNC_UART_RST),                 
.i_clk_en(CLKDIV_EN),               
.i_div_ratio(DIV_RATIO_RX),           
.o_div_clk(UART_RX_CLK)             
);

///********************************************************///
/////////////////////////// UART /////////////////////////////
///********************************************************///

UART_TOP  U0_UART (

.RST(SYNC_UART_RST),
.TX_CLK(UART_TX_CLK),
.RX_CLK(UART_RX_CLK),

.PARITY_EN(UART_Config[0]),
.PARITY_TYP(UART_Config[1]),
.PRE_SCALE(UART_Config[7:2]),

.RX_IN_Serial(UART_RX_IN),
.P_DATA_RX(UART_RX_OUT),                      
.DATA_VALID_RX(UART_RX_V_OUT),
                      
.P_DATA_TX(UART_TX_SYNC), 
.DATA_VALID_TX(!UART_TX_V_SYNC),

.TX_OUT_Serial(UART_TX_O),
.BUSY_TX(UART_TX_Busy),
.parity_error(parity_error),
.frame_error(framing_error)                  
);
///********************************************************///
/////////////////////// Register File ////////////////////////
///********************************************************///

Register_file U0_RegFile (
.clk(REF_CLK),
.rst(SYNC_REF_RST),
.WrEn(RF_WrEn),
.RdEn(RF_RdEn),
.Address(RF_Address),
.WrData(RF_WrData),
.RdData(RF_RdData),
.RdData_Valid(RF_RdData_VLD),
.REG0(Operand_A),
.REG1(Operand_B),
.REG2(UART_Config),
.REG3(DIV_RATIO)
);

///********************************************************///
//////////////////////////// ALU /////////////////////////////
///********************************************************///
 
alu_top U0_ALU (
.CLK(ALU_CLK),
.RST(SYNC_REF_RST),  
.A(Operand_A), 
.B(Operand_B),
.ENABLE(ALU_EN),
.Fun_Top(ALU_FUN),
.ALU_OUT(ALU_OUT),
.OUT_VALID(ALU_OUT_VLD)
);

///********************************************************///
///////////////////////// Clock Gating ///////////////////////
///********************************************************///

clock_gate U0_CLK_GATE (
.CLK_EN(CLKG_EN),
.CLK(REF_CLK),
.GATED_CLK(ALU_CLK)
);


endmodule
 
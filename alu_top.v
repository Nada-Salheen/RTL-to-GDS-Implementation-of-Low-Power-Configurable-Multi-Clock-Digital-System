module alu_top#(parameter input_width=8,output_width=16)(
  input wire [input_width-1:0] A,B,
  input wire [3:0] Fun_Top,
  input wire CLK,RST,ENABLE,
  output [output_width-1:0] ALU_OUT,
  //output [width-1:0] CMP_OUT,
  output   OUT_VALID
  );


decoder decoder_u(
.alu_fun_decoder(Fun_Top[3:2]),
.enable_unit(ENABLE),
.arith_enable(arith_enable_alu),
.logic_enable(logic_enable_logic),
.shift_enable(shift_enable_shift),
.cmp_enable(cmp_enable_cmp));

arithmetic_unit arithmetic_u(
.A(A),
.B(B),
.alu_fuc_arith(Fun_Top[1:0]),
.clk(CLK),
.rst(RST),
.arith_enable_alu(arith_enable_alu),
.arith_out_alu(ALU_OUT),
.arith_flag_alu(OUT_VALID));

logic_unit logic_u(
.A(A),
.B(B),
.logic_fuc_logic(Fun_Top[1:0]),
.clk(CLK),
.rst(RST),
.logic_enable_logic(logic_enable_logic),
.logic_out_logic(ALU_OUT),
.logic_flag_logic(OUT_VALID));

compare_unit compare_u(
.A(A),
.B(B),
.cmp_fuc_cmp(Fun_Top[1:0]),
.clk(CLK),
.rst(RST),
.cmp_enable_cmp(cmp_enable_cmp),
.cmp_out_cmp(ALU_OUT),
.cmp_flag_cmp(OUT_VALID));

shift_unit shift_u(
.A(A),
.B(B),
.shift_fuc_shift(Fun_Top[1:0]),
.clk(CLK),
.rst(RST),
.shift_enable_shift(shift_enable_shift),
.shift_out_shift(ALU_OUT),
.shift_flag_shift(OUT_VALID));

endmodule

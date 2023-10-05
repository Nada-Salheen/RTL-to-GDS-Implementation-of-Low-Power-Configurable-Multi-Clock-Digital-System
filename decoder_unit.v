
module decoder(
  input wire [1:0] alu_fun_decoder,
  input enable_unit,
  output reg arith_enable,logic_enable,shift_enable,cmp_enable
  );

always@(*)
  begin

    if(enable_unit)
      begin
    case(alu_fun_decoder)
      2'b00: begin
        arith_enable=1'b1;
      end
      2'b01: begin
        logic_enable=1'b1;
      end
      2'b10: begin
        cmp_enable=1'b1;
      end
       2'b11: begin
        shift_enable=1'b1;
      end
      default: begin
        arith_enable=1'b0;
        logic_enable=1'b0;
        shift_enable=1'b0;
        cmp_enable=1'b0;
      end
    endcase
  end
else
  begin
    arith_enable=1'b0;
    logic_enable=1'b0;
    shift_enable=1'b0;
    cmp_enable=1'b0;
  end
  end
endmodule
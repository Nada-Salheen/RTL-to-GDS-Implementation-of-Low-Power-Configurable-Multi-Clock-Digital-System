module arithmetic_unit#(parameter input_width=8,output_width=16)(
  input wire [input_width-1:0] A,B,
  input wire [1:0] alu_fuc_arith,
  input wire clk,rst,arith_enable_alu,
  output reg [output_width-1:0] arith_out_alu,
  //output reg carry_out_alu,
  output reg arith_flag_alu
  );
  
  always@(posedge clk or negedge rst)
    begin
      if(!rst)
        begin
          arith_out_alu<=0;
          //carry_out_alu<=1'b0;
          arith_flag_alu<= 1'b0;
        end
      else if(arith_enable_alu)
        begin
          arith_flag_alu<= 1'b1;
          case(alu_fuc_arith)
            2'b00: begin
              arith_out_alu<=A+B;
          end
            2'b01: begin
              arith_out_alu<=A-B;
          end
            2'b10: begin
              arith_out_alu<=A*B;
          end
            2'b11: begin
             arith_out_alu<=A/B;
          end
          default: begin
            arith_out_alu<=0;
          end
          endcase
       end
     else
       begin
         arith_out_alu<=0;
         arith_flag_alu<= 1'b0;
       end
     end

endmodule

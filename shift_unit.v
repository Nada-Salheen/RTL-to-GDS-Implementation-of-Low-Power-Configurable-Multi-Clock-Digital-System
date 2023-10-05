module shift_unit#(parameter input_width=8,output_width=16)(
  input wire [input_width-1:0] A,B,
  input wire [1:0] shift_fuc_shift,
  input wire clk,rst,shift_enable_shift,
  output reg [output_width-1:0] shift_out_shift,
  output reg shift_flag_shift
  );
always@(posedge clk or negedge rst)
    begin
      if(!rst)
        begin
          shift_out_shift<=0;
          shift_flag_shift<=1'b0;
        end
      else if(shift_enable_shift)
        begin
          shift_flag_shift<=1'b1;
          case(shift_fuc_shift)
            2'b00: begin
            shift_out_shift<= (A>>1);
          end
            2'b01: begin
            shift_out_shift<= (A<<1);
          end
            2'b10: begin
            shift_out_shift<=(B>>1);
          end
            2'b11: begin
            shift_out_shift<=(B<<1);
          end
          default: begin
            shift_out_shift<=0;
          end
          endcase
       end
     else
       begin
         shift_out_shift<=0;
         shift_flag_shift<=1'b0;
       end
     end

endmodule

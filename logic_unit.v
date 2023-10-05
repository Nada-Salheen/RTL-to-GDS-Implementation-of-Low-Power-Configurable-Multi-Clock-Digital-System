module logic_unit#(parameter input_width=8,output_width=16)(
  input wire [input_width-1:0] A,B,
  input wire [1:0] logic_fuc_logic,
  input wire clk,rst,logic_enable_logic,
  output reg [output_width-1:0] logic_out_logic,
  output reg logic_flag_logic
  );
always@(posedge clk or negedge rst)
    begin
      if(!rst)
        begin
          logic_out_logic<=0;
          logic_flag_logic<=1'b0;
        end
      else if(logic_enable_logic)
        begin
          logic_flag_logic<=1'b1;
          case(logic_fuc_logic)
            2'b00: begin
            logic_out_logic<=A&B;
          end
            2'b01: begin
            logic_out_logic<=A|B;
          end
            2'b10: begin
            logic_out_logic<=~(A&B);
          end
            2'b11: begin
            logic_out_logic<=~(A|B);
          end
          default: begin
            logic_out_logic<=0;
          end
          endcase
       end
     else
       begin
         logic_out_logic<=0;
         logic_flag_logic<=1'b0;
       end
     end

endmodule

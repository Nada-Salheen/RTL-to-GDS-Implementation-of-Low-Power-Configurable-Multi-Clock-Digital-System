module compare_unit#(parameter input_width=8, output_width=16)(
  input wire [input_width-1:0] A,B,
  input wire [1:0] cmp_fuc_cmp,
  input wire clk,rst,cmp_enable_cmp,
  output reg [output_width-1:0] cmp_out_cmp,
  output reg cmp_flag_cmp
  );
always@(posedge clk or negedge rst)
    begin
      if(!rst)
        begin
          cmp_out_cmp<=0;
          cmp_flag_cmp<=1'b0;
        end
      else if(cmp_enable_cmp)
        begin
          cmp_flag_cmp<=1'b1;
          case(cmp_fuc_cmp)
            2'b01: begin
              if(A==B)
                begin
                  cmp_out_cmp<=1;
                end
              else
                begin
                 cmp_out_cmp<=0;
                end
            end
            2'b10: begin
              if(A>B)
                begin
                  cmp_out_cmp<=2;
                end
              else
                begin
                 cmp_out_cmp<='d0;
                end
           end
            2'b11: begin
              if(A<B)
                begin
                  cmp_out_cmp<='d3;
                end
              else
                begin
                 cmp_out_cmp<='d0;
                end
          end
            default: begin
              cmp_out_cmp<=0;
          end
        endcase
       end
     else
       begin
         cmp_out_cmp<='d0;
         cmp_flag_cmp<=1'b0;
       end
     end

endmodule

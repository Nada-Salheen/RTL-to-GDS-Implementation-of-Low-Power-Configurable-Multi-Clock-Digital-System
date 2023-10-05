
module parity_cal_tx# (parameter data_width= 8, even_parity=0,odd_parity=1)(
  
  input wire par_typ, parity_enable,data_valid_par,
  input wire [data_width-1:0] p_data,
  input wire clk,rst,
  output reg  par_bit
  );
  
  reg temp;
  
always@(posedge clk or negedge rst)
  begin
    if(!rst)
      begin
        par_bit<=1'b0;
      end

   else
	if((parity_enable) && ((par_typ==even_parity)||(par_typ==odd_parity)))
        begin
          
          if(par_typ == even_parity)
            begin
              case(temp)
                
                0: begin
                  par_bit<=1'b0;
                end
                
                1: begin
                  par_bit<=1'b1;
                end
              endcase
            end
         
          else
            begin
              case(temp)
                
                0: begin
                  par_bit<=1'b1;
                end
                
                1: begin
                  par_bit<=1'b0;
                end
              endcase
            end
       end
    else
          begin
            par_bit<=par_bit;
          end

      end
always@(posedge clk or negedge rst)
	begin
	 if(!rst)
	   begin
        temp<= 'b0;
	   end
    else if(data_valid_par)
      begin
        temp<= ^p_data;       
      end
      end
endmodule
              


